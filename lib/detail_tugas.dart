// detail_tugas.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myapp/apiconfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DetailTugasScreen extends StatefulWidget {
  final int task_id;

  DetailTugasScreen({required this.task_id});

  @override
  State<DetailTugasScreen> createState() => _DetailTugasScreenState();
}

class _DetailTugasScreenState extends State<DetailTugasScreen> {
  Map<String, dynamic> task = {};
  bool isLooading = true;
  Future<void> _fetchDetailTask() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia.');
      }

      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http.get(
        Uri.parse('$URL/api/task/show/${widget.task_id}'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          setState(() {
            task = responseData['data'];
            isLooading = false;
          });
        } else {
          throw Exception('Gagal memuat data: ${responseData['message']}');
        }
      } else {
        throw Exception('Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLooading = false;
      });
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDetailTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Tugas')),
      body: isLooading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : task.isNotEmpty
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 12),
                          child: Center(
                            child: Text(
                              task['title'] ?? 'Tidak menemukan judul',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        task['description'] ?? 'Tidak ada deskripsi',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                )
              : Center(
                  child: Text('Data tidak ditemukan'),
                ),
    );
  }
}
