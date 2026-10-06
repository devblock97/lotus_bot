import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotus_ai/core/services/ocr/ocr_service.dart';
import 'package:lotus_ai/features/invoice_ocr/entity/invoice_ocr_result.dart';
import 'package:lotus_ai/features/invoice_ocr/interactor/invoice_ocr_interactor.dart';
import 'package:lotus_ai/features/invoice_ocr/presenter/invoice_ocr_event.dart';
import 'package:lotus_ai/features/invoice_ocr/presenter/invoice_ocr_state.dart';

class InvoiceOcrBloc extends Bloc<InvoiceOcrEvent, InvoiceOcrState> {
  InvoiceOcrBloc({required InvoiceOcrInteractor interactor})
      : _interactor = interactor,
        super(const InvoiceOcrState()) {
    on<InvoiceOcrPickRequested>(_onPickRequested);
    on<InvoiceOcrScanRequested>(_onScanRequested);
    on<InvoiceOcrTextCopied>(_onTextCopied);
    on<InvoiceOcrResetRequested>(_onResetRequested);
  }

  final InvoiceOcrInteractor _interactor;

  Future<void> _onPickRequested(
    InvoiceOcrPickRequested event,
    Emitter<InvoiceOcrState> emit,
  ) async {
    try {
      emit(state.copyWith(status: InvoiceOcrStatus.picking, clearError: true));
      final File? image = await _interactor.pickInvoiceImage(event.source);

      if (image == null) {
        // User canceled selection; maintain previous state
        emit(state.copyWith(
          status: state.selectedImage != null
              ? InvoiceOcrStatus.success
              : InvoiceOcrStatus.initial,
        ));
        return;
      }

      add(InvoiceOcrScanRequested(image));
    } on OcrException catch (e) {
      emit(state.copyWith(
        status: InvoiceOcrStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: InvoiceOcrStatus.failure,
        errorMessage: 'Failed to access image: $e',
      ));
    }
  }

  Future<void> _onScanRequested(
    InvoiceOcrScanRequested event,
    Emitter<InvoiceOcrState> emit,
  ) async {
    emit(state.copyWith(
      status: InvoiceOcrStatus.scanning,
      selectedImage: event.imageFile,
      clearError: true,
      clearUserMessage: true,
    ));

    try {
      final InvoiceOcrResult result =
          await _interactor.scanInvoice(event.imageFile);
      emit(state.copyWith(
        status: InvoiceOcrStatus.success,
        result: result,
      ));
    } on OcrException catch (e) {
      emit(state.copyWith(
        status: InvoiceOcrStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: InvoiceOcrStatus.failure,
        errorMessage: 'An unexpected error occurred while scanning: $e',
      ));
    }
  }

  Future<void> _onTextCopied(
    InvoiceOcrTextCopied event,
    Emitter<InvoiceOcrState> emit,
  ) async {
    if (state.result.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: state.result.rawText));
    emit(state.copyWith(userMessage: 'Invoice text copied to clipboard!'));
  }

  void _onResetRequested(
    InvoiceOcrResetRequested event,
    Emitter<InvoiceOcrState> emit,
  ) {
    emit(const InvoiceOcrState());
  }

  @override
  Future<void> close() async {
    await _interactor.dispose();
    return super.close();
  }
}
