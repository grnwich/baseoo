import 'package:baseoo/base/lib_config.dart';
import 'package:common_utils/common_utils.dart';

class SpUtil {
  SpUtil._();

  static final _sp = LibConfig.sp;

  static bool isToday({String tag = ""}) {
    final todayStr = DateUtil.formatDate(DateTime.now(), format: "yyyy-MM-dd");

    final isToday = SpUtil.getValue("is_today_${todayStr}_$tag", true);

    return isToday;
  }

  static saveToday({String tag = "", bool isToady = false}) {
    final todayStr = DateUtil.formatDate(DateTime.now(), format: "yyyy-MM-dd");

    SpUtil.setValue("is_today_${todayStr}_$tag", isToady);
  }

  static getValue<T>(String key, T defValue) {
    T? t;

    if (defValue is int) {
      t = _sp.getInt(key) as T?;
    } else if (defValue is String) {
      t = _sp.getString(key) as T?;
    } else if (defValue is bool) {
      t = _sp.getBool(key) as T?;
    } else if (defValue is double) {
      t = _sp.getDouble(key) as T?;
    }
    return t ?? defValue;
  }

  static Future<bool> remove(String key) async {
    return await _sp.remove(key);
  }

  static Future<bool> setValue(String key, dynamic value) async {
    if (value is int) {
      return await _sp.setInt(key, value);
    } else if (value is String) {
      return await _sp.setString(key, value);
    } else if (value is bool) {
      return await _sp.setBool(key, value);
    } else if (value is double) {
      return await _sp.setDouble(key, value);
    }
    return false;
  }
}
