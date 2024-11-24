# **GameHunt Mobile**

## **Daftar Anggota Kelompok**
- Oscar Ryanda Putra - 2306217765  
- Aliefa Alsyafiandra Setiawati Mahdi - 2306221056  
- Priscilla Natanael Surjanto - 2306152153  
- Vincent Davis Leonard Tjoeng - 2306275014  
- Utandra Nur Ahmad Jais - 2306152443  
- Rahma Dwi Maghfira - 2306245794  

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

### **1. Review**
- **Deskripsi:** Memungkinkan pengguna untuk menambah ulasan, mengurutkan berdasarkan jumlah bintang, dan melihat ulasan pengguna lain.  
- **Pengembang:** Priscilla Natanael Surjanto  

### **2. User Authentication**
- **Deskripsi:** Mengelola registrasi, login, dan profil pengguna.  
- **Pengembang:** Aliefa Alsyafiandra Setiawati Mahdi  

### **3. Pencarian Game**
- **Deskripsi:** Menyediakan fitur pencarian game berdasarkan nama. Admin dapat menambahkan game baru ke database.  
- **Pengembang:** Vincent Davis Leonard Tjoeng  

### **4. Display Game**
- **Deskripsi:** Menampilkan daftar toko yang menjual game yang dicari pengguna, lengkap dengan informasi lokasi dan harga.  
- **Pengembang:** Oscar Ryanda Putra  

### **5. Wishlist**
- **Deskripsi:** Memungkinkan pengguna menambah game ke wishlist dan mengelolanya.  
- **Pengembang:** Rahma Dwi Maghfira  

### **6. Game News**
- **Deskripsi:** Menampilkan berita terbaru dan promosi terkait dunia game PS4. Admin dapat mengelola berita tersebut.  
- **Pengembang:** Utandra Nur Ahmad Jais  

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
# Alur Pengintegrasian dengan Web Service

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
- Modul pencarian akan menggunakan backend Django. Pengguna dapat mencari game berdasarkan nama melalui endpoint API.
- Backend akan menyediakan data game berupa respons JSON berisi informasi seperti nama, genre, dan deskripsi game.
- Modifikasi dilakukan pada `views.py` dan `urls.py` di aplikasi `/search` untuk:
  - Mendukung pencarian dengan parameter nama.
  - Menambahkan game baru ke database melalui fitur admin.
- Data JSON yang diterima diolah dan ditampilkan menggunakan widget Flutter.

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
