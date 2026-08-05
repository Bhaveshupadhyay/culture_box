import '../../../../core/errors/exceptions.dart';
import '../../../../core/models/user_model.dart';
import '../data/repositories/auth_repository.dart';

class AuthService {
  final AuthRepository authRepository;

  AuthService(this.authRepository);

  Future<User> login(String email, String password) async {
    final cleanEmail = email.trim();
    if (cleanEmail.isEmpty || !cleanEmail.contains('@')) {
      throw const ValidationException('Please enter a valid email address.');
    }
    if (password.trim().isEmpty) {
      throw const ValidationException('Please enter your password.');
    }

    return await authRepository.login(
      email: cleanEmail,
      password: password,
    );
  }

  Future<User> signup(String email, String password) async {
    final cleanEmail = email.trim();
    if (cleanEmail.isEmpty || !cleanEmail.contains('@')) {
      throw const ValidationException('Please enter a valid email address.');
    }
    if (password.length < 6) {
      throw const ValidationException('Password must be at least 6 characters.');
    }

    return await authRepository.register(
      email: cleanEmail,
      password: password,
    );
  }

  Future<User?> checkAuthSession() async {
    return await authRepository.getCurrentUser();
  }

  Future<void> logout() async {
    await authRepository.logout();
  }
}
