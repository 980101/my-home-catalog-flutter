import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:my_home_catalog_flutter/app/router/app_routes.dart';
import 'package:my_home_catalog_flutter/app/theme/app_colors.dart';
import 'package:my_home_catalog_flutter/app/theme/app_spacing.dart';
import 'package:my_home_catalog_flutter/app/theme/app_text_styles.dart';
import 'package:my_home_catalog_flutter/core/constants/catalog_options.dart';
import 'package:my_home_catalog_flutter/features/camera/data/style_history_repository.dart';
import 'package:my_home_catalog_flutter/features/camera/data/tflite_style_classifier.dart';
import 'package:my_home_catalog_flutter/features/camera/presentation/controllers/camera_screen_controller.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({
    required this.type,
    required this.historyRepository,
    required this.classifier,
    super.key,
  });

  factory CameraScreen.fromRoute(
    RouteSettings settings, {
    required StyleHistoryRepository historyRepository,
    required TfliteStyleClassifier classifier,
  }) {
    final arguments = settings.arguments;
    final type = arguments is Map ? arguments['type'] : null;

    return CameraScreen(
      type: type is String ? type : CatalogOptions.allType,
      historyRepository: historyRepository,
      classifier: classifier,
    );
  }

  final String type;
  final StyleHistoryRepository historyRepository;
  final TfliteStyleClassifier classifier;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CameraScreenController(
        type: type,
        historyRepository: historyRepository,
        classifier: classifier,
      )..initialize(),
      child: const _CameraView(),
    );
  }
}

class _CameraView extends StatelessWidget {
  const _CameraView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CameraScreenController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final message = controller.message;
      if (message == null || !context.mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      context.read<CameraScreenController>().clearMessage();
    });

    return Scaffold(
      appBar: AppBar(title: const Text('CameraPage')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _CameraPreviewPanel(controller: controller)),
            _CameraBottomPanel(controller: controller),
          ],
        ),
      ),
    );
  }
}

class _CameraPreviewPanel extends StatelessWidget {
  const _CameraPreviewPanel({required this.controller});

  final CameraScreenController controller;

  @override
  Widget build(BuildContext context) {
    final cameraController = controller.cameraController;
    if (controller.isInitializing) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!controller.hasPermission) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Text(
            'Camera permission is required for this demo',
            style: AppTextStyles.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (controller.errorMessage != null ||
        cameraController == null ||
        !controller.isReady) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Text(
            controller.errorMessage ?? 'Failed',
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ColoredBox(
      color: Colors.black,
      child: ClipRect(
        child: SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            alignment: Alignment.center,
            child: Builder(
              builder: (context) {
                final displaySize = cameraPreviewDisplaySize(
                  previewSize: cameraController.value.previewSize,
                  aspectRatio: cameraController.value.aspectRatio,
                  orientation: MediaQuery.orientationOf(context),
                );

                return SizedBox.fromSize(
                  size: displaySize,
                  child: AspectRatio(
                    aspectRatio: displaySize.aspectRatio,
                    child: CameraPreview(cameraController),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

Size cameraPreviewDisplaySize({
  required Size? previewSize,
  required double aspectRatio,
  required Orientation orientation,
}) {
  final validPreviewSize =
      previewSize != null && previewSize.width > 0 && previewSize.height > 0
      ? previewSize
      : Size(aspectRatio, 1);
  final landscapeSize = validPreviewSize.width >= validPreviewSize.height
      ? validPreviewSize
      : Size(validPreviewSize.height, validPreviewSize.width);

  return orientation == Orientation.portrait
      ? Size(landscapeSize.height, landscapeSize.width)
      : landscapeSize;
}

class _CameraBottomPanel extends StatelessWidget {
  const _CameraBottomPanel({required this.controller});

  final CameraScreenController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            controller.recognitionStyle ?? '인식된 스타일 없음',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          _HistoryList(controller: controller),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<CameraScreenController>().capture(
                  onRecognized: (style, type) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.home,
                      (route) => false,
                      arguments: {'style': style, 'type': type},
                    );
                  },
                );
              },
              child: const Text('촬영하기'),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.controller});

  final CameraScreenController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.history.isEmpty) {
      return const Text('최근 인식한 스타일이 없습니다.', style: AppTextStyles.bodyMedium);
    }

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.history.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final style = controller.history[index];
          return DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppRadius.small),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    context.read<CameraScreenController>().openHistoryStyle(
                      style: style,
                      onSelected: (selectedStyle, type) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.home,
                          (route) => false,
                          arguments: {'style': selectedStyle, 'type': type},
                        );
                      },
                    );
                  },
                  child: Text(style),
                ),
                IconButton(
                  onPressed: () {
                    context.read<CameraScreenController>().deleteHistoryStyle(
                      style,
                    );
                  },
                  icon: const Icon(Icons.close, size: 18),
                  tooltip: '히스토리 삭제',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
