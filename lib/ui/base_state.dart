import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class BaseState<T extends ConsumerStatefulWidget>
    extends ConsumerState<T> {
  late final cancelToken = CancelToken();

  @override
  void dispose() {
    cancelToken.cancel();
    super.dispose();
  }

}
