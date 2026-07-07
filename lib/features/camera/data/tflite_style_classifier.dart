import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class TfliteStyleClassifier {
  TfliteStyleClassifier({
    this.modelAssetPath = 'assets/model.tflite',
    this.labelsAssetPath = 'assets/labels.txt',
  });

  static const confidenceThreshold = 0.9;

  final String modelAssetPath;
  final String labelsAssetPath;

  Interpreter? _interpreter;
  List<String> _labels = const [];

  Future<void> initialize() async {
    _interpreter ??= await Interpreter.fromAsset(modelAssetPath);
    if (_labels.isEmpty) {
      final contents = await rootBundle.loadString(labelsAssetPath);
      _labels = contents
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList(growable: false);
    }
  }

  Future<StyleRecognition?> classify(
    CameraImage image, {
    required int sensorOrientation,
  }) async {
    final interpreter = _interpreter;
    if (interpreter == null || _labels.isEmpty) {
      return null;
    }

    final inputTensor = interpreter.getInputTensor(0);
    final inputShape = inputTensor.shape;
    if (inputShape.length != 4) {
      return null;
    }

    final inputHeight = inputShape[1];
    final inputWidth = inputShape[2];
    final sourceImage = _cameraImageToRgb(image);
    if (sourceImage == null) {
      return null;
    }

    final rotatedImage = sensorOrientation == 0
        ? sourceImage
        : img.copyRotate(sourceImage, angle: sensorOrientation);
    final squareImage = img.copyResizeCropSquare(
      rotatedImage,
      size: math.min(rotatedImage.width, rotatedImage.height),
    );
    final resizedImage = img.copyResize(
      squareImage,
      width: inputWidth,
      height: inputHeight,
      interpolation: img.Interpolation.linear,
    );

    final input = _buildInput(resizedImage, inputTensor.type);
    final outputTensor = interpreter.getOutputTensor(0);
    final outputLength = outputTensor.shape.last;
    final output = [List<num>.filled(outputLength, 0)];

    interpreter.run(input, output);

    final scores = _normalizeScores(output.first, outputTensor);
    if (scores.isEmpty) {
      return null;
    }

    var bestIndex = 0;
    var bestScore = scores.first;
    for (var index = 1; index < scores.length; index += 1) {
      if (scores[index] > bestScore) {
        bestIndex = index;
        bestScore = scores[index];
      }
    }

    if (bestIndex >= _labels.length || bestScore < confidenceThreshold) {
      return null;
    }

    return StyleRecognition(style: _labels[bestIndex], confidence: bestScore);
  }

  Object _buildInput(img.Image image, TensorType tensorType) {
    return [
      List.generate(image.height, (y) {
        return List.generate(image.width, (x) {
          final pixel = image.getPixel(x, y);
          final red = pixel.r.toInt();
          final green = pixel.g.toInt();
          final blue = pixel.b.toInt();

          if (tensorType == TensorType.float32) {
            return [red / 255.0, green / 255.0, blue / 255.0];
          }

          return [red, green, blue];
        }, growable: false);
      }, growable: false),
    ];
  }

  List<double> _normalizeScores(List<num> output, Tensor outputTensor) {
    if (outputTensor.type == TensorType.uint8 ||
        outputTensor.type == TensorType.int8) {
      final params = outputTensor.params;
      return output
          .map((value) => (value.toDouble() - params.zeroPoint) * params.scale)
          .toList(growable: false);
    }

    return output.map((value) => value.toDouble()).toList(growable: false);
  }

  img.Image? _cameraImageToRgb(CameraImage cameraImage) {
    if (cameraImage.format.group == ImageFormatGroup.yuv420) {
      return _yuv420ToImage(cameraImage);
    }

    if (cameraImage.format.group == ImageFormatGroup.bgra8888) {
      return _bgra8888ToImage(cameraImage);
    }

    return null;
  }

  img.Image _bgra8888ToImage(CameraImage cameraImage) {
    final image = img.Image(
      width: cameraImage.width,
      height: cameraImage.height,
    );
    final bytes = cameraImage.planes.first.bytes;

    for (var y = 0; y < cameraImage.height; y += 1) {
      for (var x = 0; x < cameraImage.width; x += 1) {
        final offset = y * cameraImage.planes.first.bytesPerRow + x * 4;
        image.setPixelRgb(
          x,
          y,
          bytes[offset + 2],
          bytes[offset + 1],
          bytes[offset],
        );
      }
    }

    return image;
  }

  img.Image _yuv420ToImage(CameraImage cameraImage) {
    final width = cameraImage.width;
    final height = cameraImage.height;
    final image = img.Image(width: width, height: height);
    final yPlane = cameraImage.planes[0];
    final uPlane = cameraImage.planes[1];
    final vPlane = cameraImage.planes[2];
    final uvPixelStride = uPlane.bytesPerPixel ?? 1;

    for (var y = 0; y < height; y += 1) {
      for (var x = 0; x < width; x += 1) {
        final yIndex = y * yPlane.bytesPerRow + x;
        final uvIndex =
            (y ~/ 2) * uPlane.bytesPerRow + (x ~/ 2) * uvPixelStride;

        final yValue = yPlane.bytes[yIndex];
        final uValue = uPlane.bytes[uvIndex];
        final vValue = vPlane.bytes[uvIndex];

        final red = (yValue + 1.402 * (vValue - 128)).round().clamp(0, 255);
        final green =
            (yValue - 0.344136 * (uValue - 128) - 0.714136 * (vValue - 128))
                .round()
                .clamp(0, 255);
        final blue = (yValue + 1.772 * (uValue - 128)).round().clamp(0, 255);

        image.setPixelRgb(x, y, red, green, blue);
      }
    }

    return image;
  }

  void close() {
    _interpreter?.close();
    _interpreter = null;
  }
}

class StyleRecognition {
  const StyleRecognition({required this.style, required this.confidence});

  final String style;
  final double confidence;
}
