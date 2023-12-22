import 'package:baseoo/base/lib_config.dart';
import 'package:baseoo/expand/extension.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../list_view_notifier.dart';
import '../load_state.dart';
import 'item_create.dart';

class ListCommonView<T> extends ConsumerStatefulWidget {
  const ListCommonView(this.provider, this._createItem,
      {this.loading,
      this.error,
      this.empty,
      this.onSuccess,
      this.lvController,
      Key? key})
      : super(key: key);

  final AutoDisposeStateNotifierProvider<ListViewStateNotifier<T>,
      LoadState<List<T>>> provider;

  final ItemCreate<T> _createItem;

  final Widget Function(Exception error, VoidCallback onPressed)? error;
  final Widget Function()? loading;
  final Widget Function(VoidCallback onPressed)? empty;
  final Function(List<T>)? onSuccess;
  final ScrollController? lvController;

  @override
  ConsumerState<ListCommonView<T>> createState() => _ListCommonViewState();
}

class _ListCommonViewState<T> extends ConsumerState<ListCommonView<T>> {
  @override
  Widget build(BuildContext context) {
    final watch = ref.watch(widget.provider);
    final notifier = ref.watch(widget.provider.notifier);

    return watch.load(
        () {
          invalidate();
        },
        loading: widget.loading,
        error: widget.error,
        (data) {
          widget.onSuccess?.call(data);
          return EasyRefresh.builder(
            onLoad: notifier.openLoadMore ? () => notifier.moreData() : null,
            onRefresh:
                notifier.openRefresh ? () => notifier.refreshData() : null,
            controller: notifier.refreshController,
            childBuilder: (context, physics) {
              if (data.isEmpty) {
                return SizedBox(
                    child: widget.empty?.call(() {
                          invalidate();
                        }) ??
                        LibConfig.EMPTY_VIEW?.call(() {
                          invalidate();
                        }));
              }
              return ListView.builder(
                  physics: physics,
                  controller: widget.lvController,
                  padding: EdgeInsets.zero,
                  itemCount: data.length,
                  itemBuilder: (c, i) => widget._createItem(c, i, data[i]));
            },
          );
        });
  }

  invalidate() => ref.invalidate(widget.provider);
}
