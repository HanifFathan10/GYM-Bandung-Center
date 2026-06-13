import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  static final AuthController _instance = AuthController._internal();
  factory AuthController() => _instance;
  AuthController._internal();

  Future<bool> register(String nama, String email, String password) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('reg_nama', nama);
      await prefs.setString('reg_email', email);
      await prefs.setString('reg_password', password);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('reg_email');
    String? savedPassword = prefs.getString('reg_password');
    String? savedNama = prefs.getString('reg_nama');

    if (savedEmail == null || savedPassword == null) {
      return {
        'status': false,
        'message': 'Akun tidak ditemukan. Silakan registrasi terlebih dahulu.',
      };
    }

    if (email == savedEmail && password == savedPassword) {
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('username', savedNama ?? 'Member');
      return {'status': true, 'message': 'Login Berhasil'};
    } else {
      return {
        'status': false,
        'message': 'Email atau Password salah. Silakan periksa kembali.',
      };
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<String> getActiveUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? "Member";
  }
}
