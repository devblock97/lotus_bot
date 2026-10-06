import 'dart:ui';
import 'package:equatable/equatable.dart';

/// Represents a single detected line of text with optional spatial bounds.
class OcrLine extends Equatable {
  const OcrLine({required this.text, this.boundingBox});

  final String text;
  final Rect? boundingBox;

  @override
  List<Object?> get props => [text, boundingBox];
}

/// Represents an individual structured block of recognized text (e.g. paragraph, line group).
class OcrBlock extends Equatable {
  const OcrBlock({
    required this.text,
    required this.lines,
    this.boundingBox,
  });

  final String text;
  final List<OcrLine> lines;
  final Rect? boundingBox;

  @override
  List<Object?> get props => [text, lines, boundingBox];
}

/// Pure domain entity representing the full structured OCR output.
class InvoiceOcrResult extends Equatable {
  const InvoiceOcrResult({
    required this.rawText,
    required this.blocks,
    this.scannedAt,
  });

  const InvoiceOcrResult.empty()
      : rawText = '',
        blocks = const [],
        scannedAt = null;

  final String rawText;
  final List<OcrBlock> blocks;
  final DateTime? scannedAt;

  bool get isEmpty => rawText.trim().isEmpty;
  bool get isNotEmpty => !isEmpty;

  int get lineCount => blocks.fold(0, (acc, block) => acc + block.lines.length);

  @override
  List<Object?> get props => [rawText, blocks, scannedAt];
}
