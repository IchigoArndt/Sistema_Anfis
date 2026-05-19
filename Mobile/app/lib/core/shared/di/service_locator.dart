import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:sistema_distribuido/core/features/login/data/repositories/fake_auth_repository_impl.dart';
import 'package:sistema_distribuido/core/features/login/domain/services/IUserAuthenticationSerivce.dart';
import 'package:sistema_distribuido/core/shared/storage/token_storage.dart';

// Imports do backend real — descomentar ao integrar a API
// import 'package:sistema_distribuido/core/features/login/data/repositories/auth_repository_impl.dart';
// import 'package:sistema_distribuido/core/features/login/data/services/auth_service.dart';
// import 'package:sistema_distribuido/core/shared/http/api_client.dart';
// import 'package:sistema_distribuido/core/shared/http/auth_interceptor.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  sl.registerLazySingleton<TokenStorage>(
    () => TokenStorage(sl<FlutterSecureStorage>()),
  );

  // Modo demonstração: usa FakeAuthRepositoryImpl sem precisar do backend
  // Para voltar à auth real, substituir por AuthRepositoryImpl (ver imports comentados acima)
  sl.registerLazySingleton<IAuthenticationService>(
    () => FakeAuthRepositoryImpl(tokenStorage: sl<TokenStorage>()),
  );
}
