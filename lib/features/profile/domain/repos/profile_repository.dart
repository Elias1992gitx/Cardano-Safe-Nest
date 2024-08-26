

import 'dart:io';

import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/profile/domain/entity/scan_result.dart';

abstract class ProfileRepository{
  const ProfileRepository();


  ResultFuture<ScanResult> scanPassport({
    required File firstPage,
  });


  ResultFuture<ScanResult> scanDigitalId({
    required File front,
    required File back,
  });

}
