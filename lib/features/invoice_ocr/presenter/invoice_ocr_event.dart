import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

sealed class InvoiceOcrEvent extends Equatable {
  const InvoiceOcrEvent();

  @override
  List<Object?> get props => [];
}

class InvoiceOcrPickRequested extends InvoiceOcrEvent {
  const InvoiceOcrPickRequested(this.source);
  final ImageSource source;

  @override
  List<Object?> get props => [source];
}

class InvoiceOcrScanRequested extends InvoiceOcrEvent {
  const InvoiceOcrScanRequested(this.imageFile);
  final File imageFile;

  @override
  List<Object?> get props => [imageFile];
}

class InvoiceOcrTextCopied extends InvoiceOcrEvent {
  const InvoiceOcrTextCopied();
}

class InvoiceOcrResetRequested extends InvoiceOcrEvent {
  const InvoiceOcrResetRequested();
}
