import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:gamehunt/widgets/navbar.dart';
import 'package:provider/provider.dart';

class GameEntryEditFormPage extends StatefulWidget {
  final String gameId;
  final Map<String, dynamic> initialData;

  const GameEntryEditFormPage(
      {super.key, required this.gameId, required this.initialData});

  @override
  State<GameEntryEditFormPage> createState() => _GameEntryEditFormPageState();
}

class _GameEntryEditFormPageState extends State<GameEntryEditFormPage> {
  final _formKey = GlobalKey<FormState>();

  late String _name;
  int? _year;
  late String _description;
  late String _developer;
  late String _genre;
  double _ratings = 0.0;
  int _harga = 0;
  late String _toko1;
  late String _alamat1;
  String? _toko2;
  String? _alamat2;
  String? _toko3;
  String? _alamat3;

  @override
  void initState() {
    super.initState();
    _name = widget.initialData['name'];
    _year = widget.initialData['year'];
    _description = widget.initialData['description'];
    _developer = widget.initialData['developer'];
    _genre = widget.initialData['genre'];
    _ratings = (widget.initialData['ratings'] as num?)?.toDouble() ?? 0.0;
    _harga = widget.initialData['harga'];
    _toko1 = widget.initialData['toko1'];
    _alamat1 = widget.initialData['alamat1'];
    _toko2 = widget.initialData['toko2'];
    _alamat2 = widget.initialData['alamat2'];
    _toko3 = widget.initialData['toko3'];
    _alamat3 = widget.initialData['alamat3'];
  }

  Future<void> _updateGame(CookieRequest request) async {
    final url = Uri.parse(
        "https://utandra-nur-gamehunts.pbp.cs.ui.ac.id/edit-game-flutter/${widget.gameId}/");

    try {
      // Headers: Sertakan cookie untuk otentikasi
      final headers = {
        'Content-Type': 'application/json',
        'Cookie': request.headers['cookie'] ?? '',
      };

      // Body data
      final body = jsonEncode(<String, dynamic>{
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
      });

      // HTTP PUT request
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Game successfully updated!")),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${responseData['message']}")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Error updating game: ${response.statusCode}")),
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
                label: "Game Name",
                initialValue: _name,
                onChanged: (value) => setState(() => _name = value!),
                validator: (value) =>
                    value!.isEmpty ? "Game Name cannot be empty!" : null,
              ),
              _buildTextField(
                label: "Year",
                keyboardType: TextInputType.number,
                initialValue: _year?.toString(),
                onChanged: (value) =>
                    setState(() => _year = int.tryParse(value!)),
              ),
              _buildTextField(
                label: "Description",
                initialValue: _description,
                onChanged: (value) => setState(() => _description = value!),
                validator: (value) =>
                    value!.isEmpty ? "Description cannot be empty!" : null,
              ),
              _buildTextField(
                label: "Developer",
                initialValue: _developer,
                onChanged: (value) => setState(() => _developer = value!),
                validator: (value) =>
                    value!.isEmpty ? "Developer cannot be empty!" : null,
              ),
              _buildTextField(
                label: "Genre",
                initialValue: _genre,
                onChanged: (value) => setState(() => _genre = value!),
                validator: (value) =>
                    value!.isEmpty ? "Genre cannot be empty!" : null,
              ),
              _buildTextField(
                label: "Ratings (0-5)",
                initialValue: _ratings.toString(),
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
              _buildTextField(
                label: "Price",
                initialValue: _harga.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    setState(() => _harga = int.tryParse(value!) ?? 0),
                validator: (value) =>
                    value!.isEmpty ? "Price cannot be empty!" : null,
              ),
              _buildTextField(
                label: "Store 1",
                initialValue: _toko1,
                onChanged: (value) => setState(() => _toko1 = value!),
                validator: (value) =>
                    value!.isEmpty ? "Store 1 cannot be empty!" : null,
              ),
              _buildTextField(
                label: "Address 1",
                initialValue: _alamat1,
                onChanged: (value) => setState(() => _alamat1 = value!),
                validator: (value) =>
                    value!.isEmpty ? "Address 1 cannot be empty!" : null,
              ),
              _buildTextField(
                label: "Store 2 (Optional)",
                initialValue: _toko2,
                onChanged: (value) => setState(() => _toko2 = value),
              ),
              _buildTextField(
                label: "Address 2 (Optional)",
                initialValue: _alamat2,
                onChanged: (value) => setState(() => _alamat2 = value),
              ),
              _buildTextField(
                label: "Store 3 (Optional)",
                initialValue: _toko3,
                onChanged: (value) => setState(() => _toko3 = value),
              ),
              _buildTextField(
                label: "Address 3 (Optional)",
                initialValue: _alamat3,
                onChanged: (value) => setState(() => _alamat3 = value),
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
                        _updateGame(request);
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
