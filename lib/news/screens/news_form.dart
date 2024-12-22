import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gamehunt/news/screens/news_page.dart';
import 'package:gamehunt/widgets/navbar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:gamehunt/widgets/left_drawer.dart';

class NewsFormPage extends StatefulWidget {
  const NewsFormPage({super.key});

  @override
  State<NewsFormPage> createState() => _NewsFormPageState();
}

class _NewsFormPageState extends State<NewsFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _article = "";
  String _author = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    const primaryColor = Color(0xFFF44336);

    return Scaffold(
      appBar: Navbar(primaryColor: primaryColor),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "News title",
                  labelText: "News title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _title = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "News title cannot be empty!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Article",
                  labelText: "Article",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _article = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "News must have an article!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Author",
                  labelText: "Author",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _author = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "News must have an author!";
                  }
                  return null;
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.primary),
                  ),
                  //                     onPressed: () {
                  //   if (_formKey.currentState!.validate()) {
                  //     showDialog(
                  //       context: context,
                  //       builder: (context) {
                  //         return AlertDialog(
                  //           title: const Text('News berhasil tersimpan'),
                  //           content: SingleChildScrollView(
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Text('title: $_title'),
                  //                 Text('author: $_author'),
                  //               ],
                  //             ),
                  //           ),
                  //           actions: [
                  //             TextButton(
                  //               child: const Text('OK'),
                  //               onPressed: () {
                  //                 Navigator.pop(context);
                  //                 _formKey.currentState!.reset();
                  //               },
                  //             ),
                  //           ],
                  //         );
                  //       },
                  //     );
                  //   }
                  // },
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Kirim ke Django dan tunggu respons
                      // Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                      final response = await request.post(
                        "https://utandra-nur-gamehunts.pbp.cs.ui.ac.id/news/create-flutter/",
                        jsonEncode(<String, String>{
                          'title': _title,
                          'author': _author,
                          'article': _article,
                          'update_date': DateTime.now().toIso8601String(),
                          // Sesuaikan field data sesuai dengan aplikasimu
                        }),
                      );
                      if (context.mounted) {
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("News baru berhasil disimpan!"),
                          ));
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NewsPage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content:
                                Text("Terdapat kesalahan, silakan coba lagi."),
                          ));
                        }
                      }
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
        )),
      ),
    );
  }
}
