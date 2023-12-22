import 'dart:io';

import 'package:baseoo/expand/extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../base/lib_config.dart';

class Img {
  Img._();

  static Widget asset(String path,
      {BoxFit fit = BoxFit.cover,
        double radius = 0,
        double? width,
        double? both, //如果设置这个, width和height都以这个为主
        double? height,
        Color? color,
        bool gaplessPlayback = false}) {
    return _realImg(path, 0,
        fit: fit,
        radius: radius,
        width: width,
        height: height,
        both: both,
        color: color,
        gaplessPlayback: gaplessPlayback);
  }

  static Widget file(String path,
      {BoxFit fit = BoxFit.cover,
        double radius = 0,
        double? width,
        double? both, //如果设置这个, width和height都以这个为主
        double? height,
        Color? color,
        bool gaplessPlayback = false}) {
    return _realImg(path, 1,
        fit: fit,
        radius: radius,
        width: width,
        height: height,
        both: both,
        gaplessPlayback: gaplessPlayback);
  }

  static Widget _realImg(String path, int loadType,
      {BoxFit fit = BoxFit.cover,
        double radius = 0,
        double? width,
        double? both, //如果设置这个, width和height都以这个为主
        double? height,
        Color? color,
        bool gaplessPlayback = false}) {
    if (both != null) {
      width = both;
      height = both;
    }

    Image img;

    if (loadType == 0) {
      img = Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        color: color,
        gaplessPlayback: gaplessPlayback,
      );
    } else {
      img = Image.file(
        File(path),
        width: width,
        height: height,
        fit: fit,
        color: color,
        gaplessPlayback: gaplessPlayback,
      );
    }

    if (radius == 0) return img;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: img,
    );
  }

  static Widget load(String? url,
      {double? width,
        double? height,
        double? radius,
        double? both, //如果设置这个, width和height都以这个为主
        BoxFit? fit = BoxFit.cover,
        BoxFit errFit = BoxFit.none,
        bool useBuilder = true, //不适用builder,只要宽高圆角都不生效
        String? errorImg,
        String? placeImg,
        Color? color,
        bool gaplessPlayback = false,
        void Function(ImageProvider imageProvider)? success}) {
    if (both != null) {
      width = both;
      height = both;
    }
    errorImg ??= LibConfig.ERROR_IMG;

    placeImg ??= LibConfig.PLACE_IMG;

    if (!url.notEmpty) {
      return _conError(errorImg, width, height, radius, errFit);
    }

    return CachedNetworkImage(
        imageUrl: url!,
        imageBuilder: (context, imageProvider) {
          final img = useBuilder
              ? _con(imageProvider, width, height, radius, fit)
              : Image(image: imageProvider, color: color);
          success?.call(imageProvider);
          return img;
        },
        placeholder: (context, url) =>
            _conError(placeImg, width, height, radius, errFit),
        errorWidget: (context, url, error) =>
            _conError(errorImg, width, height, radius, errFit));
  }

  static Widget _conError(errorImg, width, height, radius, errFit) {
    if (errorImg == null) return const SizedBox();
    return _con(AssetImage(errorImg), width, height, radius, errFit);
  }

  static Widget _con(image, double? width, double? height, double? radius,
      BoxFit? fit) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: LibConfig.FILLING_COLOR,
        borderRadius:
        radius == null ? null : BorderRadius.all(Radius.circular(radius)),
        image: DecorationImage(
          image: image,
          fit: fit,
        ),
      ),
    );
  }
}
