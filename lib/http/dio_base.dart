import 'package:dio/dio.dart';

import 'dio_config.dart';

abstract class BaseDio {
  static final Dio _dio = DioConfig.getInstance();

  static const _POST = "post";
  static const _GET = "get";
  static const _PATCH = "patch";
  static const _DELETE = "delete";
  static const _PUT = "put";
  static const _DOWNLOAD = "download";
  static const _UPLOAD = "upload";

  Map<String, dynamic>? map;
  CancelToken? cancelToken;
  Options? options;
  ProgressCallback? onSendProgress;
  ProgressCallback? onReceiveProgress;

  String? _otherPath;

  BaseDio({
    this.map,
    this.cancelToken,
    this.options,
    this.onSendProgress,
    this.onReceiveProgress,
  });

  BaseDio add(String key, value) {
    map ??= {};
    map![key] = value;
    return this;
  }

  Future<T> get<T>(String path,
      T Function(Map<String, dynamic> element) combine) async {
    return _quest(_GET, path, combine);
  }

  Future<T> post<T>(String path,
      T Function(Map<String, dynamic> element) combine) async {
    return _quest(_POST, path, combine);
  }

  Future<T> download<T>(String path, String savePath,
      T Function(Map<String, dynamic> element) combine) async {
    _otherPath = savePath;
    return _quest(_DOWNLOAD, path, combine);
  }

  Future<T> upload<T>(String path, String sourcePath,
      T Function(Map<String, dynamic> element) combine) async {
    _otherPath = sourcePath;
    return _quest(_UPLOAD, path, combine);
  }

  Future<T> _quest<T>(type, path,
      T Function(Map<String, dynamic> element) combine) async {
    map ??= {};

    options ??= Options();

    await quest(type, path, map!, options!);

    return parse(path, _base(type, path), combine);
  }

  Future quest(String type, String path, Map<String, dynamic> map,
      Options options);

  Future<T> parse<T>(String path,
      Future<Response> quest, T Function(Map<String, dynamic> element) combine);

  // BaseParser parse();

  Future<Response> _base(type, path) async {
    switch (type) {
      case _GET:
        {
          return await _dio.get(path,
              queryParameters: map,
              cancelToken: cancelToken,
              options: options,
              onReceiveProgress: onReceiveProgress);
        }

      case _PATCH:
        {
          return await _dio.patch(path,
              queryParameters: map,
              cancelToken: cancelToken,
              options: options,
              onReceiveProgress: onReceiveProgress);
        }

      case _DELETE:
        {
          return await _dio.delete(
            path,
            queryParameters: map,
            cancelToken: cancelToken,
            options: options,
          );
        }
      case _PUT:
        {
          return await _dio.put(path,
              queryParameters: map,
              cancelToken: cancelToken,
              options: options,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress);
        }
      case _DOWNLOAD:
        {
          String savePath = _otherPath!;
          return await _dio.download(path, savePath,
              cancelToken: cancelToken,
              queryParameters: map,
              options: options,
              onReceiveProgress: onReceiveProgress);
        }

      case _UPLOAD:
        {

          FormData formData = FormData.fromMap(map!);
          options = Options(
            responseType: ResponseType.json,
            followRedirects: false,
          );
          return await _dio.post(path,
              data: formData,
              cancelToken: cancelToken,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress);
        }
    }

    return await _dio.post(path,
        data: map,
        cancelToken: cancelToken,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
  }
}
