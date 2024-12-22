# **GameHunt Mobile**

## **Daftar Anggota Kelompok**
- Oscar Ryanda Putra - 2306217765  
- Aliefa Alsyafiandra Setiawati Mahdi - 2306221056  
- Priscilla Natanael Surjanto - 2306152153  
- Vincent Davis Leonard Tjoeng - 2306275014  
- Utandra Nur Ahmad Jais - 2306152443  
- Rahma Dwi Maghfira - 2306245794  

## Progress Tracker
https://docs.google.com/spreadsheets/d/15FL62ygBmZk5IhgyG3UJd2Lbju4LETrNI1l4HdX3UYA/edit?usp=sharing

---

## **Deskripsi Aplikasi**
GameHunt Mobile adalah aplikasi mobile yang dikembangkan berdasarkan proyek GameHunt versi web. Aplikasi ini bertujuan untuk memberikan pengalaman yang lebih responsif dan praktis dalam mencari, membeli, dan memberikan ulasan game PS4 melalui perangkat mobile.

Fitur utama:
- **Pencarian game berdasarkan nama.**
- **Memberikan ulasan untuk game dari toko terdekat.**
- **Membuat dan mengelola wishlist game favorit.**
- **Mengakses berita terbaru dan promosi terkait game PS4.**

Aplikasi ini mengintegrasikan layanan web Django dari proyek tengah semester untuk memberikan data dinamis terkait game, ulasan, wishlist, dan berita.

---

## **Daftar Modul dan Pembagian Kerja**

#### **Review** (Utandra Nur Ahmad Jais)

- Pengguna memiliki kemampuan untuk menambahkan ulasan terkait kaset game dari berbagai toko terdekat. Setiap review bisa memberikan informasi yang bermanfaat bagi pengguna lain.
- Ulasan diurutkan berdasarkan jumlah vote (like and dislike), sehingga memudahkan pengguna untuk melihat review dengan relevansi dan kualitas review tertinggi
- Admin memiliki kendali penuh atas review, termasuk kemampuan untuk menambah dan menghapus review sesuai kebutuhan.

#### **User Authentication** (Oscar Ryanda Putra)

- Pengguna dapat membuat akun dan login untuk mengakses fitur-fitur eksklusif GameHunt.
- Setelah mendaftar, pengguna dapat membuat dan mengedit profil mereka, yang berfungsi sebagai pusat informasi pribadi dan aktivitas pengguna di platform.

#### **Pencarian Game** (Vincent Davis Leonard Tjoeng)

- Pengguna dapat dengan mudah mencari kaset game berdasarkan nama game yang diinginkan.
- Admin memiliki hak untuk menambahkan game baru ke dalam database, memastikan ketersediaan game PS4 terbaru dan klasik langka selalu diperbarui.

#### **Display Game** (Priscilla Natanael Surjanto)

- Pengguna dapat melihat daftar toko yang menjual game yang mereka cari, lengkap dengan informasi terkait lokasi dan harga.
- Game yang diminati pengguna dapat ditambahkan ke wishlist untuk disimpan dan dikelola.

#### **Wishlist** (Rahma Dwi Maghfira)

- Pengguna dapat menambahkan game favorit mereka ke dalam wishlist untuk memudahkan pelacakan dan akses cepat di masa mendatang.
- Wishlist juga memungkinkan pengguna untuk menghapus game yang tidak lagi mereka inginkan dari daftar.

#### **Game News** (Aliefa Alsyafiandra Setiawati Mahdi)

- Admin memiliki kemampuan untuk mengelola berita terbaru mengenai dunia game PS4, termasuk menambahkan, mengedit, dan menghapus berita.
- Pengguna dapat dengan mudah mengakses berbagai informasi terbaru, promosi, dan diskon menarik di dunia game melalui fitur berita ini.
---

## **Peran atau Aktor Pengguna**

### **1. Admin**
Admin memiliki akses penuh ke semua fitur aplikasi, termasuk:
- Mengelola game dalam database (menambah, mengedit, dan menghapus).
- Mengelola ulasan pengguna.
- Mengelola berita terbaru terkait game PS4.
- Memantau aktivitas pengguna di platform.

### **2. Registered User**
Pengguna terdaftar memiliki akses ke fitur berikut:
- Membuat ulasan dan melihat ulasan pengguna lain.
- Mencari game berdasarkan nama.
- Membuat dan mengelola wishlist.
- Membaca berita terbaru dan promosi terkait game PS4.

---

## **Alur Integrasi dengan Web Service**

## Authentication
- Modul autentikasi akan menggunakan backend dari proyek tengah semester dengan framework Django. Pengguna dapat melakukan registrasi dan login melalui aplikasi mobile.
- Backend akan memberikan token autentikasi (misalnya, JWT atau token session) yang digunakan untuk mengakses API.
- Modifikasi dilakukan pada `views.py` dan `urls.py` di aplikasi `/authentication` untuk mendukung operasi berikut:
  - **Registrasi**: Membuat akun baru dengan validasi data pengguna.
  - **Login**: Memvalidasi kredensial pengguna dan menghasilkan token.
  - **Logout**: Menghapus token pengguna.
- Token ini digunakan untuk mengakses endpoint API lainnya.

---

## Pencarian Game
### **Backend Django**  
- **Modul Pencarian** menggunakan Django sebagai backend.  
- **Endpoint API** yang digunakan:
  - **`/search/json/`**: Menyediakan daftar game dalam format JSON.  
  - **`/user-role/`**: Mengecek role pengguna (**admin** atau **user**).  
  - **`/create-game-flutter/`**: Menambahkan game baru (hanya untuk admin).  
  - **`/edit-game-flutter/<game_id>/`**: Mengedit data game berdasarkan `id` (hanya untuk admin).  
  - **`/delete-game-flutter/<game_id>/`**: Menghapus game berdasarkan `id` (hanya untuk admin).  
- **Struktur Respons JSON**:
  - **`name`**, **`year`**, **`description`**, **`developer`**, **`genre`**, **`ratings`**, **`harga`**, serta informasi toko (**toko1–toko3** dan **alamat1–alamat3**).

### **Modifikasi Views dan Endpoint**  
- **`views.py`**:
  - Menambahkan validasi **role admin** untuk fitur **Tambah, Edit**, dan **Hapus Game**.  
  - Menggunakan **CSRF exempt** untuk menerima request dari Flutter.  
  - **`get_user_role`** digunakan untuk mengecek role pengguna (admin atau user).  
- **`urls.py`**:
  - URL ditambahkan untuk mendukung **CRUD game** dan **validasi role pengguna**

---

## Display Game
- Modul ini menggunakan backend untuk menyediakan daftar toko yang menjual game yang dicari pengguna.
- Backend akan menyediakan respons JSON yang berisi:
  - Nama toko.
  - Lokasi.
- Modifikasi dilakukan pada `views.py` dan `urls.py` di aplikasi `/store_display` untuk:
  - Mengintegrasikan fitur pencarian toko.
  - Memfilter hasil berdasarkan lokasi pengguna jika diperlukan.
- Data JSON ditampilkan di aplikasi dengan antarmuka yang interaktif.

---

## Wishlist
- Modul wishlist menggunakan backend untuk menyimpan dan mengelola daftar wishlist pengguna.
- Modifikasi dilakukan pada `views.py` dan `urls.py` di aplikasi `/wishlist` untuk:
  - Menyediakan endpoint API untuk menambah, menghapus, dan melihat wishlist.
  - Mengadaptasi respons JSON untuk kebutuhan frontend Flutter.
- Data wishlist disinkronkan dengan backend melalui API secara asinkron.

---

## Review
- Modul ulasan memungkinkan pengguna:
  - Menambah ulasan baru.
  - Melihat ulasan pengguna lain.
- Backend akan mengelola data ulasan, termasuk validasi dan penyimpanan.
- Modifikasi dilakukan pada `views.py` dan `urls.py` di aplikasi `/review` untuk:
  - Menyediakan endpoint API untuk menambah ulasan.
  - Memfilter dan mengurutkan ulasan berdasarkan kriteria tertentu.
- Data ulasan disinkronkan menggunakan paket HTTP di Flutter.

---

## Game News
- Modul ini menampilkan berita terbaru dan promosi terkait game PS4.
- Backend akan mengelola berita, termasuk:
  - Membuat berita baru.
  - Mengedit berita melalui fitur admin.
- Modifikasi dilakukan pada `views.py` dan `urls.py` di aplikasi `/news` untuk menyediakan API.
- Data berita disajikan dalam format JSON dan ditampilkan menggunakan antarmuka Flutter.

---

## Pengelolaan CORS pada Backend Django
- Untuk memungkinkan aplikasi Flutter mengakses backend Django:
  - Tambahkan middleware `django-cors-headers` di `settings.py`.
  - Atur izin CORS untuk menerima permintaan dari domain frontend Flutter.

---

## Implementasi pada Flutter Frontend
- Aplikasi Flutter akan mengakses API yang disediakan oleh backend Django untuk melakukan operasi berikut:
  - **Autentikasi pengguna.**
  - **Pencarian dan pengelolaan game.**
  - **Menampilkan daftar toko.**
  - **Membuat dan mengelola wishlist.**
  - **Membuat dan melihat ulasan.**
  - **Menampilkan berita terbaru.**
- Semua operasi dilakukan dengan permintaan asinkron menggunakan **package HTTP** di Flutter.
- Data JSON yang diterima dapat di-cache secara lokal untuk meningkatkan performa aplikasi.

---
