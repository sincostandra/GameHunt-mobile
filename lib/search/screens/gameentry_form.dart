import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:gamehunt/widgets/navbar.dart';
import 'dart:convert';

class GameEntryFormPage extends StatefulWidget {
  const GameEntryFormPage({super.key});

  @override
  State<GameEntryFormPage> createState() => _GameEntryFormPageState();
}

class _GameEntryFormPageState extends State<GameEntryFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  int? _year;
  String _description = "";
  String _developer = "";
  String _genre = "";
  double _ratings = 0.0;
  int _harga = 0;
  String _toko1 = "";
  String _alamat1 = "";
  String? _toko2;
  String? _alamat2;
  String? _toko3;
  String? _alamat3;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFF44336);
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: Navbar(primaryColor: primaryColor),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Field Input untuk Name
              _buildTextField(
                label: "Game Name",
                onChanged: (value) => setState(() => _name = value!),
                validator: (value) =>
                    value!.isEmpty ? "Game Name cannot be empty!" : null,
              ),
              // Field Input untuk Year
              _buildTextField(
                label: "Year",
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    setState(() => _year = int.tryParse(value!)),
              ),
              // Field Input untuk Description
              _buildTextField(
                label: "Description",
                onChanged: (value) => setState(() => _description = value!),
                validator: (value) =>
                    value!.isEmpty ? "Description cannot be empty!" : null,
              ),
              // Field Input untuk Developer
              _buildTextField(
                label: "Developer",
                onChanged: (value) => setState(() => _developer = value!),
                validator: (value) =>
                    value!.isEmpty ? "Developer cannot be empty!" : null,
              ),
              // Field Input untuk Genre
              _buildTextField(
                label: "Genre",
                onChanged: (value) => setState(() => _genre = value!),
                validator: (value) =>
                    value!.isEmpty ? "Genre cannot be empty!" : null,
              ),
              // Field Input untuk Ratings
              _buildTextField(
                label: "Ratings (0-5)",
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    setState(() => _ratings = double.tryParse(value!) ?? 0.0),
                validator: (value) {
                  if (value!.isEmpty) return "Ratings cannot be empty!";
                  final rating = double.tryParse(value);
                  if (rating == null || rating < 0 || rating > 5) {
                    return "Ratings must be between 0 and 5!";
                  }
                  return null;
                },
              ),
              // Field Input untuk Harga
              _buildTextField(
                label: "Price",
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    setState(() => _harga = int.tryParse(value!) ?? 0),
                validator: (value) =>
                    value!.isEmpty ? "Price cannot be empty!" : null,
              ),
              // Field Input untuk Toko1 dan Alamat1
              _buildTextField(
                label: "Store 1",
                onChanged: (value) => setState(() => _toko1 = value!),
                validator: (value) =>
                    value!.isEmpty ? "Store 1 cannot be empty!" : null,
              ),
              _buildTextField(
                label: "Address 1",
                onChanged: (value) => setState(() => _alamat1 = value!),
                validator: (value) =>
                    value!.isEmpty ? "Address 1 cannot be empty!" : null,
              ),
              // Field Input untuk Toko2 dan Alamat2
              _buildTextField(
                label: "Store 2 (Optional)",
                onChanged: (value) => setState(() => _toko2 = value),
              ),
              _buildTextField(
                label: "Address 2 (Optional)",
                onChanged: (value) => setState(() => _alamat2 = value),
              ),
              // Field Input untuk Toko3 dan Alamat3
              _buildTextField(
                label: "Store 3 (Optional)",
                onChanged: (value) => setState(() => _toko3 = value),
              ),
              _buildTextField(
                label: "Address 3 (Optional)",
                onChanged: (value) => setState(() => _alamat3 = value),
              ),
              // Tombol Save
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final response = await request.postJson(
                          "https://utandra-nur-gamehunts.pbp.cs.ui.ac.id/create-game-flutter/",
                          jsonEncode(<String, dynamic>{
                            'name': _name,
                            'year': _year,
                            'description': _description,
                            'developer': _developer,
                            'genre': _genre,
                            'ratings': _ratings,
                            'harga': _harga,
                            'toko1': _toko1,
                            'alamat1': _alamat1,
                            'toko2': _toko2,
                            'alamat2': _alamat2,
                            'toko3': _toko3,
                            'alamat3': _alamat3,
                          }),
                        );

                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Game successfully saved!"),
                            ),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Error saving game."),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text(
                      "Save",
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
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
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
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
