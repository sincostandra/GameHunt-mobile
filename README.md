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
1. **Autentikasi:** 
   - Aplikasi mobile memverifikasi akun pengguna dengan layanan Django melalui endpoint login dan registrasi.  
2. **Sinkronisasi Data:** 
   - Data game, ulasan, wishlist, dan berita diperoleh dari web service Django melalui pemanggilan asinkronus. Data dapat diambil dalam bentuk JSON.  
3. **Penyimpanan dan Tampilan Data:** 
   - Data JSON yang diterima diolah dan ditampilkan di aplikasi menggunakan widget Flutter.  
4. **Pengelolaan Data:** 
   - Data ulasan, wishlist, dan berita yang ditambahkan pengguna dikirimkan kembali ke server Django untuk disimpan. 

---
