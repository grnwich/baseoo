import 'package:baseoo/base/lib_config.dart';
import 'package:baseoo/util/os_util.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class DioConfig with DioMixin implements Dio {
  final int _defaultConnectTimeout = LibConfig.ConnectTimeout;

  DioConfig._([BaseOptions? options]) {
    options ??= BaseOptions(
      baseUrl: LibConfig.BASE_URL,
      contentType: 'application/json',
      connectTimeout: Duration(seconds: _defaultConnectTimeout),
      sendTimeout: Duration(seconds: _defaultConnectTimeout),
      receiveTimeout: Duration(seconds: _defaultConnectTimeout),
    );

    this.options = options;

    /*  if (UI.isDebug) {
      interceptors.add(PrettyDioLogger(
          responseBody: true,
          error: true,
          requestHeader: false,
          responseHeader: false,
          request: false,
          requestBody: true));
    }*/
    if (OSUtil.isWeb) {
      // httpClientAdapter = BrowserHttpClientAdapter();
    } else {
      httpClientAdapter = IOHttpClientAdapter();
    }
  }

  static Dio getInstance() => DioConfig._();
}
