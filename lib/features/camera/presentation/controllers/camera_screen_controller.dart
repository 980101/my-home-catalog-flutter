import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:my_home_catalog_flutter/features/camera/data/style_history_repository.dart';
import 'package:my_home_catalog_flutter/features/camera/data/tflite_style_classifier.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreenController extends ChangeNotifier {
  CameraScreenController({
    required this.type,
    required StyleHistoryRepository historyRepository,
    required TfliteStyleClassifier classifier,
  }) : _historyRepository = historyRepository,
       _classifier = classifier;

  final String type;
  final StyleHistoryRepository _historyRepository;
  final TfliteStyleClassifier _classifier;

  CameraController? _cameraController;
  List<String> _history = const [];
  String? _recognitionStyle;
  String? _message;
  String? _errorMessage;
  bool _isInitializing = true;
  bool _hasPermission = false;
  bool _isProcessingFrame = false;
  bool _isDisposed = false;
  DateTime? _lastInferenceAt;

  CameraController? get cameraController => _cameraController;
  List<String> get history => List.unmodifiable(_history);
  String? get recognitionStyle => _recognitionStyle;
  String? get message => _message;
  String? get errorMessage => _errorMessage;
  bool get isInitializing => _isInitializing;
  bool get hasPermission => _hasPermission;
  bool get isReady => _cameraController?.value.isInitialized ?? false;

  Future<void> initialize() async {
    _isInitializing = true;
    _errorMessage = null;
    _notify();

    try {
      _history = await _historyRepository.loadStyles();
      final permission = await Permission.camera.request();
      _hasPermission = permission.isGranted;

      if (!_hasPermission) {
        _message = 'Camera permission is required for this demo';
        _isInitializing = false;
        _notify();
        return;
      }

      await _classifier.initialize();
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _errorMessage = 'Failed';
        _isInitializing = false;
        _notify();
        return;
      }

      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final cameraController = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      _cameraController = cameraController;
      await cameraController.initialize();
      await cameraController.startImageStream(_processImage);
    } on Object catch (error) {
      _errorMessage = 'Failed: $error';
    } finally {
      _isInitializing = false;
      _notify();
    }
  }

  Future<void> capture({
    required void Function(String style, String type) onRecognized,
  }) async {
    final style = _recognitionStyle;
    if (style == null || style.isEmpty) {
      return;
    }

    _history = await _historyRepository.saveStyle(style);
    _notify();
    onRecognized(style, type);
  }

  Future<void> openHistoryStyle({
    required String style,
    required void Function(String style, String type) onSelected,
  }) async {
    onSelected(style, type);
  }

  Future<void> deleteHistoryStyle(String style) async {
    _history = await _historyRepository.deleteStyle(style);
    _notify();
  }

  void clearMessage() {
    _message = null;
  }

  Future<void> _processImage(CameraImage image) async {
    if (_isProcessingFrame || _isDisposed) {
      return;
    }

    final now = DateTime.now();
    final lastInferenceAt = _lastInferenceAt;
    if (lastInferenceAt != null &&
        now.difference(lastInferenceAt) < const Duration(milliseconds: 800)) {
      return;
    }

    _isProcessingFrame = true;
    _lastInferenceAt = now;

    try {
      final sensorOrientation =
          _cameraController?.description.sensorOrientation ?? 0;
      final recognition = await _classifier.classify(
        image,
        sensorOrientation: sensorOrientation,
      );
      if (recognition != null &&
          recognition.confidence >= TfliteStyleClassifier.confidenceThreshold) {
        _recognitionStyle = recognition.style;
        _notify();
      }
    } catch (_) {
      // Frame-level inference failures are ignored to keep the camera preview alive.
    } finally {
      _isProcessingFrame = false;
    }
  }

  void _notify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    unawaited(_disposeCamera());
    _classifier.close();
    super.dispose();
  }

  Future<void> _disposeCamera() async {
    final controller = _cameraController;
    if (controller != null) {
      if (controller.value.isStreamingImages) {
        await controller.stopImageStream();
      }
      await controller.dispose();
    }
  }
}
