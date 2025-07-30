import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:strukit/core/themes/app_theme.dart';
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
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    _scanController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
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
      final extractedText = await _extractText();

      // Simulate AI analysis with realistic timing
      await _simulateAIAnalysis();

      setState(() {
        isCompleted = true;
      });

      // Wait a bit before navigation
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
    await Future.delayed(const Duration(milliseconds: 6000));
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
                style: TextStyle(
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
                        : 'Harap tunggu sebentar...',
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
                            ? Colors.red
                            : isCompleted
                            ? Colors.green
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
                          ? Colors.red
                          : isCompleted
                          ? Colors.green
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
        AnimatedBuilder(
          animation: _scanController,
          builder: (context, child) {
            return Positioned(
              top: _scanController.value * (scanHeight - 100),
              left: 20,
              right: 20,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.secondary,
                      Color(0xFF64B5F6),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.toOpacity(0.6),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        // AI Processing Grid
        Positioned.fill(
          child: CustomPaint(
            painter: AIGridPainter(
              animation: _pulseController,
              color: AppColors.secondary.toOpacity(0.3),
            ),
          ),
        ),

        // Corner detection markers
        ...List.generate(4, (index) {
          final positions = [
            {'top': 30.0, 'left': 30.0},
            {'top': 30.0, 'right': 30.0},
            {'bottom': 120.0, 'left': 30.0},
            {'bottom': 120.0, 'right': 30.0},
          ];

          return Positioned(
            top: positions[index]['top'],
            left: positions[index]['left'],
            right: positions[index]['right'],
            bottom: positions[index]['bottom'],
            child:
                Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF4CAF50),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: index == 0
                              ? const Radius.circular(8)
                              : Radius.zero,
                          topRight: index == 1
                              ? const Radius.circular(8)
                              : Radius.zero,
                          bottomLeft: index == 2
                              ? const Radius.circular(8)
                              : Radius.zero,
                          bottomRight: index == 3
                              ? const Radius.circular(8)
                              : Radius.zero,
                        ),
                      ),
                    )
                    .animate(delay: (index * 150).ms)
                    .fadeIn(duration: 600.ms)
                    .scale(begin: const Offset(0.5, 0.5))
                    .then()
                    .shimmer(
                      duration: 2000.ms,
                      color: Colors.white.toOpacity(0.5),
                    ),
          );
        }),
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
        color: Colors.black.toOpacity(0.85),
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
                    begin: const Offset(0, 0.3),
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

          // Loading indicator (only when processing)
          if (!isCompleted)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                    )
                    .animate(delay: (index * 200).ms)
                    .fadeIn(duration: 600.ms)
                    .then(delay: 400.ms)
                    .shimmer(
                      duration: 1500.ms,
                      color: Colors.white.toOpacity(0.8),
                    )
                    .animate(onPlay: (controller) => controller.repeat());
              }),
            ),
        ],
      ),
    ).animate().slideY(begin: 0.5, duration: 800.ms, curve: Curves.easeOutBack);
  }

  Widget _buildErrorOverlay() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.toOpacity(0.9),
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
                foregroundColor: Colors.red,
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

// Custom painter for AI grid effect
class AIGridPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  AIGridPainter({required this.animation, required this.color})
    : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.toOpacity(0.3 + (animation.value * 0.4))
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const gridSize = 30.0;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// import 'dart:async';
// import 'dart:io';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

// import 'package:strukit/core/themes/app_theme.dart';
// import 'package:strukit/core/widgets/scan_animation_widget.dart';
// import 'package:strukit/pages/scanned_receipt_page.dart';

// class ScannerPage extends StatefulWidget {
//   final XFile file;
//   const ScannerPage({super.key, required this.file});

//   @override
//   State<ScannerPage> createState() => _ScannerPageState();
// }

// class _ScannerPageState extends State<ScannerPage> {
//   bool isScanning = false;
//   Uint8List? byte;
//   int currentStepIndex = 0;
//   double progressValue = 0.0;
//   bool hasError = false;
//   String? errorMessage;
//   String currentProcessMessage = '';

//   // Progress tracking
//   StreamSubscription? _progressSubscription;

//   final List<Map<String, dynamic>> processingSteps = [
//     {
//       'title': 'Kompres Gambar',
//       'description': 'Mengoptimalkan gambar...',
//       'icon': Icons.compress,
//       'function': 'compressImage',
//       'weight': 100 / 4, // 0% - 25%
//     },
//     {
//       'title': 'Ekstraksi Data',
//       'description': 'Membaca teks dan angka dari struk belanja...',
//       'icon': Icons.text_fields,
//       'function': 'extractData',
//       'weight': 100 / 4, // 25% - 70%
//     },
//     {
//       'title': 'AI Analisis Data',
//       'description': 'Mengidentifikasi item, harga, dan total belanja...',
//       'icon': Icons.analytics,
//       'function': 'analyzeData',
//       'weight': 100 / 4, // 70% - 90%
//     },
//     {
//       'title': 'Verifikasi Hasil',
//       'description': 'Memvalidasi data yang berhasil diproses...',
//       'icon': Icons.verified,
//       'function': 'verifyResults',
//       'weight': 100 / 4, // 90% - 100%
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       initImage().then((value) {
//         _startAsyncProcessing();
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _progressSubscription?.cancel();
//     super.dispose();
//   }

//   Future<void> initImage() async {
//     final byte = await widget.file.readAsBytes();
//     setState(() {
//       this.byte = byte;
//     });
//   }

//   // Main processing function with progress tracking
//   Future<void> _startAsyncProcessing() async {
//     setState(() {
//       isScanning = true;
//       hasError = false;
//       errorMessage = null;
//       progressValue = 0.0;
//       currentStepIndex = 0;
//     });

//     try {
//       double cumulativeProgress = 0.0;

//       for (int i = 0; i < processingSteps.length; i++) {
//         final step = processingSteps[i];
//         final stepWeight = step['weight'] as double;

//         setState(() {
//           currentStepIndex = i;
//           currentProcessMessage = step['description'];
//         });

//         // Execute step with progress tracking
//         await _executeStepWithProgress(
//           stepFunction: step['function'],
//           baseProgress: cumulativeProgress,
//           stepWeight: stepWeight,
//           stepIndex: i,
//         );

//         cumulativeProgress += stepWeight;

//         setState(() {
//           progressValue = cumulativeProgress;
//         });
//       }

//       // Final completion
//       setState(() {
//         progressValue = 1.0;
//         currentProcessMessage = 'Processing complete!';
//       });

//       // await Future.delayed(500.ms);
//       // _navigateToResult();
//     } catch (e) {
//       setState(() {
//         hasError = true;
//         errorMessage = e.toString();
//         isScanning = false;
//       });
//       // _showErrorDialog();
//     }
//   }

//   // Execute individual step with internal progress tracking
//   Future<void> _executeStepWithProgress({
//     required String stepFunction,
//     required double baseProgress,
//     required double stepWeight,
//     required int stepIndex,
//   }) async {
//     switch (stepFunction) {
//       case 'compressImage':
//         await _compressImageWithProgress(baseProgress, stepWeight);
//         break;
//       case 'extractData':
//         await _extractDataWithProgress(baseProgress, stepWeight);
//         break;
//       case 'analyzeData':
//         await _analyzeDataWithProgress(baseProgress, stepWeight);
//         break;
//       case 'verifyResults':
//         await _verifyResultsWithProgress(baseProgress, stepWeight);
//         break;
//       default:
//         throw Exception('Unknown processing step: $stepFunction');
//     }
//   }

//   // Step 1: Image Compression with progress
//   Future<Map<String, dynamic>> _compressImageWithProgress(
//     double baseProgress,
//     double stepWeight,
//   ) async {
//     try {
//       await Future.delayed(200.ms);
//       final compressedImage = await FlutterImageCompress.compressWithList(
//         byte!,
//         quality: 75,
//         format: CompressFormat.jpeg,
//       );
//       setState(() {
//         byte = compressedImage;
//       });

//       return {'success': true, 'message': 'Image compressed successfully'};
//     } catch (e) {
//       throw Exception('Failed to compress image: $e');
//     }
//   }

//   // Step 2: Data Extraction with progress
//   Future<Map<String, dynamic>> _extractDataWithProgress(
//     double baseProgress,
//     double stepWeight,
//   ) async {
//     try {
//       await Future.delayed(200.ms);
//       final textRecognizer = TextRecognizer(
//         script: TextRecognitionScript.latin,
//       );

//       final inputImage = InputImage.fromFile(File(widget.file.path));
//       final RecognizedText recognizedText = await textRecognizer.processImage(
//         inputImage,
//       );

//       String text = recognizedText.text;

//       print("""
//       ### DATA OCR ###
//       $text
//       ### end DATA OCR ###
// """);

//       return {
//         'success': true,
//         'extractedText': 'Sample extracted text from receipt',
//         'confidence': 0.95,
//       };
//     } catch (e) {
//       throw Exception('Failed to extract data: $e');
//     }
//   }

//   // Step 3: Data Analysis with progress
//   Future<Map<String, dynamic>> _analyzeDataWithProgress(
//     double baseProgress,
//     double stepWeight,
//   ) async {
//     try {
//       await Future.delayed(1.seconds);

//       return {
//         'success': true,
//         'items': [
//           {'name': 'Item 1', 'price': 15000, 'quantity': 2},
//           {'name': 'Item 2', 'price': 25000, 'quantity': 1},
//         ],
//         'totalAmount': 55000,
//         'tax': 5000,
//         'merchantName': 'Sample Store',
//       };
//     } catch (e) {
//       throw Exception('Failed to analyze data: $e');
//     }
//   }

//   // Step 4: Results Verification with progress
//   Future<Map<String, dynamic>> _verifyResultsWithProgress(
//     double baseProgress,
//     double stepWeight,
//   ) async {
//     try {
//       await Future.delayed(2.seconds);

//       return {
//         'success': true,
//         'isValid': true,
//         'confidence': 0.92,
//         'warnings': [],
//       };
//     } catch (e) {
//       throw Exception('Failed to verify results: $e');
//     }
//   }

//   void _navigateToResult() {
//     if (mounted) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const ScannedReceiptPage()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final scanHeight = size.height / 1.5;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//           child: Column(
//             children: [
//               // Header
//               _buildHeader(),

//               const SizedBox(height: 20),

//               // Image Container with Scan Animation
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.toOpacity(0.1),
//                         blurRadius: 20,
//                         offset: const Offset(0, 8),
//                       ),
//                     ],
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(20),
//                     child: Stack(
//                       children: [
//                         // Background Image
//                         if (byte != null)
//                           Image.memory(
//                             byte!,
//                             width: double.infinity,
//                             height: double.infinity,
//                             fit: BoxFit.cover,
//                           ),

//                         // Gradient Overlay
//                         Container(
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                               colors: [
//                                 Colors.transparent,
//                                 Colors.black.toOpacity(0.3),
//                               ],
//                             ),
//                           ),
//                         ),

//                         // Scan Animation (only show when not in error state)
//                         if (!hasError) ScanAnimation(parentHeight: scanHeight),

//                         // Processing Overlay
//                         if (!hasError)
//                           Positioned(
//                             bottom: 0,
//                             left: 0,
//                             right: 0,
//                             child: ProcessingOverlay(
//                               currentStep: processingSteps[currentStepIndex],
//                               progress: progressValue,
//                               stepIndex: currentStepIndex,
//                               totalSteps: processingSteps.length,
//                               currentMessage: currentProcessMessage,
//                             ),
//                           ),

//                         // Error Overlay
//                         if (hasError)
//                           Positioned(
//                             bottom: 0,
//                             left: 0,
//                             right: 0,
//                             child: ErrorOverlay(
//                               errorMessage: errorMessage ?? 'Processing failed',
//                               onRetry: () => _startAsyncProcessing(),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               SizedBox(height: 10),

//               // Processing Steps Indicator
//               _buildStepsIndicator(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Row(
//       children: [
//         IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF424242)),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 hasError ? 'Processing Error' : 'Memproses Struk',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w700,
//                   color: hasError ? Colors.red[700] : const Color(0xFF212121),
//                 ),
//               ),
//               Text(
//                 hasError
//                     ? 'Terjadi kesalahan saat memproses'
//                     : 'Harap tunggu sebentar...',
//                 style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: (hasError ? Colors.red : const Color(0xFF2196F3)).toOpacity(
//               0.1,
//             ),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(
//             hasError ? Icons.error : Icons.qr_code_scanner,
//             color: hasError ? Colors.red : const Color(0xFF2196F3),
//             size: 20,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStepsIndicator() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.toOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: processingSteps.asMap().entries.map((entry) {
//               int index = entry.key;
//               Map<String, dynamic> step = entry.value;
//               bool isActive = index == currentStepIndex && !hasError;
//               bool isCompleted = index < currentStepIndex && !hasError;
//               bool isError = hasError && index == currentStepIndex;

//               return Expanded(
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         children: [
//                           Container(
//                                 width: 40,
//                                 height: 40,
//                                 decoration: BoxDecoration(
//                                   color: isError
//                                       ? Colors.red
//                                       : isCompleted
//                                       ? const Color(0xFF4CAF50)
//                                       : isActive
//                                       ? const Color(0xFF2196F3)
//                                       : Colors.grey[300],
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Icon(
//                                   isError
//                                       ? Icons.error
//                                       : isCompleted
//                                       ? Icons.check
//                                       : step['icon'],
//                                   color: isCompleted || isActive || isError
//                                       ? Colors.white
//                                       : Colors.grey[600],
//                                   size: 20,
//                                 ),
//                               )
//                               .animate(target: isActive ? 1 : 0)
//                               .scale(
//                                 begin: const Offset(1.0, 1.0),
//                                 end: const Offset(1.1, 1.1),
//                                 duration: 300.ms,
//                                 curve: Curves.easeOut,
//                               )
//                               .animate(target: isActive ? 1 : 0)
//                               .shimmer(
//                                 duration: 1500.ms,
//                                 color: Colors.white.toOpacity(0.5),
//                               ),
//                           const SizedBox(height: 8),
//                           Text(
//                             step['title'],
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 11,
//                               fontWeight: isActive || isError
//                                   ? FontWeight.w600
//                                   : FontWeight.w400,
//                               color: isError
//                                   ? Colors.red
//                                   : isActive
//                                   ? const Color(0xFF2196F3)
//                                   : Colors.grey[600],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     if (index < processingSteps.length - 1)
//                       Container(
//                         width: 20,
//                         height: 2,
//                         decoration: BoxDecoration(
//                           color: isCompleted
//                               ? const Color(0xFF4CAF50)
//                               : Colors.grey[300],
//                           borderRadius: BorderRadius.circular(1),
//                         ),
//                       ),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ProcessingOverlay extends StatelessWidget {
//   const ProcessingOverlay({
//     super.key,
//     required this.currentStep,
//     required this.progress,
//     required this.stepIndex,
//     required this.totalSteps,
//     required this.currentMessage,
//   });

//   final Map<String, dynamic> currentStep;
//   final double progress;
//   final int stepIndex;
//   final int totalSteps;
//   final String currentMessage;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.black.toOpacity(0.8),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.white.toOpacity(0.2), width: 1),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Current Process Info
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF2196F3).toOpacity(0.2),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   currentStep['icon'],
//                   color: const Color(0xFF2196F3),
//                   size: 20,
//                 ),
//               ).animate().rotate(
//                 begin: 0,
//                 end: 1,
//                 duration: 2000.ms,
//                 curve: Curves.easeInOut,
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                           currentStep['title'],
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         )
//                         .animate()
//                         .fadeIn(duration: 500.ms)
//                         .slideX(begin: -0.2, end: 0, duration: 500.ms),
//                     const SizedBox(height: 4),
//                     Text(
//                           currentMessage.isNotEmpty
//                               ? currentMessage
//                               : currentStep['description'],
//                           style: TextStyle(
//                             color: Colors.white.toOpacity(0.8),
//                             fontSize: 12,
//                           ),
//                         )
//                         .animate()
//                         .fadeIn(delay: 200.ms, duration: 500.ms)
//                         .slideX(begin: -0.2, end: 0, duration: 500.ms),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 16),

//           // Progress Bar
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 '${stepIndex + 1}/$totalSteps',
//                 style: TextStyle(
//                   color: Colors.white.toOpacity(0.8),
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               AnimatedProgressBar().animate().shimmer(
//                 duration: 1500.ms,
//                 color: AppColors.secondary.toOpacity(0.5),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ErrorOverlay extends StatelessWidget {
//   const ErrorOverlay({
//     super.key,
//     required this.errorMessage,
//     required this.onRetry,
//   });

//   final String errorMessage;
//   final VoidCallback onRetry;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.red.toOpacity(0.9),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.white.toOpacity(0.2), width: 1),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.white.toOpacity(0.2),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.error, color: Colors.white, size: 20),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Processing Failed',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       errorMessage,
//                       style: TextStyle(
//                         color: Colors.white.toOpacity(0.9),
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: onRetry,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 foregroundColor: Colors.red,
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: const Text(
//                 'Retry Processing',
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AnimatedProgressBar extends StatefulWidget {
//   const AnimatedProgressBar({super.key});

//   @override
//   State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
// }

// class _AnimatedProgressBarState extends State<AnimatedProgressBar>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Color?> _colorAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat(reverse: true);

//     _colorAnimation = ColorTween(
//       begin: AppColors.primaryVariant,
//       end: AppColors.secondary,
//     ).animate(_controller);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _colorAnimation,
//       builder: (context, child) {
//         return LinearProgressIndicator(
//           borderRadius: BorderRadius.circular(20),
//           value: null, // null = indeterminate mode
//           valueColor: AlwaysStoppedAnimation(_colorAnimation.value),
//           backgroundColor: AppColors.surfaceVariant,
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }
