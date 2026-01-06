# 🈶 Deteksi Aksara Jawa  
### Aplikasi Flutter dengan Machine Learning (TensorFlow Lite) & Node.js API

Proyek ini merupakan **aplikasi mobile berbasis Flutter** untuk **mendeteksi dan mengenali Aksara Jawa** menggunakan **Machine Learning**.  
Model deteksi dijalankan menggunakan **TensorFlow Lite (TFLite)**, dengan **Node.js** sebagai backend API.

Aplikasi ini dirancang agar **ringan, cepat, dan mudah dikembangkan**, serta dapat digunakan sebagai media edukasi dan pelestarian budaya Aksara Jawa.

---

## 📱 Platform
- Flutter (Android / iOS)
- Backend API: Node.js

---

## 🔍 Fitur Aplikasi
- Input gambar melalui kamera atau galeri
- Deteksi dan klasifikasi Aksara Jawa
- Inferensi cepat menggunakan TensorFlow Lite
- Komunikasi Flutter dengan Node.js API
- Menampilkan hasil prediksi aksara

---

## 🧠 Alur Sistem
1. Pengguna mengambil atau memilih gambar melalui aplikasi Flutter
2. Gambar dikirim ke Backend API (Node.js)
3. Model TFLite melakukan proses inferensi
4. Hasil klasifikasi dikirim kembali ke aplikasi Flutter
5. Aksara Jawa ditampilkan ke pengguna

---

## 🚧 Status Pengembangan
⚠️ Proyek masih dalam tahap pengembangan.

Pengembangan selanjutnya:
- Peningkatan akurasi model Machine Learning
- Penambahan informasi history Aksara Jawa
- Dokumentasi endpoint API
- Optimasi performa inferensi
- Pengujian dengan dataset yang lebih besar


## 🚀 Cara Menjalankan Proyek

Panduan ini menjelaskan cara menjalankan **Backend (Node.js + TensorFlow Lite)** dan **Aplikasi Flutter**.

---

### 🔧 Prasyarat
Pastikan sudah terinstall:
- Git
- Node.js (LTS)
- Flutter SDK
- Android Studio / VS Code
- Emulator Android atau perangkat fisik

Cek instalasi:
```bash
node -v
flutter --version 
```

1. Clone Repo
```bash
git clone https://github.com/AlvianPh/aksara_detection.git
cd aksara_detection
```
2. Menjalankan Backend dengan nama file (api)
```bash
cd api
```
```bash
npm run dev
```
Jika berhasil akan muncul 
```bash
Server running on http://localhost:5000
```
3. Lalu jalankan saja aplikasi flutternya
