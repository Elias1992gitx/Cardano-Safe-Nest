import 'dart:io';

import 'package:equatable/equatable.dart';

class ScanResult extends Equatable {
  const ScanResult({
    this.front,
    this.back,
    this.firstPage,
  });

  final File? front;
  final File? back;
  final File? firstPage;

  bool get isPassport => firstPage != null;
  bool get isDigitalId => front != null && back != null;

  @override
  List<Object?> get props => [front, back, firstPage];
}
