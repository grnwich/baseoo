import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../base/lib_config.dart';

enum FontType { NOR, MED, BOLD }

class UI {
  UI._();


  static Widget bg({
    required Widget? child,
    Color? color,
    Color? startColor,
    Color? endColor,
    List<Color>? gradientColors,
    double? height,
    double? width,
    Color? strokeColor,
    double? strokeSize = 1, //描边
    AlignmentGeometry? alignment,
    double radius = 0,
    double? topRightRadius,
    double? topLeftRadius,
    double? bottomRightRadius,
    double? bottomLeftRadius,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Alignment startAngele = Alignment.centerLeft,
    Alignment endAngele = Alignment.centerRight,
    GestureTapCallback? onTap,
    Key? key,
  }) {
    final borderRadius = (topRightRadius != null ||
        topLeftRadius != null ||
        bottomRightRadius != null ||
        bottomLeftRadius != null)
        ? BorderRadius.only(
      topLeft: Radius.circular(topLeftRadius ?? 0),
      topRight: Radius.circular(topRightRadius ?? 0),
      bottomLeft: Radius.circular(bottomLeftRadius ?? 0),
      bottomRight: Radius.circular(bottomRightRadius ?? 0),
    )
        : BorderRadius.circular(radius);

    var gradient;

    if (startColor != null && endColor != null) {
      gradient = LinearGradient(
          begin: startAngele, end: endAngele, colors: [startColor, endColor]);
      color = null;
    } else if (gradientColors != null) {
      gradient = LinearGradient(
          begin: startAngele, end: endAngele, colors: gradientColors);
      color = null;
    }

    BoxBorder? border;

    if (strokeColor != null && strokeSize != null) {
      border = Border.all(width: strokeSize, color: strokeColor);
    }

    final widget = Container(
      key: key,
      padding: padding,
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius,
          color: color,
          gradient: gradient),
      alignment: alignment,
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        child: widget,
      );
    }

    return widget;
  }

  static Widget line({double? height = 0.5, double? width, Color? color}) {
    color ??= LibConfig.LINE_GRAY;
    return Container(height: height, width: width, color: color);
  }

  static Widget w(double size) {
    return hw2(size, 0);
  }

  static Widget h(double size) {
    return hw2(0, size);
  }

  static Widget hw(double size) {
    return hw2(size, size);
  }

  static Widget hw2(double width, double height) {
    return SizedBox(
      height: height,
      width: width,
    );
  }

  static Widget animation({required Widget child, int milliseconds = 400}) {
    return AnimatedSwitcher(
        transitionBuilder: (child, anim) {
          return ScaleTransition(scale: anim, child: child);
        },
        duration: Duration(milliseconds: milliseconds),
        child: child);
  }

  static Widget t(String? data,
      {Color? color,
        double? size,
        int? maxLines,
        FontType fontType = FontType.NOR,
        TextAlign? align,
        FontWeight? fontWeight,
        bool auto = false,
        double minFontSize = 6,
        TextDecoration? decoration,
        TextOverflow? overflow}) {
    if (maxLines != null && overflow == null) {
      overflow = TextOverflow.ellipsis;
    }

    color ??= LibConfig.TXT_COLOR;

    final style = TextStyle(
        color: color,
        fontSize: size,
        decoration: decoration,
        fontWeight: fontWeight ??
            (fontType == FontType.BOLD
                ? FontWeight.w700
                : fontType == FontType.MED
                ? FontWeight.w500
                : null));
    if (auto || minFontSize != 6) {
      return AutoSizeText(
        data ?? "",
        style: style,
        minFontSize: minFontSize,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: align,
      );
    }

    return Text(
      data ?? "",
      style: style,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: align,
    );
  }
}
