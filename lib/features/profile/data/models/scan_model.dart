import 'dart:io';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/profile/domain/entity/scan_result.dart';

class ScanModel extends ScanResult {
  const ScanModel({
    super.front,
    super.back,
    super.firstPage,
  });

  ScanModel.fromMap(DataMap map)
      : super(
    front: map['front'] as File?,
    back: map['back'] as File?,
    firstPage: map['firstPage'] as File?,
  );

  DataMap toMap() {
    return {
      'front': front,
      'back': back,
      'firstPage': firstPage,
    };
  }
}