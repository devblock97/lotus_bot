import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:lotus_ai/features/invoice_ocr/entity/invoice_ocr_result.dart';

/// Custom domain exception for OCR failures.
class OcrException implements Exception {
  const OcrException(this.message, {this.cause});
  final String message;
  final Object? cause;

  @override
  String toString() => 'OcrException: $message ${cause != null ? '($cause)' : ''}';
}

/// Abstract contract for OCR engines (enables mock testing in VIPER).
abstract interface class OcrService {
  Future<InvoiceOcrResult> processImage(File imageFile);
  Future<void> dispose();
}

/// Production implementation of [OcrService] wrapping Google ML Kit.
class MlKitOcrService implements OcrService {
  MlKitOcrService({TextRecognitionScript script = TextRecognitionScript.latin})
      : _script = script;

  final TextRecognitionScript _script;
  TextRecognizer? _textRecognizer;
  bool _isDisposed = false;

  TextRecognizer get _recognizer {
    if (_isDisposed) {
      throw const OcrException('OcrService has already been disposed.');
    }
    return _textRecognizer ??= TextRecognizer(script: _script);
  }

  @override
  Future<InvoiceOcrResult> processImage(File imageFile) async {
    if (!await imageFile.exists()) {
      throw OcrException('Image file does not exist at: ${imageFile.path}');
    }

    try {
      final inputImage = InputImage.fromFile(imageFile);
      // Process on-device via ML Kit native engine (runs asynchronously off the UI thread)
      final RecognizedText recognizedText = await _recognizer.processImage(inputImage);

      // Cleanly map ML Kit blocks and lines to pure domain entities
      final List<OcrBlock> blocks = recognizedText.blocks.map((b) {
        final lines = b.lines
            .map((l) => OcrLine(text: l.text, boundingBox: l.boundingBox))
            .toList();
        return OcrBlock(
          text: b.text,
          lines: lines,
          boundingBox: b.boundingBox,
        );
      }).toList();

      return InvoiceOcrResult(
        rawText: recognizedText.text,
        blocks: blocks,
        scannedAt: DateTime.now(),
      );
    } catch (e) {
      if (e is OcrException) rethrow;
      throw OcrException('Failed to extract text from image', cause: e);
    }
  }

  @override
  Future<void> dispose() async {
    if (_isDisposed) return;
    _isDisposed = true;
    await _textRecognizer?.close();
    _textRecognizer = null;
  }
}
