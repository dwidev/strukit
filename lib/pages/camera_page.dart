import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:strukit/core/themes/app_theme.dart';
import 'package:strukit/core/widgets/camera_button_widget.dart';
import 'package:strukit/core/widgets/gallery_picker_button_widget.dart';
import 'package:strukit/pages/scanner_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? cameraController;
  bool isScanning = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initCamera();
    });
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
    );

    cameraController = CameraController(
      backCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    cameraController
        ?.initialize()
        .then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
        })
        .catchError((Object e) {
          if (e is CameraException) {
            switch (e.code) {
              case 'CameraAccessDenied':
                // Handle access errors here.
                break;
              default:
                // Handle other errors here.
                break;
            }
          }
        });
  }

  void _navigateToScanner(XFile file) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScannerPage(file: file)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          if (cameraController == null) ...[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppTheme.getGradients(context),
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(child: CircularProgressIndicator.adaptive()),
            ),
          ] else ...[
            Positioned.fill(
              child: AspectRatio(
                aspectRatio: cameraController!.value.aspectRatio,
                child: CameraPreview(cameraController!),
              ),
            ),
          ],
          Column(
            children: [
              SafeArea(top: true, bottom: false, child: _Header()),

              // Camera View
              Expanded(
                child: Column(
                  children: [
                    Expanded(child: ReceiptFrame()),
                    SizedBox(height: 20),
                    SafeArea(
                      top: false,
                      bottom: true,
                      child: SizedBox(
                        width: size.width,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedCameraButton(
                              onPressed: () async {
                                cameraController?.pausePreview();
                                final file = await cameraController
                                    ?.takePicture();
                                cameraController?.resumePreview();
                                if (file != null) {
                                  _navigateToScanner(file);
                                }
                              },
                            ),
                            Positioned(right: 50, child: GalleryPickerButton()),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReceiptFrame extends StatelessWidget {
  const ReceiptFrame({super.key, required});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.lightTextTertiary.toOpacity(0.2),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 32,
            left: 32,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: AppColors.primaryVariant, width: 2),
                  top: BorderSide(color: AppColors.primaryVariant, width: 2),
                ),
              ),
            ),
          ),
          Positioned(
            top: 32,
            right: 32,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: AppColors.primaryVariant, width: 2),
                  top: BorderSide(color: AppColors.primaryVariant, width: 2),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 32,
            left: 32,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: AppColors.primaryVariant, width: 2),
                  bottom: BorderSide(color: AppColors.primaryVariant, width: 2),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 32,
            right: 32,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: AppColors.primaryVariant, width: 2),
                  bottom: BorderSide(color: AppColors.primaryVariant, width: 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Scan Receipt',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class ScanGuide extends StatelessWidget {
  const ScanGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(10),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withAlpha(20), width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.qr_code_scanner, color: Colors.white, size: 48),
            const SizedBox(height: 16),
            Text(
              'Arahkan ke struk',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pastikan teks terlihat jelas',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withAlpha(80),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
