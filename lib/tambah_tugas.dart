// tambah_tugas.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myapp/DaftarTugasScreen.dart';
import 'package:myapp/apiconfig.dart';
import 'package:myapp/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TambahTugasScreen extends StatefulWidget {
  @override
  _TambahTugasScreenState createState() => _TambahTugasScreenState();
}

class _TambahTugasScreenState extends State<TambahTugasScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  bool isLoading = false;
  Future _postTask() async {
    final String title = _titleController.text;
    final String description = _descriptionController.text;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
        throw Exception('Token tidak tersedia.');
      }
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http.post(
        Uri.parse('$URL/api/task'),
        headers: headers,
        body: jsonEncode(
          {'title': title, 'description': description},
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DaftarTugasScreen(),
          ),
        );
      } else {
        final data = jsonDecode(response.body);
        _showErrorDialog(data['message'] ?? 'Gagal menambahkan tugas.');
        setState(() {
          isLoading = true;
          print('Error saat masukkan data');
        });
      }
    } catch (e) {
      setState(() {
        isLoading = true;
        print(e);
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Terjadi Kesalahan'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Tugas')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.network(
                'https://img.freepik.com/free-vector/hand-drawn-college-entrance-exam-illustration_23-2150349618.jpg?t=st=1729089167~exp=1729092767~hmac=a3bf56200e1728a9443e2886d343a72dc06215ee3f0ec54c649ecc6849979252&w=740',
                width: 200,
              ),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Nama Tugas',
                ),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Tugas',
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.green)),
                  onPressed: () {
                    _postTask();
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Simpan',
                          style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
