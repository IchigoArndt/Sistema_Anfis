import 'package:sistema_distribuido/core/errors/auth_exceptions.dart';
import 'package:sistema_distribuido/core/features/login/domain/entities/UserAuthentication.dart';
import 'package:sistema_distribuido/core/features/login/domain/services/IUserAuthenticationSerivce.dart';
import 'package:sistema_distribuido/core/shared/storage/token_storage.dart';

// Credenciais de demonstração — remover ao integrar o backend real
const Map<String, String> _fakeUsers = {
  'admin@anfis.com': 'admin123',
  'user@anfis.com':  'user123',
};

// Token JWT-like fake com payload decodificável (base64)
// header: {"alg":"none","typ":"JWT"}
// payload: {"sub":"demo","name":"Demo User","role":"Admin","exp":9999999999}
const String _fakeToken =
    'eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0'
    '.eyJzdWIiOiJkZW1vIiwibmFtZSI6IkRlbW8gVXNlciIsInJvbGUiOiJBZG1pbiIsImV4cCI6OTk5OTk5OTk5OX0'
    '.fake';

class FakeAuthRepositoryImpl implements IAuthenticationService {
  final TokenStorage _tokenStorage;

  FakeAuthRepositoryImpl({required TokenStorage tokenStorage})
      : _tokenStorage = tokenStorage;

  @override
  Future<bool> login(UserAuthentication userAuthentication) async {
    // Simula latência de rede para o indicador de loading aparecer
    await Future.delayed(const Duration(milliseconds: 800));

    final expected = _fakeUsers[userAuthentication.username.trim().toLowerCase()];

    if (expected == null || expected != userAuthentication.password) {
      throw const InvalidCredentialsException();
    }

    await _tokenStorage.saveToken(
      _fakeToken,
      DateTime.now().add(const Duration(days: 365)),
    );

    return true;
  }
}
