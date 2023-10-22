import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:list_contacts/repository/back4app/interceptor_dio.dart';

class CustomDio {
  final _dio = Dio();

  Dio get dio => _dio;

  CustomDio() {
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.baseUrl = dotenv.get('BACK4APPBASEURL');
    _dio.interceptors.add(InterceptorDio());
  }
}