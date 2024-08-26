import 'package:dio/dio.dart';
import 'package:safenest/core/common/app/providers/user_session.dart';
import 'package:safenest/core/services/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = sl<SharedPreferences>().getString('accessToken');
    options.headers['Authorization'] = 'Bearer $accessToken';
    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final newAccessToken = await sl<UserSession>().refreshToken();
      if (newAccessToken != null) {
        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        handler.resolve(await Dio().fetch(err.requestOptions));
      } else {
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }
}
