import 'package:baseoo/util/ui_util.dart';
import 'package:flutter/material.dart';

class TitleCommonView extends StatelessWidget {
  const TitleCommonView(this.title,
      {this.intercept,
      this.centerChild,
      this.rightChild,
      this.showBack = true,
      this.bgColor = Colors.white,
      this.arrowColor = Colors.black,
      super.key});

  final Future<bool> Function()? intercept;

  final String title;

  final bool showBack;

  final Widget? centerChild;

  final Widget? rightChild;

  final Color bgColor;

  final Color arrowColor;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      height: 45 + top,
      padding: EdgeInsets.only(top: top),
      color: bgColor,
      child: Stack(children: [
        Align(
          alignment: Alignment.center,
          child:
              centerChild ?? UI.t(title, size: 18, fontType: FontType.MED),
        ),
        if (showBack)
          Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                  onTap: () {
                    if (intercept != null) {
                      intercept?.call().then((value) {
                        if (value) {
                          Navigator.of(context).pop();
                        }
                      });
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    child:  Icon(Icons.arrow_back_ios, color: arrowColor),
                  ))),
        if (rightChild != null)
          Align(alignment: Alignment.centerRight, child: rightChild)
      ]),
    );
  }
}
