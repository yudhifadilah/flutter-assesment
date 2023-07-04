import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddTodoPage extends StatefulWidget {
  final Map<String, dynamic>? todo;
  const AddTodoPage({
    Key? key,
    this.todo,
  }) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  late TextEditingController titleController;
  late TextEditingController deskripsiController;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    titleController = TextEditingController();
    deskripsiController = TextEditingController();
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final deskripsi = todo['deskripsi'];
      titleController.text = title;
      deskripsiController.text = deskripsi;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Todo' : 'Add Todo',
        ),
      ),
      body: ListView(padding: EdgeInsets.all(20), children: [
        TextField(
          controller: titleController,
          decoration: const InputDecoration(hintText: 'Title'),
        ),
        TextField(
          controller: deskripsiController,
          decoration: const InputDecoration(hintText: 'Deskripsi'),
          keyboardType: TextInputType.multiline,
          minLines: 5,
          maxLines: 8,
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: isEdit ? updateData : saveData,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              isEdit ? 'Update' : 'Save',
            ),
          ),
        )
      ]),
    );
  }

  Future<void> updateData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Jika token tidak null, kirim permintaan dengan header Authorization
    if (token != null) {
      // Dapatkan data dari form
      final todo = widget.todo;
      if (todo == null) {
        print('Data tidak bisa di Update');
        return;
      }
      final id = todo['id'];
      final title = titleController.text;
      final deskripsi = deskripsiController.text;
      final body = {"title": title, "deskripsi": deskripsi};

      // Kirim permintaan ke server dengan header Authorization
      final url = 'http://192.168.1.4:8080/api/notes/$id';
      final uri = Uri.parse(url);
      final response = await http.put(
        uri,
        headers: {'Authorization': 'Bearer $token'},
        body: jsonEncode(body),
      );
      // Cek status kode respon
      if (response.statusCode == 200) {
        // titleController.text = '';
        //deskripsiController.text = '';
        showSuccessMessage('Update data Success');
      } else {
        showErrorMessage('Update data Fail');
      }
    } else {
      // Token tidak tersedia, lakukan penanganan sesuai kebutuhan
      // Misalnya, tampilkan pesan kesalahan atau arahkan pengguna untuk login
    }
  }

  Future<void> saveData() async {
    // Mengambil token dari shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Jika token tidak null, kirim permintaan dengan header Authorization
    if (token != null) {
      // Dapatkan data dari form
      final title = titleController.text;
      final deskripsi = deskripsiController.text;
      final body = {"title": title, "deskripsi": deskripsi};

      // Kirim permintaan ke server dengan header Authorization
      final url = 'http://192.168.1.4:8080/api/notes';
      final uri = Uri.parse(url);
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $token'},
        body: jsonEncode(body),
      );

      // Cek status kode respon
      if (response.statusCode == 200) {
        titleController.text = '';
        deskripsiController.text = '';
        showSuccessMessage('Creation Success');
      } else {
        showErrorMessage('Creation Fail');
      }
    } else {
      // Token tidak tersedia, lakukan penanganan sesuai kebutuhan
      // Misalnya, tampilkan pesan kesalahan atau arahkan pengguna untuk login
    }
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
