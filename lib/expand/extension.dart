import 'package:baseoo/base/lib_config.dart';
import 'package:baseoo/http/exception.dart';
import 'package:baseoo/ui/load_state.dart';
import 'package:baseoo/ui/state_ui/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

extension CancelTokenX on Ref {
  CancelToken cancelToken() {
    final CancelToken cancelToken = CancelToken();
    onDispose(cancelToken.cancel);

    return cancelToken;
  }
}

extension ExceptionExtension on Exception? {
  AppException? get appError =>
      (this is AppException) ? this as AppException : null;
}

extension StringExtension on String? {
  bool get notEmpty => this?.isNotEmpty ?? false;

  int toInt({int defaultValue = 0}) {
    if (!notEmpty) {
      return defaultValue;
    }

    try {
      return int.parse(this!);
    } catch (e) {
      return defaultValue;
    }
  }

  double toDouble({double defaultValue = 0}) {
    if (!notEmpty) {
      return defaultValue;
    }

    try {
      return double.parse(this!);
    } catch (e) {
      return defaultValue;
    }
  }

  String toStr({String defaultValue = ""}) {
    if (!notEmpty) {
      return defaultValue;
    }
    return this!;
  }
}

extension AsyncValueExtension<T> on AsyncValue<T> {
  Widget load(
    VoidCallback onPressed,
    Widget Function(T data) success, {
    Widget Function(Exception error, VoidCallback onPressed)? error,
    Widget Function()? loading,
    Size? size,
    bool withSliver = false,
  }) {
    var loadingView = loading?.call() ??
        LibConfig.LOADING_VIEW?.call() ??
        const LoadingWidget.listView();

    if (size != null) {
      loadingView = SizedBox.fromSize(size: size, child: loadingView);
    }
    if (withSliver) {
      loadingView = SliverToBoxAdapter(
        child: loadingView,
      );
    }
    errorCall(AsyncError e) {
      var errorView = error?.call(e.error as AppException, onPressed) ??
          LibConfig.ERROR_VIEW?.call(e.error as AppException, onPressed);

      if (size != null) {
        errorView = SizedBox.fromSize(size: size, child: errorView);
      }
      if (withSliver) {
        errorView = SliverToBoxAdapter(
          child: errorView,
        );
      }
      errorView ??= const SizedBox();
      return errorView;
    }

    return map(
        data: (data) => success.call(data.value),
        error: errorCall,
        loading: (load) => loadingView);
  }
}

extension BaseStateExtension<T> on LoadState<T> {
  Widget load(
    VoidCallback onPressed,
    Widget Function(T data) success, {
    Widget Function(Exception error, VoidCallback onPressed)? error,
    Widget Function()? loading,
    Size? size,
    bool withSliver = false,
  }) {
    var loadingView = loading?.call() ??
        LibConfig.LOADING_VIEW?.call() ??
        const LoadingWidget.listView();

    if (size != null) {
      loadingView = SizedBox.fromSize(size: size, child: loadingView);
    }
    if (withSliver) {
      loadingView = SliverToBoxAdapter(
        child: loadingView,
      );
    }
    errorCall(Error e) {
      var errorView = error?.call(e.error, onPressed) ??
          LibConfig.ERROR_VIEW?.call(e.error, onPressed);

      if (size != null) {
        errorView = SizedBox.fromSize(size: size, child: errorView);
      }
      if (withSliver) {
        errorView = SliverToBoxAdapter(
          child: errorView,
        );
      }
      errorView ??= const SizedBox();
      return errorView;
    }

    return map(
        loading: (load) => loadingView,
        success: (data) => success.call(data.data),
        error: errorCall);
  }
}
