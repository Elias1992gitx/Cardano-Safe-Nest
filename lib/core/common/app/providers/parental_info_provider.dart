import 'package:flutter/foundation.dart';
import 'package:safenest/features/profile/data/models/parental_info_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ParentalInfoProvider extends ChangeNotifier {
  ParentalInfoModel? _parentalInfo;

  ParentalInfoModel? get parentalInfo => _parentalInfo;

  Future<void> loadParentalInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('parental_info');
    if (jsonString != null) {
      _parentalInfo = ParentalInfoModel.fromMap(jsonDecode(jsonString));
      notifyListeners();
    }
  }

  void updateParentalInfo(ParentalInfoModel info) {
    _parentalInfo = info;
    notifyListeners();
  }
}