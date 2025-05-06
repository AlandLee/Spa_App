import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/pages/signup/signup.dart';
import 'package:spa_app/services/auth_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    resizeToAvoidBottomInset: true,
    body: Row(
      children: [
        // Left side: Login form (2 phần)
        Expanded(
          flex: 2,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo + brand
                    Align(
                          alignment: Alignment.center,
                          child: Image.asset('images/logo_spa.jpg', width: 160),
                        ),
                    const Text(
                      'Đăng nhập tài khoản của bạn',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _emailField(),
                    const SizedBox(height: 10),
                    _passwordField(),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          // TODO: Forgot password
                        },
                        child: const Text(
                          'Quên mật khẩu?',
                          style: TextStyle(color: Colors.blue, fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _signinButton(context),
                    const SizedBox(height: 20),
                    _signup(context),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Right side: Image background (3 phần)
        Expanded(
          flex: 3,
          child: SizedBox.expand(
            child: Image.asset(
              'images/bg_spa.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    ),
  );
}


  Widget _emailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _labelText('Địa chỉ email'),
        const SizedBox(height: 12),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: _inputDecoration('email@example.com'),
        ),
      ],
    );
  }

  Widget _passwordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _labelText('Mật khẩu'),
        const SizedBox(height: 12),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: _inputDecoration('••••••••'),
        ),
      ],
    );
  }

  Widget _signinButton(BuildContext context) {
    return ElevatedButton(
      style: _buttonStyle(const Color.fromARGB(255, 231, 201, 29)),
      onPressed: () async {
        await _authService.signin(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          context: context,
        );
      },
      child: const Text("Đăng Nhập", style: TextStyle(color: Colors.white)),
    );
  }

  Widget _signup(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            const TextSpan(
              text: "Người dùng mới? ",
              style: TextStyle(color: Color(0xff6A6A6A), fontSize: 16),
            ),
            TextSpan(
              text: "Tạo tài khoản",
              style: const TextStyle(color: Color(0xff1A1D1E), fontSize: 16),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Signup()));
                },
            ),
          ],
        ),
      ),
    );
  }

  Widget _labelText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, color: Colors.black),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      filled: true,
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xff6A6A6A), fontSize: 14),
      fillColor: const Color(0xffF7F7F9),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  ButtonStyle _buttonStyle(Color color, {Color? borderColor}) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: borderColor != null ? BorderSide(color: borderColor) : BorderSide.none,
      ),
      minimumSize: const Size(double.infinity, 60),
      elevation: 0,
    );
  }
}
