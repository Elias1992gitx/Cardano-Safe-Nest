import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:safenest/core/common/app/providers/user_session.dart';
import 'package:safenest/core/common/network/auth_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomHttpClient {
  CustomHttpClient(SharedPreferences prefs,UserSession session) {
    client = InterceptedClient.build(
      interceptors: [
        AuthInterceptor(prefs,session),
      ],
    );
  }
  late http.Client client;



}
