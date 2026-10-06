import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lotus_ai/core/services/ocr/ocr_service.dart';
import 'package:lotus_ai/features/invoice_ocr/entity/invoice_ocr_result.dart';
import 'package:lotus_ai/features/invoice_ocr/interactor/invoice_ocr_interactor.dart';
import 'package:lotus_ai/features/invoice_ocr/presenter/invoice_ocr_bloc.dart';
import 'package:lotus_ai/features/invoice_ocr/presenter/invoice_ocr_event.dart';
import 'package:lotus_ai/features/invoice_ocr/presenter/invoice_ocr_state.dart';
import 'package:mocktail/mocktail.dart';

class MockOcrService extends Mock implements OcrService {}
class MockImagePicker extends Mock implements ImagePicker {}

void main() {
  setUpAll(() {
    registerFallbackValue(File('dummy.jpg'));
  });

  late MockOcrService mockOcrService;
  late MockImagePicker mockImagePicker;
  late InvoiceOcrInteractor interactor;

  setUp(() {
    mockOcrService = MockOcrService();
    mockImagePicker = MockImagePicker();
    when(() => mockOcrService.dispose()).thenAnswer((_) async {});

    interactor = InvoiceOcrInteractor(
      ocrService: mockOcrService,
      imagePicker: mockImagePicker,
    );
  });

  group('InvoiceOcrBloc Tests', () {
    test('Initial state is correct', () {
      final bloc = InvoiceOcrBloc(interactor: interactor);
      expect(bloc.state, const InvoiceOcrState());
      bloc.close();
    });

    blocTest<InvoiceOcrBloc, InvoiceOcrState>(
      'Emits picking then scans image when user selects an image from camera',
      setUp: () {
        when(
          () => mockImagePicker.pickImage(
            source: ImageSource.camera,
            maxWidth: any(named: 'maxWidth'),
            maxHeight: any(named: 'maxHeight'),
            imageQuality: any(named: 'imageQuality'),
          ),
        ).thenAnswer((_) async => XFile('test_invoice.jpg'));

        when(() => mockOcrService.processImage(any())).thenAnswer(
          (_) async => const InvoiceOcrResult(
            rawText: 'Total: \$42.50\nDate: 2026-10-05',
            blocks: [
              OcrBlock(
                text: 'Total: \$42.50\nDate: 2026-10-05',
                lines: [
                  OcrLine(text: 'Total: \$42.50'),
                  OcrLine(text: 'Date: 2026-10-05'),
                ],
              ),
            ],
          ),
        );
      },
      build: () => InvoiceOcrBloc(interactor: interactor),
      act: (bloc) => bloc.add(const InvoiceOcrPickRequested(ImageSource.camera)),
      expect: () => [
        const InvoiceOcrState(status: InvoiceOcrStatus.picking),
        isA<InvoiceOcrState>()
            .having((s) => s.status, 'status', InvoiceOcrStatus.scanning)
            .having((s) => s.selectedImage?.path, 'path', 'test_invoice.jpg'),
        isA<InvoiceOcrState>()
            .having((s) => s.status, 'status', InvoiceOcrStatus.success)
            .having((s) => s.result.rawText, 'rawText', 'Total: \$42.50\nDate: 2026-10-05')
            .having((s) => s.result.lineCount, 'lineCount', 2),
      ],
    );

    blocTest<InvoiceOcrBloc, InvoiceOcrState>(
      'Maintains initial state when user cancels image picker',
      setUp: () {
        when(
          () => mockImagePicker.pickImage(
            source: ImageSource.gallery,
            maxWidth: any(named: 'maxWidth'),
            maxHeight: any(named: 'maxHeight'),
            imageQuality: any(named: 'imageQuality'),
          ),
        ).thenAnswer((_) async => null);
      },
      build: () => InvoiceOcrBloc(interactor: interactor),
      act: (bloc) => bloc.add(const InvoiceOcrPickRequested(ImageSource.gallery)),
      expect: () => [
        const InvoiceOcrState(status: InvoiceOcrStatus.picking),
        const InvoiceOcrState(status: InvoiceOcrStatus.initial),
      ],
    );

    blocTest<InvoiceOcrBloc, InvoiceOcrState>(
      'Handles OCR processing error cleanly',
      setUp: () {
        when(() => mockOcrService.processImage(any()))
            .thenThrow(const OcrException('Corrupted image'));
      },
      build: () => InvoiceOcrBloc(interactor: interactor),
      act: (bloc) => bloc.add(InvoiceOcrScanRequested(File('bad.jpg'))),
      expect: () => [
        isA<InvoiceOcrState>()
            .having((s) => s.status, 'status', InvoiceOcrStatus.scanning),
        isA<InvoiceOcrState>()
            .having((s) => s.status, 'status', InvoiceOcrStatus.failure)
            .having((s) => s.errorMessage, 'error', 'Corrupted image'),
      ],
    );

    blocTest<InvoiceOcrBloc, InvoiceOcrState>(
      'Resets state when InvoiceOcrResetRequested is dispatched',
      build: () => InvoiceOcrBloc(interactor: interactor),
      seed: () => InvoiceOcrState(
        status: InvoiceOcrStatus.success,
        selectedImage: File('test.jpg'),
        result: const InvoiceOcrResult(rawText: 'Sample', blocks: []),
      ),
      act: (bloc) => bloc.add(const InvoiceOcrResetRequested()),
      expect: () => [
        const InvoiceOcrState(status: InvoiceOcrStatus.initial),
      ],
    );
  });
}
