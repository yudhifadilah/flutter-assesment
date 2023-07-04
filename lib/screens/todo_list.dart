import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fa_1213022/screens/add_page.dart';
import 'package:http/http.dart' as http;
import 'package:fa_1213022/controllers/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        actions: [
          IconButton(
            onPressed: logout,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              final iD = note['id'].toString();

              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(note['title'].toString()),
                subtitle: Text(note['deskripsi'].toString()),
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'edit') {
                      navigateToEditPage(note);
                    } else if (value == 'delete') {
                      deleteById(iD);
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ];
                  },
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: Text('Add Todo'),
      ),
    );
  }

  Future<void> navigateToEditPage(Map<String, dynamic> item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: item),
    );
    await Navigator.push(context, route).then((_) {
      setState(() {
        isLoading = true;
      });
      fetchTodo();
    });
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(),
    );
    await Navigator.push(context, route).then((_) {
      setState(() {
        isLoading = true;
      });
      fetchTodo();
    });
  }

  Future<void> deleteById(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final url = 'http://192.168.1.4:8080/api/dell/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final filtered =
          notes.where((element) => element['id'].toString() != id).toList();
      setState(() {
        notes = filtered;
      });
    } else {}
  }

  Future<void> fetchTodo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final url = 'http://192.168.1.4:8080/api/notes';
    final uri = Uri.parse(url);
    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final result = json['notes'] as List<dynamic>;
      setState(() {
        notes = result.cast<Map<String, dynamic>>();
      });
    } else {}

    setState(() {
      isLoading = false;
    });
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    Navigator.pushReplacementNamed(context, '/login');
  }
}
