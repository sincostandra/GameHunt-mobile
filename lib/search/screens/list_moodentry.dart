import 'package:flutter/material.dart';
import 'package:gamehunt/models/game.dart';
import 'package:gamehunt/search/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class MoodEntryPage extends StatefulWidget {
  const MoodEntryPage({super.key});

  @override
  State<MoodEntryPage> createState() => _MoodEntryPageState();
}

class _MoodEntryPageState extends State<MoodEntryPage> {
  Future<List<Game>> fetchMood(CookieRequest request) async {
    try {
      // Ambil data dari endpoint API
      final response = await request.get('http://127.0.0.1:8000/search/json/');
      print('Response: $response'); // Log respons untuk debugging

      // Konversi data langsung ke List<Game>
      List<Game> listMood = [];
      for (var d in response) {
        listMood.add(Game.fromJson(d));
      }

      print('Parsed Games: $listMood'); // Log hasil parsing Game
      return listMood;
    } catch (e) {
      print('Error fetching mood data: $e'); // Log error untuk debugging
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Entry List'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<Game>>(
        future: fetchMood(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Tampilkan indikator loading saat sedang mem-fetch data
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Tampilkan pesan error jika terjadi kesalahan
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Tampilkan pesan jika tidak ada data
            return const Center(
              child: Text(
                'Belum ada data mood pada mental health tracker.',
                style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
              ),
            );
          }

          // Tampilkan ListView jika data tersedia
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final game = snapshot.data![index].fields;
              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 6.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.name,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text("Year: ${game.year}"),
                    const SizedBox(height: 10),
                    Text("Description: ${game.description}"),
                    const SizedBox(height: 10),
                    Text("Developer: ${game.developer}"),
                    const SizedBox(height: 10),
                    Text("Genre: ${game.genre}"),
                    const SizedBox(height: 10),
                    Text("Ratings: ${game.ratings}"),
                    const SizedBox(height: 10),
                    Text("Harga: ${game.harga}"),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
