import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotus_ai/core/services/ocr/ocr_service.dart';
import 'package:lotus_ai/features/invoice_ocr/interactor/invoice_ocr_interactor.dart';
import 'package:lotus_ai/features/invoice_ocr/presenter/invoice_ocr_bloc.dart';
import 'package:lotus_ai/features/invoice_ocr/view/invoice_ocr_screen.dart';

/// Router assembling the VIPER module and managing transitions.
class InvoiceOcrRouter {
  const InvoiceOcrRouter();

  /// Builds the full Invoice OCR module with its BLoC provider and isolated interactor.
  Widget buildInvoiceOcrView() {
    final ocrService = MlKitOcrService();
    final interactor = InvoiceOcrInteractor(ocrService: ocrService);

    return BlocProvider<InvoiceOcrBloc>(
      create: (_) => InvoiceOcrBloc(interactor: interactor),
      child: const InvoiceOcrScreen(),
    );
  }

  /// Convenience navigation helper
  static Future<void> navigateTo(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const InvoiceOcrRouter().buildInvoiceOcrView(),
      ),
    );
  }
}
