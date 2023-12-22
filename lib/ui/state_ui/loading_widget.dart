import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget.listView({
    this.color,
    super.key,
  })  : radius = 18.0,
        warpWithCenter = true;

  const LoadingWidget.capsuleInk({
    this.color,
    super.key,
  })  : radius = 15,
        warpWithCenter = false;

  final double radius;
  final bool warpWithCenter;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    Widget child = CupertinoActivityIndicator(
      radius: radius,
      color: color,
    );

    if (warpWithCenter) {
      child = Center(child: child);
    }

    return child;
  }
}
