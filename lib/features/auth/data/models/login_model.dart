import 'dart:convert';

import 'package:safenest/core/utils/typedef.dart';


String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {

  const LoginModel({
    required this.email,
    required this.password,
  });



  final String email;
  final String password;

  DataMap toJson() => {
    'email': email,
    'password': password,
  };


}
