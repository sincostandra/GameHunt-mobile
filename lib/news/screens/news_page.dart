import 'package:flutter/material.dart';
import 'package:gamehunt/news/models/news_model.dart';
import 'package:gamehunt/news/screens/news_form.dart';
import 'package:gamehunt/news/widgets/news_box.dart';
import 'package:gamehunt/widgets/navbar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart'; 
import 'package:provider/provider.dart';
import 'package:gamehunt/news/screens/news_detail.dart'; 
import 'package:gamehunt/widgets/left_drawer.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  bool _isAdmin = false;
  Future<List<News>> fetchNews(CookieRequest request) async {
    // Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    final response = await request.get('http://127.0.0.1:8000/news/json/');
    
    // Melakukan decode response menjadi bentuk json
    var data = response;
    
    // Melakukan konversi data json menjadi object NewsEntry
    List<News> listNews = [];
    for (var d in data) {
      if (d != null) {
        listNews.add(News.fromJson(d));
      }
    }
    return listNews;
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

    @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final primaryColor = const Color(0xFFF44336);

    return Scaffold(
      appBar: Navbar(primaryColor: primaryColor),
      drawer: const LeftDrawer(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_isAdmin) ...[
            FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const NewsFormPage()),
              );
            },
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              // padding: const EdgeInsets.symmetric(
              //     horizontal: 16.0, vertical: 12.0),
            child: const Text('+',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ]
        ],
      ),
      body: FutureBuilder(
        future: fetchNews(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    'Slow news day...',
                    style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return ListView.builder(
  itemCount: snapshot.data!.length,
  itemBuilder: (_, index) {
    final news = snapshot.data![index];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetail(news: news, isAdmin: _isAdmin),
          ),
        );
      },
      child: NewsBox(news: news)
    );
  },
);
            }
          }
        },
      ),
    );
  }
}