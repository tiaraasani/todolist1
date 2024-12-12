// main.dart
import 'package:flutter/material.dart';
import 'package:myapp/DaftarTugasScreen.dart';
import 'package:myapp/login.dart';
import 'tambah_tugas.dart'; // Import halaman tambah tugas
import 'detail_tugas.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
    );
  }
}
