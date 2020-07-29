import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:teste/auth_interceptor.dart';
import 'package:teste/localstorage.dart';

class CustomDio extends DioForNative {
  final LocalStorageService _storage;

  CustomDio(this._storage) {
    interceptors.add(AuthInterceptor(_storage));
  }
}
