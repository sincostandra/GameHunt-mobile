import 'package:flutter/material.dart';
import 'package:gamehunt/models/game.dart';
import 'package:gamehunt/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:gamehunt/search/screens/gameentry_form.dart';
import 'package:gamehunt/search/screens/gameentry_edit_form.dart';
import 'package:gamehunt/widgets/navbar.dart';
import 'package:gamehunt/display/screens/game_details.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GameEntryPage extends StatefulWidget {
  const GameEntryPage({super.key});

  @override
  State<GameEntryPage> createState() => _GameEntryPageState();
}

class _GameEntryPageState extends State<GameEntryPage> {
  List<Game> _allGames = [];
  List<Game> _filteredGames = [];
  String _searchQuery = '';
  String _sortBy = '';
  bool _isAdmin = false; // Tambahkan state untuk menyimpan role user

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
    _fetchAndStoreGames();
  }

  Future<void> _fetchUserRole() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get('http://127.0.0.1:8000/user-role/');
      setState(() {
        _isAdmin = response['role'] == 'admin'; // Cek role user
      });
    } catch (e) {
      print('Error fetching user role: $e');
    }
  }

  Future<void> _fetchAndStoreGames() async {
    final request = context.read<CookieRequest>();
    try {
      // Ambil data dari API
      final response = await request.get('http://127.0.0.1:8000/search/json/');

      // print("Raw response: $response");

      // Pastikan respons adalah List
      if (response is List) {
        List<Game> games = [];
        for (var data in response) {
          try {
            // Parsing manual setiap item
            String model = "game.model"; // Default model
            String pk = data["id"] ?? ""; // Ambil ID
            Map<String, dynamic> fieldsData = data["fields"] ?? {};

            Fields fields = Fields(
              name: fieldsData["name"] ?? "Unknown",
              year: fieldsData["year"] ?? 0,
              description: fieldsData["description"] ?? "No description",
              developer: fieldsData["developer"] ?? "Unknown developer",
              genre: fieldsData["genre"] ?? "Unknown genre",
              ratings: (fieldsData["ratings"] as num?)?.toDouble() ?? 0.0,
              harga: fieldsData["harga"] ?? 0,
              toko1: fieldsData["toko1"] ?? "Unknown toko",
              alamat1: fieldsData["alamat1"] ?? "Unknown alamat",
              toko2:
                  fieldsData["toko2"] == null || fieldsData["toko2"] == "null"
                      ? null
                      : fieldsData["toko2"],
              alamat2: fieldsData["alamat2"] == null ||
                      fieldsData["alamat2"] == "null"
                  ? null
                  : fieldsData["alamat2"],
              toko3:
                  fieldsData["toko3"] == null || fieldsData["toko3"] == "null"
                      ? null
                      : fieldsData["toko3"],
              alamat3: fieldsData["alamat3"] == null ||
                      fieldsData["alamat3"] == "null"
                  ? null
                  : fieldsData["alamat3"],
            );

            // Buat objek Game
            games.add(Game(model: model, pk: pk, fields: fields));
          } catch (e) {
            print("Error parsing item: $data, Error: $e");
          }
        }

        setState(() {
          _allGames = games;
          _filteredGames = List.from(games);
        });
      } else {
        throw Exception("Invalid response format: Expected a List");
      }
    } catch (e) {
      print('Error fetching game data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch game data: $e")),
      );
    }
  }

  void _searchGames(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredGames = _allGames.where((game) {
        final name = game.fields.name.toLowerCase();
        final year = game.fields.year.toString();
        final description = game.fields.description.toLowerCase();
        final developer = game.fields.developer.toLowerCase();
        final genre = game.fields.genre.toLowerCase();
        final ratings = game.fields.ratings.toString();
        final harga = game.fields.harga.toString();

        return name.contains(_searchQuery) ||
            year.contains(_searchQuery) ||
            description.contains(_searchQuery) ||
            developer.contains(_searchQuery) ||
            genre.contains(_searchQuery) ||
            ratings.contains(_searchQuery) ||
            harga.contains(_searchQuery);
      }).toList();
      _sortGames();
    });
  }

  void _sortGames() {
    if (_sortBy == 'rating') {
      _filteredGames
          .sort((a, b) => b.fields.ratings.compareTo(a.fields.ratings));
    } else if (_sortBy == 'name') {
      _filteredGames.sort((a, b) => a.fields.name.compareTo(b.fields.name));
    } else if (_sortBy == 'developer') {
      _filteredGames
          .sort((a, b) => a.fields.developer.compareTo(b.fields.developer));
    } else if (_sortBy == 'price') {
      _filteredGames.sort((a, b) => a.fields.harga.compareTo(b.fields.harga));
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFFF44336);
    final request = context
        .watch<CookieRequest>(); // Pastikan request didefinisikan di sini

    return Scaffold(
      appBar: Navbar(primaryColor: primaryColor),
      drawer: const LeftDrawer(),
      backgroundColor: Colors.grey[100],
      body: _allGames.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: Text(
                          'GameHunt',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search games...',
                              prefixIcon: const Icon(Icons.search),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 12.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onChanged: _searchGames,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: DropdownButtonFormField<String>(
                            value: _sortBy.isNotEmpty ? _sortBy : null,
                            hint: const Text('Sort By'),
                            items: const [
                              DropdownMenuItem(
                                value: 'rating',
                                child: Text('Rating'),
                              ),
                              DropdownMenuItem(
                                value: 'name',
                                child: Text('Name'),
                              ),
                              DropdownMenuItem(
                                value: 'developer',
                                child: Text('Developer'),
                              ),
                              DropdownMenuItem(
                                value: 'price',
                                child: Text('Price'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _sortBy = value ?? '';
                                _sortGames();
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                        if (_isAdmin) ...[
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GameEntryFormPage()),
                              ).then((_) {
                                // Refresh setelah add
                                _fetchAndStoreGames();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 12.0),
                            ),
                            child: const Text('+',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        ]
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Ubah dari map((gameData) {...}) ke asMap().entries.map((entry){...}) agar dapat index
                    Column(
                      children: _filteredGames.asMap().entries.map((entry) {
                        final index = entry.key;
                        final gameData = entry.value;
                        final game = gameData.fields;
                        double ratingValue = game.ratings;
                        final ratingText = ratingValue.toStringAsFixed(1);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Bagian kiri: detail game
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => GameDetailPage(game: gameData, isAdmin: _isAdmin),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        game.name,
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      game.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black87),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Developer: ${game.developer}',
                                      style: const TextStyle(
                                          color: Colors.black54),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Price: Rp ${game.harga}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 16.0),
                              // Bagian kanan: tombol Edit/Delete + rating circle + genre
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(width: 16.0),
                                      // Garis vertikal
                                      Container(
                                        width: 1,
                                        height: 40,
                                        color: Colors.grey[300],
                                      ),
                                      const SizedBox(width: 16.0),
                                      // Rating Circle
                                      CircularPercentIndicator(
                                        radius: 25.0,
                                        lineWidth: 5.0,
                                        percent:
                                            (ratingValue / 5).clamp(0.0, 1.0),
                                        center: Text(
                                          ratingText,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        progressColor: primaryColor,
                                        backgroundColor: Colors.grey[300]!,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4.0),
                                  // Genre
                                  Text(
                                    'Genre: ${game.genre.length > 10 ? '${game.genre.substring(0, 10)}...' : game.genre}',
                                    style:
                                        const TextStyle(color: Colors.black54),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (_isAdmin) ...[
                                          // Tombol Edit
                                          OutlinedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      GameEntryEditFormPage(
                                                    gameId: gameData
                                                        .pk, // UUID String
                                                    initialData: {
                                                      'name': game.name,
                                                      'year': game.year,
                                                      'description':
                                                          game.description,
                                                      'developer':
                                                          game.developer,
                                                      'genre': game.genre,
                                                      'ratings': game.ratings,
                                                      'harga': game.harga,
                                                      'toko1': game.toko1,
                                                      'alamat1': game.alamat1,
                                                      'toko2': game.toko2,
                                                      'alamat2': game.alamat2,
                                                      'toko3': game.toko3,
                                                      'alamat3': game.alamat3,
                                                    },
                                                  ),
                                                ),
                                              ).then((_) {
                                                // Refresh setelah edit
                                                _fetchAndStoreGames();
                                              });
                                            },
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                  color: primaryColor),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0)),
                                            ),
                                            child: Text('Edit',
                                                style: TextStyle(
                                                    color: primaryColor)),
                                          ),
                                          const SizedBox(width: 8.0),
                                          // Tombol Delete
                                          ElevatedButton(
                                            onPressed: () async {
                                              // Karena tidak ada deleteJson, kita gunakan http.delete
                                              final url = Uri.parse(
                                                  "http://127.0.0.1:8000/delete-game-flutter/${gameData.pk}/");
                                              final httpResponse =
                                                  await http.delete(url);
                                              if (httpResponse.statusCode ==
                                                  200) {
                                                final responseData = jsonDecode(
                                                    httpResponse.body);
                                                if (responseData['status'] ==
                                                    'success') {
                                                  setState(() {
                                                    _filteredGames
                                                        .removeAt(index);
                                                  });
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          "Game successfully deleted!"),
                                                    ),
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          "Error deleting game."),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        "Error deleting game."),
                                                  ),
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: primaryColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0)),
                                            ),
                                            child: const Text('Delete',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        ],
                                      ])
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
