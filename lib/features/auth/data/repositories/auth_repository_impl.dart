
import '../../domain/repositories/auth_repository.dart';
import '../auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<String> login({
    required String email,
    required String password,
  }) async {
    return await AuthService.login(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await AuthService.signUp(
      name: name,
      email: email,
      password: password,
    );
  }
}
