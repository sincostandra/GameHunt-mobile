import 'package:flutter/material.dart';
import 'package:gamehunt/news/models/news_model.dart';
import 'package:gamehunt/news/screens/news_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:gamehunt/widgets/navbar.dart';
import 'package:provider/provider.dart';

class NewsEditFormPage extends StatefulWidget {
  final News initialData;

  const NewsEditFormPage({super.key, required this.initialData});

  @override
  State<NewsEditFormPage> createState() => _NewsEditFormPageState();
}

class _NewsEditFormPageState extends State<NewsEditFormPage> {
  final _formKey = GlobalKey<FormState>();

  late String _title;
  late String _article;
  late String _author;
  late String _newsId;

  @override
  void initState() {
    super.initState();
    _title = widget.initialData.fields.title;
    _article = widget.initialData.fields.article;
    _author = widget.initialData.fields.author;
    _newsId = widget.initialData.pk;
  }

  Future<void> _updateNews(CookieRequest request) async {
    final url = Uri.parse(
        "https://utandra-nur-gamehunts.pbp.cs.ui.ac.id/news/edit-flutter/$_newsId/");

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
      final response = await request.post(url.toString(), body);
      final responseData = response;
      if (responseData['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("News successfully updated!")),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NewsPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${responseData['message']}")),
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
    const primaryColor = Color(0xFFF44336);
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
                      backgroundColor: WidgetStateProperty.all(
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
