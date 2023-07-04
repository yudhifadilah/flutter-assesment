import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({Key? key}) : super(key: key);

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Logout'),
        ),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () {
                    logout();
                  },
                  child: const Text('Logout'),
                ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    SystemNavigator.pop();
    return Future.value(true);
  }

  Future<void> logout() async {
    setState(() {
      isLoading = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token != null) {
      final url =
          'http://192.168.1.4/api/user/logout'; // Ganti dengan URL endpoint logout
      final response = await http.post(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        prefs.remove('token');
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }
    }

    setState(() {
      isLoading = false;
    });
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'username',
                      ),
                    ),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        register();
                      },
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> register() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    setState(() {
      isLoading = true;
    });

    final url =
        'http://192.168.1.4/api/user/register'; // Ganti dengan URL endpoint register
    final response = await http.post(
      Uri.parse(url),
      body: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', jsonDecode(response.body)['token']);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Penanganan kesalahan jika registrasi gagal
    }

    setState(() {
      isLoading = false;
    });
  }
}
