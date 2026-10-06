import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:lotus_ai/features/invoice_ocr/entity/invoice_ocr_result.dart';

enum InvoiceOcrStatus { initial, picking, scanning, success, failure }

class InvoiceOcrState extends Equatable {
  const InvoiceOcrState({
    this.status = InvoiceOcrStatus.initial,
    this.selectedImage,
    this.result = const InvoiceOcrResult.empty(),
    this.errorMessage,
    this.userMessage,
  });

  final InvoiceOcrStatus status;
  final File? selectedImage;
  final InvoiceOcrResult result;
  final String? errorMessage;
  final String? userMessage;

  InvoiceOcrState copyWith({
    InvoiceOcrStatus? status,
    File? selectedImage,
    bool clearImage = false,
    InvoiceOcrResult? result,
    String? errorMessage,
    bool clearError = false,
    String? userMessage,
    bool clearUserMessage = false,
  }) {
    return InvoiceOcrState(
      status: status ?? this.status,
      selectedImage: clearImage ? null : (selectedImage ?? this.selectedImage),
      result: result ?? this.result,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      userMessage: clearUserMessage ? null : (userMessage ?? this.userMessage),
    );
  }

  @override
  List<Object?> get props => [status, selectedImage, result, errorMessage, userMessage];
}
