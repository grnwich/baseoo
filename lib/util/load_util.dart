import 'package:baseoo/export.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class LoadUtil {
  LoadUtil._();

  static void show([String? text]) {
    SmartDialog.showLoading(
        msg: text ?? 'Loading...', maskColor: Colors.transparent);
  }

  static void dismiss() {
    SmartDialog.dismiss();
  }
}
