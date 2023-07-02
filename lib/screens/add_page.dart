import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
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
          onPressed: saveData,
          child: const Text('Save'),
        )
      ]),
    );
  }

  Future<void> saveData() async {
    //get datra from from
    final title = titleController.text;
    final deskripsi = deskripsiController.text;
    final body = {"title": title, "deskripsi": deskripsi};
    // submit data to the server
    final url = 'http://192.168.110.79:8080/api/notes';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
    );
    // succeed or fail message status
    if (response.statusCode == 200) {
      titleController.text = '';
      deskripsiController.text = '';
      showSuccessMessage('Creation Success ');
    } else {
      showErrorMessage('Creation Fail');
    }
  }

  //api reaction

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
