import 'dart:io';

import 'package:flutter/foundation.dart';

class OSUtil {
  OSUtil._();

  static bool get isWeb => kIsWeb;

  static bool get isAndroid => isWeb ? false : Platform.isAndroid;

  static bool get isIOS => isWeb ? false : Platform.isIOS;

  static bool get isWindows => isWeb ? false : Platform.isWindows;

  static bool get isLinux => isWeb ? false : Platform.isLinux;

  static bool get isMacOS => isWeb ? false : Platform.isMacOS;

  static bool get isApp => isIOS || isAndroid;
}
