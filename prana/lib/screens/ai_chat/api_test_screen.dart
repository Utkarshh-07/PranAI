// lib/screens/ai_chat/api_test_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/api_keys.dart';

class APITestScreen extends StatefulWidget {
  const APITestScreen({super.key});

  @override
  State<APITestScreen> createState() => _APITestScreenState();
}

class _APITestScreenState extends State<APITestScreen> {
  String _status = 'Not tested';
  bool _isLoading = false;
  String _response = '';

  Future<void> testOpenAIAPI() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing...';
      _response = '';
    });

    try {
      print('🔑 API Key length: ${ApiKeys.openAI.length}');
      print('🔑 API Key starts with: ${ApiKeys.openAI.substring(0, 7)}...');
      
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer ${ApiKeys.openAI}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'user', 'content': 'Say "API is working!" if you can read this'}
          ],
          'max_tokens': 10,
        }),
      );

      print('📥 Status code: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _status = '✅ API is WORKING!';
          _response = data['choices'][0]['message']['content'];
        });
      } else {
        setState(() {
          _status = '❌ API Error: ${response.statusCode}';
          _response = response.body;
        });
      }
    } catch (e) {
      setState(() {
        _status = '❌ Connection Error';
        _response = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenAI API Test'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'API Key Information:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Key length: ${ApiKeys.openAI.length} characters'),
                    Text('Starts with: ${ApiKeys.openAI.substring(0, 7)}...'),
                    if (ApiKeys.openAI.startsWith('sk-'))
                      const Text('✓ Format looks correct', style: TextStyle(color: Colors.green))
                    else
                      const Text('✗ Key should start with "sk-"', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : testOpenAIAPI,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isLoading 
                ? const CircularProgressIndicator() 
                : const Text('Test OpenAI Connection'),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status: $_status',
                      style: TextStyle(
                        fontSize: 16,
                        color: _status.contains('✅') ? Colors.green : 
                               _status.contains('❌') ? Colors.red : 
                               Colors.grey,
                      ),
                    ),
                    if (_response.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      const Text('Response:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SelectableText(_response),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}