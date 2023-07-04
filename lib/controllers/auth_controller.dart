import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fa_1213022/screens/todo_list.dart';

class AuthController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> loginUser(BuildContext context) async {
    const url = 'http://192.168.1.4:8080/api/user/login';

    var response = await http.post(Uri.parse(url),
        body: jsonEncode({
          "username": usernameController.text,
          "password": passwordController.text,
        }));

    if (response.statusCode == 200) {
      var loginArr = json.decode(response.body);
      String token = loginArr['token'];

      // Simpan token ke shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      // Navigasi ke halaman login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TodoListPage()),
      );
    } else {
      // Handle kasus lainnya (misalnya jika login gagal)
    }
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Login'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Login'),
          onPressed: () {
            // Logic untuk melakukan login dan verifikasi token dari shared preferences
            verifyToken(context);
          },
        ),
      ),
    );
  }

  Future<void> verifyToken(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      // Token tersedia, lakukan verifikasi token atau tindakan lainnya sesuai kebutuhan aplikasi
      // Misalnya, mengirim token ke server untuk verifikasi

      // Jika token valid, arahkan ke halaman selanjutnya
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NextPage()),
      );
    } else {
      // Token tidak tersedia atau tidak valid, arahkan kembali ke halaman login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }
}

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Selanjutnya'),
      ),
      body: Center(
        child: Text('Ini adalah halaman selanjutnya setelah login berhasil'),
      ),
    );
  }
}
