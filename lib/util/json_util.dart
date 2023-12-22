class JsonUtil {
  JsonUtil._();

  static T asT<T>(dynamic value, T defaultValue) {
    if (value == null) {
      return defaultValue;
    }
    try {
      if (value.runtimeType != defaultValue.runtimeType) {
        if (defaultValue is String) {
          return value.toString() as T;
        }

        if (defaultValue is int) {
          return int.parse(value.toString()) as T;
        }

        if (defaultValue is double) {
          return double.parse(value.toString()) as T;
        }
      }

      return value as T;
    } catch (e) {
      print(e);
    }
    return defaultValue;
  }
}
