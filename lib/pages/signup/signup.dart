import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/pages/login/login.dart';
import 'package:spa_app/services/auth_service.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                      'Đăng ký tài khoản của bạn',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _nameField(),
                    const SizedBox(height: 10),
                    _emailAddress(),
                    const SizedBox(height: 10),
                    _password(),
                    const SizedBox(height: 20),
                    _signup(context),
                     const SizedBox(height: 20),
                    _signin(context)
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

  Widget _nameField() {
    return _inputField(
      label: 'Tên đầy đủ',
      hintText: 'Nhập tên...',
      controller: _nameController,
    );
  }

  Widget _emailAddress() {
    return _inputField(
      label: 'Địa chỉ email',
      hintText: 'email@example.com',
      controller: _emailController,
      autofillHints: [AutofillHints.email],
    );
  }

  Widget _password() {
    return _inputField(
      label: 'Mật khẩu',
      hintText: 'Nhập mật khẩu',
      controller: _passwordController,
      obscureText: true,
    );
  }

  Widget _inputField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    bool obscureText = false,
    List<String>? autofillHints,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          autofillHints: autofillHints,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xffF7F7F9),
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xff6A6A6A), fontSize: 14),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _signup(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 231, 201, 29),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        minimumSize: const Size(double.infinity, 60),
      ),
      onPressed: () async {
        await AuthService().signup(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          context: context,
        );
      },
      child: const Text("Đăng ký", style: TextStyle(color: Colors.white)),
    );
  }

  Widget _signin(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              const TextSpan(
                text: "Đã có tài khoản? ",
                style: TextStyle(color: Color(0xff6A6A6A), fontSize: 16),
              ),
              TextSpan(
                text: "Đăng nhập",
                style: const TextStyle(color: Color(0xff1A1D1E), fontSize: 16),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
