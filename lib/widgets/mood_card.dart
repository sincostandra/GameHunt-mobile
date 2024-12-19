// import 'package:flutter/material.dart';
// import 'package:gamehunt/authentication/login.dart';
// import 'package:gamehunt/screens/moodentry_form.dart';
// import 'package:gamehunt/screens/list_moodentry.dart';
// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'package:provider/provider.dart';

// class ItemHomepage {
//     final String name;
//     final IconData icon;

//     ItemHomepage(this.name, this.icon);
// }

// class ItemCard extends StatelessWidget {
//   // Menampilkan kartu dengan ikon dan nama.

//   final ItemHomepage item; 
  
//   const ItemCard(this.item, {super.key}); 

// @override
// Widget build(BuildContext context) {
//     final request = context.watch<CookieRequest>();
//     return Material(
//       // Menentukan warna latar belakang dari tema aplikasi.
//       color: Theme.of(context).colorScheme.secondary,
//       // Membuat sudut kartu melengkung.
//       borderRadius: BorderRadius.circular(12),
      
//       child: InkWell(
//         // Aksi ketika kartu ditekan.
//         onTap: () async {
//           // Menampilkan pesan SnackBar saat kartu ditekan.
//           ScaffoldMessenger.of(context)
//             ..hideCurrentSnackBar()
//             ..showSnackBar(
//               SnackBar(content: Text("Kamu telah menekan tombol ${item.name}!"))
//             );
//           // Navigate ke route yang sesuai (tergantung jenis tombol)
//           if (item.name == "Tambah Mood") {
//             // Gunakan Navigator.push untuk melakukan navigasi ke MaterialPageRoute yang mencakup MoodEntryFormPage.
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const MoodEntryFormPage(),
//               ));
//           }
//           else if (item.name == "Lihat Mood") {
//             Navigator.push(context,
//                 MaterialPageRoute(
//                     builder: (context) => const MoodEntryPage()
//                 ),
//             );
//           }
//           // statement if sebelumnya
//           // tambahkan else if baru seperti di bawah ini
//           else if (item.name == "Logout") {
//               final response = await request.logout(
//                   // Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
//                   "http://http://127.0.0.1:8000/auth/logout/");
//               String message = response["message"];
//               if (context.mounted) {
//                   if (response['status']) {
//                       String uname = response["username"];
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content: Text("$message Sampai jumpa, $uname."),
//                       ));
//                       Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(builder: (context) => const LoginPage()),
//                       );
//                   } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                               content: Text(message),
//                           ),
//                       );
//                   }
//               }
//           }
//         },
//         // Container untuk menyimpan Icon dan Text
//         child: Container(
//           padding: const EdgeInsets.all(8),
//           child: Center(
//             child: Column(
//               // Menyusun ikon dan teks di tengah kartu.
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   item.icon,
//                   color: Colors.white,
//                   size: 30.0,
//                 ),
//                 const Padding(padding: EdgeInsets.all(3)),
//                 Text(
//                   item.name,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }  
// }