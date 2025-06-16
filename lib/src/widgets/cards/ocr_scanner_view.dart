import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OCRScannerView extends StatefulWidget {
  final Function(Map<String, String>) onDataDetected;

  const OCRScannerView({
    super.key,
    required this.onDataDetected,
  });

  @override
  State<OCRScannerView> createState() => _OCRScannerViewState();
}

class _OCRScannerViewState extends State<OCRScannerView> {
  CameraController? _cameraController;
  late List<CameraDescription> _cameras;
  bool _isInitialized = false;
  bool _isProcessing = false;

  final TextRecognizer _textRecognizer = TextRecognizer();

  // Detected data
  final Map<String, String> _detectedData = {};

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        _cameraController = CameraController(
          _cameras.first,
          ResolutionPreset.high,
          enableAudio: false,
        );

        await _cameraController!.initialize();

        if (mounted) {
          setState(() {
            _isInitialized = true;
          });

          // Start continuous scanning
          _startContinuousScanning();
        }
      }
    } catch (e) {
      bugsnag.notify(e, StackTrace.current);
    }
  }

  void _startContinuousScanning() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    // Process frames every 2 seconds to avoid overwhelming the processor
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && !_isProcessing) {
        _captureAndProcessImage();
      }
    });
  }

  Future<void> _captureAndProcessImage() async {
    if (_isProcessing || _cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final XFile image = await _cameraController!.takePicture();
      final InputImage inputImage = InputImage.fromFilePath(image.path);

      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

      _extractSimCardData(recognizedText.text);

    } catch (e) {
      bugsnag.notify(e, StackTrace.current);
    } finally {
      setState(() {
        _isProcessing = false;
      });

      // Continue scanning if we haven't found all required data
      if (_detectedData.length < 2 && mounted) {
        _startContinuousScanning();
      }
    }
  }

  void _extractSimCardData(String text) {
    final Map<String, String> extractedData = {};

    // Split text into lines and clean them
    final lines = text.split('\n').map((line) => line.trim()).where((line) => line.isNotEmpty).toList();

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].toUpperCase();

      // Extract PIN
      if (line.contains('PIN') && extractedData['pin'] == null) {
        final pinMatch = _extractNumericValue(line, 'PIN');
        if (pinMatch != null && pinMatch.length >= 4 && pinMatch.length <= 8) {
          extractedData['pin'] = pinMatch;
        }
      }

      // Extract PUK
      if (line.contains('PUK') && extractedData['puk'] == null) {
        final pukMatch = _extractNumericValue(line, 'PUK');
        if (pukMatch != null && pukMatch.length >= 8 && pukMatch.length <= 12) {
          extractedData['puk'] = pukMatch;
        }
      }
    }

    // Update detected data if we found new information
    bool hasNewData = false;
    extractedData.forEach((key, value) {
      if (_detectedData[key] != value) {
        _detectedData[key] = value;
        hasNewData = true;
      }
    });

    if (hasNewData) {
      setState(() {});

      // If we have PIN and PUK, notify the parent
      if (_detectedData.containsKey('pin') && _detectedData.containsKey('puk')) {
        widget.onDataDetected(Map<String, String>.from(_detectedData));
      }
    }
  }

  String? _extractNumericValue(String text, String keyword) {
    // Look for patterns like "PIN: 1234" or "PIN 1234" or "PIN:1234"
    final patterns = [
      RegExp('$keyword[:\\s]+([0-9]+)', caseSensitive: false),
      RegExp('$keyword([0-9]+)', caseSensitive: false),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null && match.group(1) != null) {
        return match.group(1)!;
      }
    }

    return null;
  }


  @override
  void dispose() {
    _cameraController?.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (!_isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Camera preview
              CameraPreview(_cameraController!),

              // Overlay frame
              Container(
                width: 320,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              // Processing indicator
              if (_isProcessing)
                Positioned(
                  top: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          localizations.processing,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),

              // Detected data overlay
              if (_detectedData.isNotEmpty)
                Positioned(
                  bottom: 20,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          localizations.detected_data,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ..._detectedData.entries.map((entry) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            '${_getFieldLabel(entry.key, localizations)}: ${entry.value}',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Instructions
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                localizations.position_sim_card_in_frame,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                localizations.ocr_scanning_instructions,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getFieldLabel(String key, AppLocalizations localizations) {
    switch (key) {
      case 'pin':
        return localizations.pin_label;
      case 'puk':
        return localizations.puk_label;
      default:
        return key.toUpperCase();
    }
  }
}