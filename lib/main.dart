import 'package:fa_1213022/screens/homepage.dart';
import 'package:fa_1213022/screens/todo_list.dart';
import 'package:fa_1213022/screens/log_reg.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: MyHomePage(),
      routes: {
        '/login': (context) => MyHomePage(),
        '/logout': (context) => LogoutPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/todo') {
          return MaterialPageRoute(builder: (context) => TodoListPage());
        }
        return null;
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => UnknownPage());
      },
    );
  }
}

class UnknownPage extends StatelessWidget {
  const UnknownPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unknown Page'),
      ),
      body: Center(
        child: Text('404 - Page Not Found'),
      ),
    );
  }
}
