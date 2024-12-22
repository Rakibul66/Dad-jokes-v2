import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          options.headers.addAll({
            'X-Api-Key': 'fV4WKicWp1dcP7PKN8OsDQ==H1gCVi1FFjMIUEkU',
          });
          handler.next(options);
        },
        onError: (DioError error, ErrorInterceptorHandler handler) {
          // Add custom error handling here
          print('Request error: ${error.response?.statusCode} ${error.response?.statusMessage}');
          handler.next(error);
        },
      ),
    );
  }


  Future<Response> fetchJoke() async {
    try {
      return await _dio.get('https://api.api-ninjas.com/v1/jokes');
    } catch (e) {
      print('Failed to fetch joke: $e');
      throw Exception('Failed to fetch joke');
    }
  }
}