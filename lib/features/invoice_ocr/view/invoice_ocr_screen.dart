import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lotus_ai/features/invoice_ocr/entity/invoice_ocr_result.dart';
import 'package:lotus_ai/features/invoice_ocr/presenter/invoice_ocr_bloc.dart';
import 'package:lotus_ai/features/invoice_ocr/presenter/invoice_ocr_event.dart';
import 'package:lotus_ai/features/invoice_ocr/presenter/invoice_ocr_state.dart';

class InvoiceOcrScreen extends StatelessWidget {
  const InvoiceOcrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice & Receipt Scanner'),
        actions: [
          BlocBuilder<InvoiceOcrBloc, InvoiceOcrState>(
            buildWhen: (prev, curr) => prev.selectedImage != curr.selectedImage,
            builder: (context, state) {
              if (state.selectedImage == null) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Reset Scanner',
                onPressed: () => context
                    .read<InvoiceOcrBloc>()
                    .add(const InvoiceOcrResetRequested()),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<InvoiceOcrBloc, InvoiceOcrState>(
        listenWhen: (prev, curr) =>
            prev.errorMessage != curr.errorMessage ||
            prev.userMessage != curr.userMessage,
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state.userMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.userMessage!),
                backgroundColor: colorScheme.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          final isScanning = state.status == InvoiceOcrStatus.scanning;

          return Column(
            children: [
              if (isScanning)
                const LinearProgressIndicator(minHeight: 3),
              Expanded(
                child: state.selectedImage == null
                    ? _OcrEmptyState(
                        onCameraPressed: () => _pick(context, ImageSource.camera),
                        onGalleryPressed: () => _pick(context, ImageSource.gallery),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _ImagePreviewCard(
                              imageFile: state.selectedImage!,
                              isScanning: isScanning,
                              onRetake: () => _showSourceSheet(context),
                            ),
                            const SizedBox(height: 16),
                            if (isScanning)
                              _ScanningCard()
                            else if (state.result.isEmpty)
                              _NoTextDetectedCard(
                                onTryAgain: () => _showSourceSheet(context),
                              )
                            else
                              _OcrExtractedTextCard(result: state.result),
                          ],
                        ),
                      ),
              ),
              _BottomActionDock(
                hasImage: state.selectedImage != null,
                isScanning: isScanning,
                onCameraPressed: () => _pick(context, ImageSource.camera),
                onGalleryPressed: () => _pick(context, ImageSource.gallery),
              ),
            ],
          );
        },
      ),
    );
  }

  void _pick(BuildContext context, ImageSource source) {
    context.read<InvoiceOcrBloc>().add(InvoiceOcrPickRequested(source));
  }

  void _showSourceSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Capture with Camera'),
              onTap: () {
                Navigator.pop(context);
                _pick(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Select from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pick(context, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _OcrEmptyState extends StatelessWidget {
  const _OcrEmptyState({
    required this.onCameraPressed,
    required this.onGalleryPressed,
  });

  final VoidCallback onCameraPressed;
  final VoidCallback onGalleryPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.35),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.document_scanner_rounded,
                size: 64,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Scan Invoices & Bills',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Extract raw text, amounts, and dates instantly on your device with offline privacy.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: onCameraPressed,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: onGalleryPressed,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagePreviewCard extends StatelessWidget {
  const _ImagePreviewCard({
    required this.imageFile,
    required this.isScanning,
    required this.onRetake,
  });

  final File imageFile;
  final bool isScanning;
  final VoidCallback onRetake;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 260),
            child: SizedBox(
              width: double.infinity,
              child: Image.file(
                imageFile,
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (!isScanning)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilledButton.tonalIcon(
                onPressed: onRetake,
                icon: const Icon(Icons.change_circle_outlined, size: 18),
                label: const Text('Replace'),
              ),
            ),
        ],
      ),
    );
  }
}

class _ScanningCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recognizing Text...',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Google ML Kit is processing the invoice on-device.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoTextDetectedCard extends StatelessWidget {
  const _NoTextDetectedCard({required this.onTryAgain});
  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.errorContainer.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(Icons.warning_amber_rounded, size: 40, color: colorScheme.error),
            const SizedBox(height: 8),
            Text(
              'No Text Detected',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Ensure the invoice is well-lit, laid flat, and the camera is properly focused.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: onTryAgain,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Another Image'),
            ),
          ],
        ),
      ),
    );
  }
}

class _OcrExtractedTextCard extends StatelessWidget {
  const _OcrExtractedTextCard({required this.result});
  final InvoiceOcrResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.text_fields_rounded, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Extracted Text (${result.blocks.length} blocks, ${result.lineCount} lines)',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton.filledTonal(
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  tooltip: 'Copy all to clipboard',
                  onPressed: () => context
                      .read<InvoiceOcrBloc>()
                      .add(const InvoiceOcrTextCopied()),
                ),
              ],
            ),
            const Divider(height: 24),
            SelectableText(
              result.rawText,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomActionDock extends StatelessWidget {
  const _BottomActionDock({
    required this.hasImage,
    required this.isScanning,
    required this.onCameraPressed,
    required this.onGalleryPressed,
  });

  final bool hasImage;
  final bool isScanning;
  final VoidCallback onCameraPressed;
  final VoidCallback onGalleryPressed;

  @override
  Widget build(BuildContext context) {
    if (!hasImage) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
        ),
        child: Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: isScanning ? null : onCameraPressed,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Scan Another'),
              ),
            ),
            const SizedBox(width: 12),
            IconButton.filledTonal(
              onPressed: isScanning ? null : onGalleryPressed,
              icon: const Icon(Icons.photo_library),
              tooltip: 'Pick from Gallery',
            ),
          ],
        ),
      ),
    );
  }
}
