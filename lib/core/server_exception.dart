import 'package:qurany_karim/model/error_result.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

abstract class ServerException {
  ErrorResult errorResult();
}

class BadRequestException extends ServerException {
  @override
  ErrorResult errorResult() {
    return ErrorResult(
        errorMessage: 'error'.tr(),
        errorImage: 'assets/icons/server.png');
  }
}

class UnauthorisedException extends ServerException {
  @override
  ErrorResult errorResult() {
    return ErrorResult(
        errorMessage: 'error'.tr(),
        errorImage: 'assets/icons/server.png');
  }
}

class FetchDataException extends ServerException {
  @override
  ErrorResult errorResult() {
    return ErrorResult(
        errorMessage: 'error'.tr(),
        errorImage: 'assets/icons/server.png');
  }
}