
class AppException implements Exception {
  String? _message;

  String get message => _message ?? runtimeType.toString();

  int? _code;

  int get code => _code ?? -1;

  bool _isCancel = false;

  bool get isCancel => _isCancel;

  AppException(this._message, this._code, {bool isCancel = false}) {
    _isCancel = isCancel;
  }

  @override
  String toString() {
    return "code:$code--message=$message";
  }
}
