import 'dart:io';

import 'package:safenest/core/errors/exceptions.dart';
import 'package:safenest/features/profile/data/models/scan_model.dart';

abstract class ProfileRemoteDataSource {
  const ProfileRemoteDataSource();

  Future<ScanModel> scanPassport({required File firstPage});
  Future<ScanModel> scanDigitalId({required File front, required File back});
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  @override
  Future<ScanModel> scanDigitalId({
    required File front,
    required File back,
  }) async {
    try {
      return ScanModel(
        front: front,
        back: back,
      );
    } catch (e, s) {
      throw ScanDataException(
        message: 'Invalid Digital ID scanned try again',
        statusCode: 505,
      );
    }
  }

  @override
  Future<ScanModel> scanPassport({required File firstPage}) async {
    try {
      return ScanModel(firstPage: firstPage);
    } catch (e, s) {
      throw ScanDataException(
        message: 'Invalid Passport scanned try again',
        statusCode: 404,
      );
    }
  }

  bool validateDigitalId(String frontText, String backText) {
    return frontText.contains('Ethiopian Digital Id Card') &&
        backText.contains('Name') &&
        backText.contains('Date of Birth');
  }

  bool validatePassport(String text) {
    final now = DateTime.now();
    final exp = RegExp(r'Date of Issue: (\d{4})');
    final Match? match = exp.firstMatch(text);
    if (match != null &&
        text.contains('Federal Democratic Republic Of Ethiopia')) {
      final issueYear = int.parse(match.group(1)!);
      return now.year - issueYear <= 5;
    }
    return false;
  }
}
