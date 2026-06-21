import 'package:dio/dio.dart';
import 'package:graduation_app/core/constants/strings.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: Strings.baseUrl,
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    final Map<String, dynamic> headers = {
      'Content-Type': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return await dio.get(
      url,
      queryParameters: query,
      options: Options(headers: headers),
    );
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    String? token, 
  }) async {
    final Map<String, dynamic> headers = {
      'Content-Type': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return await dio.post(
      url, 
      data: data,
      options: Options(headers: headers),
    );
  }
}