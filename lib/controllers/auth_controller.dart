import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController {
  static final AuthController _instance = AuthController._internal();
  factory AuthController() => _instance;
  AuthController._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateStream => _auth.authStateChanges();

  Future<Map<String, dynamic>> register(
    String nama,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'nama': nama,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return {'status': true, 'message': 'Registrasi Berhasil'};
    } on FirebaseAuthException catch (e) {
      return {
        'status': false,
        'message': e.message ?? 'Terjadi kesalahan autentikasi',
      };
    } catch (e) {
      return {'status': false, 'message': 'Terjadi kesalahan sistem: $e'};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return {'status': true, 'message': 'Login Berhasil'};
    } on FirebaseAuthException catch (e) {
      String errMsg = 'Email atau password salah.';
      if (e.code == 'user-not-found') errMsg = 'Email belum terdaftar.';
      if (e.code == 'wrong-password') errMsg = 'Password salah.';
      return {'status': false, 'message': errMsg};
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<String> getActiveUsername() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (doc.exists && doc.data() != null) {
        return (doc.data() as Map<String, dynamic>)['nama'] ?? 'Member';
      }
    }
    return "Member";
  }
}
