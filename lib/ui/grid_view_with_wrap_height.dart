import '../export.dart';

class GridWrapHeightView<T> extends StatelessWidget {
  GridWrapHeightView(this.count, this.data, this.child,
      {this.spacing,
      this.topMargin,
      this.startMargin,
      this.endMargin,
      this.isVertical = true,
      this.wrapScrollView,
      this.crossAxisAlignment = CrossAxisAlignment.start,
      this.mainAxisSize = MainAxisSize.max,
      this.controller,
      super.key});

  final List<T> data;

  final int count;

  final double? startMargin;
  final double? endMargin;
  final double? spacing;
  final double? topMargin;

  final bool isVertical;

  final bool? wrapScrollView;

  final CrossAxisAlignment crossAxisAlignment;

  final MainAxisSize mainAxisSize;

  final ScrollController? controller;

  Widget Function(int index, T data) child;

  @override
  Widget build(BuildContext context) {
    return isVertical ? verticalBody() : horizontalBody();
  }

  Widget verticalBody() {
    List<Widget> r = [];

    int size = getSize();

    int index = 0;
    for (var i = 0; i < size; i++) {
      List<Widget> w = [];

      if (count > 0) {
        for (var j = 0; j < count; j++) {
          if (spacing != null && j > 0 && j < count) {
            w.add(UI.w(spacing!));
            if (index < data.length) {
              w.add(Expanded(child: child.call(index, data[index])));
            } else {
              w.add(Expanded(child: Container()));
            }
          } else {
            if (index < data.length) {
              w.add(Expanded(child: child.call(index, data[index])));
            } else {
              w.add(Expanded(child: Container()));
            }
          }
          index++;
        }
      } else {
        if (i < data.length) {
          w.add(child.call(i, data[i]));
        }
      }

      if (topMargin != null && i != 0) {
        r.add(UI.h(topMargin!));
      }

      r.add(Row(
        crossAxisAlignment: crossAxisAlignment,
        children: w,
      ));
    }

    final contentView = Padding(
        padding: EdgeInsets.only(left: startMargin ?? 0, right: endMargin ?? 0),
        child: Column(
          mainAxisSize: mainAxisSize,
          children: r,
        ));

    if (wrapScrollView != true) {
      return contentView;
    }

    return SingleChildScrollView(controller: controller, child: contentView);
  }

  Widget horizontalBody() {
    List<Widget> r = [];

    int size = getSize();

    int index = 0;

    for (var i = 0; i < size; i++) {
      List<Widget> w = [];

      if (count > 0) {
        for (var j = 0; j < count; j++) {
          if (topMargin != null && j > 0 && j < count) {
            w.add(UI.h(topMargin!));
            if (index < data.length) {
              w.add(child.call(index, data[index]));
            }
          } else {
            if (index < data.length) {
              w.add(child.call(index, data[index]));
            }
          }
          index++;
        }
      } else {
        if (i < data.length) {
          w.add(child.call(i, data[i]));
        }
      }

      if (spacing != null && i != 0 && i < size) {
        r.add(UI.w(spacing!));
      }
      r.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: w,
      ));
    }

    if (startMargin != null) {
      r.insert(0, UI.w(startMargin!));
    }
    if (endMargin != null) {
      r.add(UI.w(startMargin!));
    }

    var contentView = Row(
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      children: r,
    );

    if (wrapScrollView == false) {
      return contentView;
    }

    return SingleChildScrollView(
        controller: controller,
        scrollDirection: Axis.horizontal,
        child: contentView);
  }

  int getSize() {
    int size = 0;

    if (count > 0) {
      size = data.length ~/ count;
      if (data.length % count != 0) {
        size++;
      }
    } else {
      size = data.length;
    }

    return size;
  }
}
