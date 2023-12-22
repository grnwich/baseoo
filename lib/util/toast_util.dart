import 'package:baseoo/expand/extension.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class Toast {

  Toast._();

  static void show(String? msg) {
    if (!msg.notEmpty) {
      return;
    }
    SmartDialog.showToast(msg!);
  }

  static void showWithTime(String? msg, int milliseconds) {
    if (!msg.notEmpty) {
      return;
    }
    SmartDialog.showToast(
        msg!, displayTime: Duration(milliseconds: milliseconds));
  }
}
