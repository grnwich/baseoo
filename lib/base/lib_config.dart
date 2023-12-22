import 'package:baseoo/http/exception.dart';
import 'package:baseoo/util/os_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LibConfig {
  LibConfig._();

  static SharedPreferences sp = _sp!;

  static SharedPreferences? _sp;

  static Future init({bool isDebug = true}) async {
    _isDebug = isDebug;
    _sp = await SharedPreferences.getInstance();

    if (OSUtil.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
          .copyWith(statusBarColor: Colors.transparent));
    }
  }

  static Color _LINE_GRAY = const Color(0xffF2F2F2);

  static Color _TXT_COLOR = const Color(0xffF2F2F2);

  static Color? _FILLING_COLOR;

  static String? _ERROR_IMG;

  static String? _PLACE_IMG;

  static Color? get LINE_GRAY => _LINE_GRAY;

  static Color? get TXT_COLOR => _TXT_COLOR;

  static Color? get FILLING_COLOR => _FILLING_COLOR;

  static String? get ERROR_IMG => _ERROR_IMG;

  static String? get PLACE_IMG => _PLACE_IMG;

  static bool _isDebug = true;

  static bool get isDebug => _isDebug;

  static String _BASE_URL = "";

  static int _ConnectTimeout = 15;

  static String get BASE_URL => _BASE_URL;

  static int get ConnectTimeout => _ConnectTimeout;

  static int _SUCCESS_CODE = 200;

  static int get SUCCESS_CODE => _SUCCESS_CODE;

  static Widget Function()? _LOADING_VIEW;

  static Widget Function()? get LOADING_VIEW => _LOADING_VIEW;

  static Widget Function(Exception error, VoidCallback onPressed)?
      _ERROR_VIEW;

  static Widget Function(Exception error, VoidCallback onPressed)?
      get ERROR_VIEW => _ERROR_VIEW;

  static Widget Function(VoidCallback onPressed)? _EMPTY_VIEW;

  static Widget Function(VoidCallback onPressed)? get EMPTY_VIEW => _EMPTY_VIEW;

  // lineColor 分割线颜色
  static initUI({
    Color? lineColor,
    Color? txtColor,
    String? errorImg,
    String? placeImg,
    Color? fillingColor,
  }) {
    if (lineColor != null) _LINE_GRAY = lineColor;
    if (txtColor != null) _TXT_COLOR = txtColor;
    if (errorImg != null) _ERROR_IMG = errorImg;
    if (placeImg != null) _PLACE_IMG = placeImg;
    if (errorImg != null && _PLACE_IMG == null) _PLACE_IMG = errorImg;
    if (fillingColor != null) _FILLING_COLOR = fillingColor;
  }

  static initHttp(
      {required String baseUrl,
      AppException Function(Exception error)? error,
      Widget Function()? loadingView,
      Widget Function(Exception error, VoidCallback onPressed)? errorView,
      Widget Function(VoidCallback onPressed)? emptyView,
      int timeout = 15}) {
    _BASE_URL = baseUrl;
    _LOADING_VIEW = loadingView;
    _ERROR_VIEW = errorView;
    _EMPTY_VIEW = emptyView;
    _ConnectTimeout = timeout;
  }
}
