import 'package:freezed_annotation/freezed_annotation.dart';

part 'load_state.freezed.dart';

@freezed
class LoadState<T> with _$LoadState<T> {
  const factory LoadState.loading() = Loading;

  const factory LoadState.success(T data) = Success<T>;

  const factory LoadState.error(Exception error) = Error;
}
