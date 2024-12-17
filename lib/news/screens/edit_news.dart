import 'package:flutter/material.dart';
import 'package:gamehunt/news/models/news_model.dart';
import 'package:gamehunt/news/screens/news_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:gamehunt/widgets/navbar.dart';
import 'package:provider/provider.dart';

class NewsEditFormPage extends StatefulWidget {
  final String newsId;
  final News initialData;

  const NewsEditFormPage(
      {super.key, required this.newsId, required this.initialData});

  @override
  State<NewsEditFormPage> createState() => _NewsEditFormPageState();
}

class _NewsEditFormPageState extends State<NewsEditFormPage> {
  final _formKey = GlobalKey<FormState>();

  late String _title;
  late String _article;
  late String _author;

  @override
  void initState() {
    super.initState();
    _title = widget.initialData.fields.title;
    _article = widget.initialData.fields.article;
    _author = widget.initialData.fields.author;
  }

  Future<void> _updateNews(CookieRequest request) async {
    final url =
        Uri.parse("http://127.0.0.1:8000/news/edit-flutter/${widget.newsId}/");

    try {
      // Headers: Sertakan cookie untuk otentikasi
      final headers = {
        'Content-Type': 'application/json',
        'Cookie': request.headers['cookie'] ?? '',
      };

      // Body data
      final body = jsonEncode(<String, dynamic>{
        'title': _title,
        'article': _article,
        'author': _author,
        'updateDate': DateTime.now().toIso8601String(),
      });

      // HTTP PUT request
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("News successfully updated!")),
          );
          Navigator.push(
            context, 
            MaterialPageRoute(
            builder: (context) =>
                const NewsPage()),);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${responseData['message']}")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Error updating news: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final primaryColor = const Color(0xFFF44336);
    return Scaffold(
      appBar: Navbar(primaryColor: primaryColor),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                label: "News title",
                initialValue: _title,
                onChanged: (value) => setState(() => _title = value!),
                validator: (value) =>
                    value!.isEmpty ? "News title cannot be empty!" : null,
              ),
              _buildTextField(
                label: "News article",
                initialValue: _article,
                onChanged: (value) => setState(() => _article = value!),
                validator: (value) =>
                    value!.isEmpty ? "News article cannot be empty!" : null,
              ),
              _buildTextField(
                label: "News author",
                initialValue: _author,
                onChanged: (value) => setState(() => _author = value!),
                validator: (value) =>
                    value!.isEmpty ? "News author cannot be empty!" : null,
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _updateNews(request);
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required Function(String?) onChanged,
    String? initialValue,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        keyboardType: keyboardType,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
