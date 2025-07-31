import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:strukit/core/themes/app_theme.dart';
import 'package:strukit/core/widgets/grid_painter.dart';
import 'package:strukit/core/widgets/loading_progress_widget.dart';
import 'package:strukit/core/widgets/scan_animation_widget.dart';
import 'package:strukit/pages/scanned_receipt_page.dart';

class ScannerPage extends StatefulWidget {
  final XFile file;
  const ScannerPage({super.key, required this.file});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage>
    with TickerProviderStateMixin {
  bool isScanning = false;
  Uint8List? byte;
  bool hasError = false;
  String? errorMessage;
  bool isCompleted = false;

  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _scanController;

  final List<String> processingMessages = [
    'Memindai struktur dokumen...',
    'Mengidentifikasi teks dan angka...',
    'Mengenali item dan harga...',
    'Menganalisis pola data...',
    'Memvalidasi informasi...',
    'Menyusun hasil akhir...',
  ];

  int currentMessageIndex = 0;
  Timer? _messageTimer;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initImage().then((value) {
        _startAIAnalysis();
      });
    });
  }

  void _initAnimations() {
    _pulseController = AnimationController(duration: 1.seconds, vsync: this)
      ..repeat(reverse: true);

    _rotationController = AnimationController(duration: 3.seconds, vsync: this)
      ..repeat();

    _scanController = AnimationController(duration: 1500.ms, vsync: this)
      ..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _scanController.dispose();
    _messageTimer?.cancel();
    super.dispose();
  }

  Future<void> initImage() async {
    final byte = await widget.file.readAsBytes();
    setState(() {
      this.byte = byte;
    });
  }

  Future<void> _startAIAnalysis() async {
    setState(() {
      isScanning = true;
      hasError = false;
      errorMessage = null;
      isCompleted = false;
      currentMessageIndex = 0;
    });

    try {
      // Start message cycling
      _startMessageCycling();

      // Compress image
      await _compressImage();

      // Extract text
      await _extractText();

      // Simulate AI analysis with realistic timing
      await _simulateAIAnalysis();

      setState(() {
        isCompleted = true;
      });

      // // Wait a bit before navigation
      await Future.delayed(const Duration(milliseconds: 1500));
      _navigateToResult();
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = e.toString();
        isScanning = false;
      });
      _messageTimer?.cancel();
    }
  }

  void _startMessageCycling() {
    _messageTimer = Timer.periodic(const Duration(milliseconds: 1400), (timer) {
      if (mounted && isScanning && !hasError && !isCompleted) {
        setState(() {
          currentMessageIndex =
              (currentMessageIndex + 1) % processingMessages.length;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _compressImage() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final compressedImage = await FlutterImageCompress.compressWithList(
      byte!,
      quality: 75,
      format: CompressFormat.jpeg,
    );
    setState(() {
      byte = compressedImage;
    });
  }

  Future<String> _extractText() async {
    await Future.delayed(const Duration(milliseconds: 800));
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final inputImage = InputImage.fromFile(File(widget.file.path));
    final RecognizedText recognizedText = await textRecognizer.processImage(
      inputImage,
    );

    String text = recognizedText.text;
    print("""
    ### DATA OCR ###
    $text
    ### end DATA OCR ###  
    """);

    return text;
  }

  Future<void> _simulateAIAnalysis() async {
    // Simulate realistic AI processing time
    await Future.delayed(const Duration(milliseconds: 3000));
  }

  void _navigateToResult() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ScannedReceiptPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scanHeight = size.height / 1.5;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              // Header
              _buildHeader(),

              const SizedBox(height: 20),

              // Image Container with AI Processing Animation
              Container(
                    width: size.width,
                    height: scanHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.toOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          // Background Image
                          if (byte != null)
                            Image.memory(
                              byte!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ).animate().fadeIn(duration: 800.ms),

                          // Gradient Overlay
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.toOpacity(0.3),
                                ],
                              ),
                            ),
                          ),

                          // AI Scan Animation (only show when processing)
                          if (isScanning && !hasError && !isCompleted)
                            _buildAIScanAnimation(scanHeight),

                          // Processing Overlay
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: _buildProcessingOverlay(),
                          ),
                        ],
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 600.ms)
                  .slideY(begin: 0.2),

              const SizedBox(height: 30),

              // Cancel Button
              _buildCancelButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF424242)),
        ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.3),

        const SizedBox(width: 8),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hasError
                    ? 'Processing Error'
                    : isCompleted
                    ? 'Analisis Selesai'
                    : 'AI Analisis Data',
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: hasError ? Colors.red[700] : const Color(0xFF212121),
                ),
              ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2),

              Text(
                    hasError
                        ? 'Terjadi kesalahan saat memproses'
                        : isCompleted
                        ? 'Data berhasil dianalisis'
                        : 'Sebentar ya, data Anda sedang diproses...',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 600.ms)
                  .slideY(begin: -0.2),
            ],
          ),
        ),

        Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    (hasError
                            ? AppColors.error
                            : isCompleted
                            ? AppColors.success
                            : AppColors.secondary)
                        .toOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: AnimatedBuilder(
                animation: _rotationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: (isScanning && !hasError && !isCompleted)
                        ? _rotationController.value * 2 * pi
                        : 0,
                    child: Icon(
                      hasError
                          ? Icons.error
                          : isCompleted
                          ? Icons.check_circle
                          : Icons.auto_awesome,
                      color: hasError
                          ? AppColors.error
                          : isCompleted
                          ? AppColors.success
                          : AppColors.secondary,
                      size: 20,
                    ),
                  );
                },
              ),
            )
            .animate()
            .fadeIn(delay: 400.ms, duration: 500.ms)
            .scale(begin: const Offset(0.8, 0.8)),
      ],
    );
  }

  Widget _buildAIScanAnimation(double scanHeight) {
    return Stack(
      children: [
        // Moving scan line
        ScanAnimation(parentHeight: scanHeight),

        // AI Processing Grid
        Positioned.fill(
          child: CustomPaint(
            painter: GridPainter(
              animation: _pulseController,
              color: AppColors.secondary.toOpacity(0.3),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProcessingOverlay() {
    if (hasError) {
      return _buildErrorOverlay();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.dark.toOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.toOpacity(0.2), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // AI Analysis Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondary.toOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: (isScanning && !isCompleted)
                      ? _rotationController.value * 2 * pi
                      : 0,
                  child: Icon(
                    isCompleted ? Icons.check_circle : Icons.auto_awesome,
                    color: isCompleted
                        ? const Color(0xFF4CAF50)
                        : AppColors.secondary,
                    size: 24,
                  ),
                );
              },
            ),
          ).animate().scale(
            begin: const Offset(0.5, 0.5),
            duration: 800.ms,
            curve: Curves.elasticOut,
          ),

          const SizedBox(height: 16),

          // Title
          Text(
                isCompleted ? 'Analisis Selesai!' : 'AI Analisis Data',
                style: TextStyle(
                  color: isCompleted ? const Color(0xFF4CAF50) : Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              )
              .animate()
              .fadeIn(delay: 400.ms, duration: 600.ms)
              .slideY(begin: 0.3),

          const SizedBox(height: 8),

          // Dynamic processing message
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.4),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              isCompleted
                  ? 'Data berhasil diproses dan siap ditampilkan'
                  : processingMessages[currentMessageIndex],
              key: ValueKey(isCompleted ? 'completed' : currentMessageIndex),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.toOpacity(0.8),
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 20),

          CustomLinearProgressIndicator(isComplete: isCompleted),
        ],
      ),
    ).animate().slideY(begin: 0.5, duration: 800.ms, curve: Curves.easeOutBack);
  }

  Widget _buildErrorOverlay() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.error.toOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.toOpacity(0.2), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.toOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.error, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Processing Failed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      errorMessage ?? 'Terjadi kesalahan saat memproses',
                      style: TextStyle(
                        color: Colors.white.toOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _startAIAnalysis(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.error,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Coba Lagi',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 0.5, duration: 600.ms);
  }

  Widget _buildCancelButton() {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.pop(context),
          child: Center(
            child: Text(
              'Batalkan',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 800.ms, duration: 600.ms).slideY(begin: 0.3);
  }
}
