import 'package:dio/dio.dart';
import 'package:teste/token_model.dart';

import 'localstorage.dart';

class AuthInterceptor extends Interceptor {
  final LocalStorageService _service;
  AuthInterceptor(this._service);

  @override
  onRequest(RequestOptions options) async {
    TokenModel tokenModel = await _service.get<TokenModel>(
        LocalStorageService.TOKEN,
        construct: (v) => TokenModel.fromJson(v));

    print("url ${options.path}");

    if (!options.headers.containsKey("Authorization") && tokenModel != null) {
      options.path
              .toLowerCase()
              .contains('run.mocky.io/v3/c0cbd196-04f2-4a90-854a-24c8c9e11a09')
          ? options.headers["Authorization"] =
              "Bearer 11111" //token1 caso a url for do google
          : options.headers["Authorization"] =
              "Bearer 22222"; //token2 caso for outra url

      print(options.headers);
    }

    return options;
  }

  @override
  onResponse(Response response) async {
    return response;
  }

  @override
  onError(DioError e) async {
    if (e.response?.statusCode == 401) {
      print('não autorizado');
      //redirecionar
    }

    return e;
  }
}
