import '../model/signin_model.dart';
import '../service/login_Service.dart';

class LoginRepository {
  final LoginService loginService = LoginService();

  Datum? _lastLoggedInUser;

  // Login method that stores the first user from the response
  Future<Welcome?> loginRepository(String email, String password) async {
    final response = await loginService.loginService(email, password);

    if (response != null && response.status && response.data.isNotEmpty) {
      _lastLoggedInUser = response.data.first;
      print('Logged-in User: ${_lastLoggedInUser!.email}');
    } else {
      print('Login failed or no user data returned');
    }

    return response;
  }

  // Getter for the last logged-in user
  Datum? get lastLoggedInUser => _lastLoggedInUser;
}
