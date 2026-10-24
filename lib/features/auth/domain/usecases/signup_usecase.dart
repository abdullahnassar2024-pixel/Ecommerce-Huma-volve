
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<void> call({
    required String name,
    required String email,
    required String password,
  }) async {
    await repository.signUp(
      name: name,
      email: email,
      password: password,
    );
  }
}
