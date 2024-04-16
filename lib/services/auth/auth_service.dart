import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';

class AuthService implements AuthProvider{
  final AuthProvider provider;
  const AuthService(this.provider);

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,}) => provider.createUser(
      email: email,
      password: password
  );

  @override
  // TODO: implement currentsUser
  AuthUser? get currentsUser => provider.currentsUser!;

  @override
  Future<AuthUser> login({
    required String email,
    required String password}) => provider.login(
      email: email,
      password: password,
  );

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
  
}