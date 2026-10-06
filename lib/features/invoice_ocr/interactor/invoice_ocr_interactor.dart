import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lotus_ai/core/services/ocr/ocr_service.dart';
import 'package:lotus_ai/features/invoice_ocr/entity/invoice_ocr_result.dart';

/// Interactor handling OCR business logic and media acquisition.
class InvoiceOcrInteractor {
  InvoiceOcrInteractor({
    required OcrService ocrService,
    ImagePicker? imagePicker,
  })  : _ocrService = ocrService,
        _imagePicker = imagePicker ?? ImagePicker();

  final OcrService _ocrService;
  final ImagePicker _imagePicker;

  /// Captures or selects an image. Downsamples to max 2048px to prevent OOM
  /// and accelerate on-device OCR without losing recognition accuracy.
  Future<File?> pickInvoiceImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 88,
      );

      if (pickedFile == null) return null;
      return File(pickedFile.path);
    } on PlatformException catch (e) {
      if (e.code == 'camera_access_denied' || e.code == 'photo_access_denied') {
        throw const OcrException('Permission to access camera or gallery was denied.');
      }
      throw OcrException('Image selection failed: ${e.message ?? e.code}', cause: e);
    } on MissingPluginException catch (_) {
      throw const OcrException(
        'Plugin not registered in running app. Please stop the app and run a full cold restart (flutter run).',
      );
    } catch (e) {
      throw OcrException('Unexpected error picking image: $e', cause: e);
    }
  }

  /// Processes the image using the isolated OCR service asynchronously.
  Future<InvoiceOcrResult> scanInvoice(File imageFile) async {
    return _ocrService.processImage(imageFile);
  }

  /// Disposes underlying native recognizer resources.
  Future<void> dispose() async {
    await _ocrService.dispose();
  }
}
