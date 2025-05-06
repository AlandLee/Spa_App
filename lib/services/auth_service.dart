
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../pages/home/home.dart';
import '../pages/login/login.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signup({
  required String name,
  required String email,
  required String password,
  required BuildContext context,
}) async {
  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Email and password cannot be empty.'),
        backgroundColor: Colors.grey[900],
        behavior: SnackBarBehavior.floating,
      ),
    );
    return;
  }

  try {
    // Đăng ký Firebase
    UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;

    if (user != null) {
      // Cập nhật tên hiển thị cho người dùng
      await user.updateDisplayName(name);
      await user.reload(); // Làm mới thông tin user

      // Lấy lại user mới nhất sau khi cập nhật
      User? updatedUser = FirebaseAuth.instance.currentUser;

      print("✅ Display Name Updated: ${updatedUser?.displayName}");

      // Lưu dữ liệu vào server ngay sau khi đăng ký thành công
      if (updatedUser != null) {
        // Gọi API để lưu user vào server
        await _saveUserToRDS(updatedUser);
      } else {
        print("⚠️ Lỗi: Không thể cập nhật user!");
      }

      // Chuyển hướng đến trang Home
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
    } else {
      print("⚠️ Lỗi: User không tồn tại!");
    }
  } on FirebaseAuthException catch (e) {
    String message = _getFirebaseErrorMessage(e.code);
    
    if (e.code == 'keychain-error') {
      // Nếu gặp keychain-error, đăng xuất và đăng nhập lại
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi truy cập thông tin đăng nhập. Đang đăng xuất và yêu cầu đăng nhập lại.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Đăng xuất người dùng
      await FirebaseAuth.instance.signOut();

      // Thực hiện đăng nhập lại nếu email đã tồn tại
      try {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        // Sau khi đăng nhập lại, gọi API để lưu user vào server
        User? updatedUser = FirebaseAuth.instance.currentUser;

        if (updatedUser != null) {
          await _saveUserToRDS(updatedUser);
        }

        // Chuyển hướng đến trang Home sau khi đăng nhập lại
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          // Nếu không tìm thấy người dùng, thông báo lỗi
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Không tìm thấy tài khoản với email này. Vui lòng thử lại.'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          // Xử lý các lỗi khác khi đăng nhập lại
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Lỗi khi đăng nhập lại: ${e.message}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      // Xử lý lỗi khác nếu không phải keychain-error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.grey[900],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("An unexpected error occurred. Please try again."),
        backgroundColor: Colors.grey[900],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}




  Future<bool> _saveUserToRDS(User user) async {
  try {
    print("🚀 Bắt đầu lưu user lên RDS...");

    // URL của backend API
    const String apiUrl = "http://14.225.217.157:3002/users";

    // Chuẩn bị dữ liệu để gửi
    final Map<String, dynamic> userData = {
      "uid": user.uid,
      "email": user.email,
      "name": user.displayName?.trim().isNotEmpty == true
          ? user.displayName
          : "Unknown",
    };

    print("📦 Dữ liệu gửi đi: $userData");

    // Gửi POST request tới server
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        // Nếu backend chưa yêu cầu token xác thực thì không cần dòng dưới
        // "Authorization": "Bearer ${await user.getIdToken()}",
      },
      body: jsonEncode(userData),
    );

    print("📡 Response status: ${response.statusCode}");
    print("📡 Response body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("✅ User saved successfully.");
      return true;
    } else {
      print("⚠️ Lưu user thất bại. Status: ${response.statusCode}");
      return false;
    }
  } catch (e) {
    print("❌ Lỗi khi lưu user vào RDS: $e");
    return false;
  }
}


  String _getFirebaseErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists with that email.';
      case 'invalid-email':
        return 'Invalid email format.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context
  }) async {
    
    try {

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );

      await Future.delayed(const Duration(seconds: 1));
      if (context.mounted) {  // 🔹 Kiểm tra widget còn mounted không
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const Home()),
      );
    }
      
    } on FirebaseAuthException catch(e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'No user found for that email.';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for that user.';
      } else {
        message = 'An error occurred: ${e.code}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.grey[200],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

  }

  Future<void> signout({required BuildContext context}) async {
  try {
    print("Bắt đầu đăng xuất...");

    // Đăng xuất Firebase
    print("Đăng xuất Firebase...");
    await FirebaseAuth.instance.signOut();
    print("Đã đăng xuất Firebase!");

    // Chờ một chút để đảm bảo signOut hoàn tất
    await Future.delayed(const Duration(milliseconds: 300));

    // Kiểm tra context trước khi chuyển màn hình
    if (context.mounted) {
      print("Chuyển về màn hình đăng nhập...");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        (route) => false,
      );
      print("Chuyển màn hình thành công!");
    }
  } catch (e) {
    print("Lỗi khi đăng xuất: $e");
  }
}

}
