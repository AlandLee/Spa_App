import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import '../pages/home/home.dart'; // Import màn hình Home
import '../pages/login/login.dart'; // Import màn hình Login
//import 'package:sqflite_common_ffi/sqflite_ffi.dart';
//import 'package:path/path.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // databaseFactory = databaseFactoryFfi;

  // final dbDir = await databaseFactory.getDatabasesPath();
  // final fullPath = join(dbDir, 'app.db');
  // print('Deleting DB at: $fullPath');

  // await databaseFactory.deleteDatabase(fullPath);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthCheck(), // Điều hướng dựa trên trạng thái đăng nhập
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return Home(); // Nếu đã đăng nhập, vào Home
        }
        return Login(); // Nếu chưa, vào màn hình Login
      },
    );
  }
}
