import 'package:flutter/material.dart';
import '../../widget/success_dialog.dart';
import '../../helpers/theme_config.dart';
import '../../widget/text_field.dart';
import '../../widget/button.dart';
import '../../controllers/auth_controller.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({super.key});

  @override
  State<RegistrasiPage> createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _prosesRegistrasi() async {
    if (_formKey.currentState!.validate()) {
      bool success = await AuthController().register(
        _namaController.text,
        _emailController.text,
        _passwordController.text,
      );

      if (!mounted) return;
      if (success) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => SuccessDialog(
            message: 'Akun berhasil dibuat. Silakan login.',
            onOkPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: AppTheme.textWhite),
              onPressed: () => Navigator.pop(context),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30, top: 10, bottom: 40),
              child: Text(
                'Create Your\nAccount',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textWhite,
                  height: 1.2,
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        AuthTextField(
                          label: 'Full Name',
                          controller: _namaController,
                          suffixIcon: Icon(
                            Icons.person_outline,
                            color: AppTheme.textSub,
                            size: 20,
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                        ),
                        const SizedBox(height: 24),
                        AuthTextField(
                          label: 'Gmail',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          suffixIcon: Icon(
                            Icons.check,
                            color: AppTheme.textSub,
                            size: 20,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email tidak boleh kosong';
                            }
                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value)) {
                              return 'Format email tidak valid';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        AuthTextField(
                          label: 'Password',
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppTheme.textSub,
                              size: 20,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                          validator: (value) => value!.length < 6
                              ? 'Password minimal 6 karakter'
                              : null,
                        ),
                        const SizedBox(height: 24),
                        AuthTextField(
                          label: 'Confirm Password',
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppTheme.textSub,
                              size: 20,
                            ),
                            onPressed: () => setState(
                              () => _obscureConfirmPassword =
                                  !_obscureConfirmPassword,
                            ),
                          ),
                          validator: (value) =>
                              value != _passwordController.text
                              ? 'Password tidak cocok'
                              : null,
                        ),
                        const SizedBox(height: 40),

                        Button(
                          text: 'SIGN UP',
                          isPillShape: true,
                          onPressed: _prosesRegistrasi,
                        ),

                        const SizedBox(height: 30),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: RichText(
                            text: TextSpan(
                              text: "Already have account? ",
                              style: TextStyle(color: AppTheme.textSub),
                              children: const [
                                TextSpan(
                                  text: 'Sign In',
                                  style: TextStyle(
                                    color: AppTheme.textWhite,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
