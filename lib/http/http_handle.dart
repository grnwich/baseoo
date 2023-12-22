
import 'exception.dart';

typedef QuestSuccess<T> = Function(T value);
typedef QuestFail = Function(Exception fail);
typedef QuestComplete = Function(bool success);

class HttpHandle {
  HttpHandle._();

  static d<T>(Future<T> quest, QuestSuccess<T> success,
      {QuestFail? fail, QuestComplete? complete}) async {
    try {
      final result = await quest;
      success.call(result);
      complete?.call(true);
    } on Exception catch (e) {
      if (e is AppException) {
        if (!e.isCancel) {
          fail?.call(e);
        }
      } else {
        fail?.call(e);
      }
      complete?.call(false);
    }
  }
}
