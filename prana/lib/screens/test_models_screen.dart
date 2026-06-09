// lib/screens/test_models_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/api_keys.dart';

class TestModelsScreen extends StatelessWidget {
  const TestModelsScreen({super.key});

  Future<void> _listModels() async {
    final url = 'https://generativelanguage.googleapis.com/v1beta/models?key=${ApiKeys.gemini}';
    final response = await http.get(Uri.parse(url));
    print('Available Models: ${response.body}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Models')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _listModels();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Check console for available models')),
            );
          },
          child: const Text('List Available Models'),
        ),
      ),
    );
  }
}