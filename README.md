<div align="center">
  <h1>🏋️‍♂️ GYM Bandung Center</h1>
  <p>
    <b>Aplikasi manajemen data pusat kebugaran (GYM) di wilayah Bandung berbasis Flutter dengan UI Dark Mode Premium.</b>
  </p>
  
  [![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev/)
  [![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
  [![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)](https://firebase.google.com/)
  [![Cloudinary](https://img.shields.io/badge/Cloudinary-3448C5?style=for-the-badge&logo=Cloudinary&logoColor=white)](https://cloudinary.com/)
</div>

<br/>

> **Catatan Akademis:** Proyek ini dikembangkan untuk memenuhi tugas Ujian Akhir Semester (UAS) Mata Kuliah Praktikum Pemrograman III (Mobile), Program Studi Teknik Informatika, Universitas Kebangsaan Republik Indonesia (UKRI).

---

## ✨ Fitur Utama

Aplikasi ini tidak hanya sekadar alat pendataan, tetapi juga teman gaya hidup yang memudahkan pengguna dalam memantau informasi kebugaran. Fitur yang tersedia meliputi:

- 🔒 **Autentikasi Aman:** Sistem Login dan Registrasi cerdas menggunakan **Firebase Authentication** dengan validasi _form_ yang ketat.
- 📊 **Dashboard Interaktif:** Menampilkan ringkasan data, jadwal latihan mingguan, dan target asupan kalori/protein harian pengguna.
- 🗄️ **Manajemen Data (CRUD):** Tambah, Baca, Edit, dan Hapus data tempat GYM secara _real-time_ dengan **Firebase Cloud Firestore**.
- ☁️ **Cloud Image Upload:** Terintegrasi dengan **Cloudinary API** untuk mengunggah dan menyimpan foto tempat GYM dengan aman tanpa membebani penyimpanan lokal.
- 🔍 **Pencarian Cepat (Smart Search):** Fitur _searching_ responsif menggunakan teknik _Debouncing_ dan _Local Memory Filtering_ untuk performa maksimal.
- 🚀 **Quick Actions:** Terhubung secara langsung dengan fitur bawaan OS melalui **URL Launcher** (Buka Rute di _Google Maps_ & Chat ke _WhatsApp_ pengelola).
- 🎨 **Premium UI/UX:** Desain _Dark Mode_ elegan dengan animasi transisi yang mulus (_Fade_ & _Slide Transition_).

---

## 📱 Pratinjau Layar (Screenshots)

_(Ganti URL gambar di bawah ini dengan tautan gambar aslimu setelah kamu mengunggah screenshot ke dalam folder repository GitHub)_

<div align="center">
  <table style="border-collapse: collapse; border: none;">
    <tr>
      <td align="center"><img src="https://via.placeholder.com/250x500/16161F/FFFFFF?text=Login+Screen" width="200" alt="Login"/></td>
      <td align="center"><img src="https://via.placeholder.com/250x500/16161F/FFFFFF?text=Dashboard" width="200" alt="Dashboard"/></td>
      <td align="center"><img src="https://via.placeholder.com/250x500/16161F/FFFFFF?text=Explore+GYM" width="200" alt="Data Page"/></td>
    </tr>
    <tr>
      <td align="center"><b>Authentication</b></td>
      <td align="center"><b>Dashboard Utama</b></td>
      <td align="center"><b>Katalog GYM</b></td>
    </tr>
    <tr>
      <td align="center"><img src="https://via.placeholder.com/250x500/16161F/FFFFFF?text=Detail+Page" width="200" alt="Detail"/></td>
      <td align="center"><img src="https://via.placeholder.com/250x500/16161F/FFFFFF?text=Form+Input" width="200" alt="Form"/></td>
      <td align="center"><img src="https://via.placeholder.com/250x500/16161F/FFFFFF?text=Search+Feature" width="200" alt="Search"/></td>
    </tr>
    <tr>
      <td align="center"><b>Detail Informasi</b></td>
      <td align="center"><b>Form Data Dinamis</b></td>
      <td align="center"><b>Fitur Pencarian</b></td>
    </tr>
  </table>
</div>

---

## 🛠️ Teknologi yang Digunakan

- **SDK:** Flutter
- **Bahasa Pemrograman:** Dart
- **Database (BaaS):** Firebase Cloud Firestore
- **Autentikasi:** Firebase Authentication
- **Image Storage:** Cloudinary
- **Routing/State:** Flutter Default State Management (StatefulWidget) & Singleton Controller
- **Package Utama:** \* `cloud_firestore` & `firebase_auth`
  - `http` & `crypto` (Untuk Cloudinary API)
  - `image_picker`
  - `url_launcher`

---

## 🚀 Panduan Instalasi (Getting Started)

Jika Anda ingin menjalankan proyek ini di mesin lokal Anda, ikuti langkah-langkah berikut:

### 1. Prasyarat

Pastikan Anda telah menginstal **Flutter SDK** dan **Dart** di komputer Anda. Anda juga membutuhkan akun **Firebase** dan **Cloudinary**.

### 2. Kloning Repository

```bash
git clone [https://github.com/username-kamu/gym-bandung-center.git](https://github.com/username-kamu/gym-bandung-center.git)
cd gym-bandung-center
```
