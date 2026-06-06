import 'package:sistema_distribuido/core/shared/storage/token_storage.dart';

class LogoutUseCase {
  final TokenStorage _tokenStorage;

  LogoutUseCase(this._tokenStorage);

  Future<void> execute() async {
    await _tokenStorage.clearToken();
  }
}
