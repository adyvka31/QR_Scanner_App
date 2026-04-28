# 📹 QR Scanner & Guest Manager App 📹

**QR Scanner & Guest Manager** adalah aplikasi mudah alih yang dibina menggunakan **Flutter** untuk memudahkan proses pendaftaran dan pengurusan tetamu melalui imbasan kod QR. Aplikasi ini diintegrasikan dengan **Firebase** untuk memastikan penyimpanan data yang selamat dan masa nyata (*real-time*).

## 🚀 Fitur Utama

- **Imbasan Kod QR:** Menggunakan kamera peranti untuk mengimbas kod QR tiket atau tetamu secara pantas.
- **Pengurusan Tetamu:** Menambah maklumat tetamu baru secara manual atau melalui API.
- **Sistem Autentikasi:** Log masuk dan pendaftaran akaun menggunakan **Firebase Auth**.
- **Penyimpanan Awan:** Data tetamu dan status tiket disimpan serta dikemaskini secara automatik dalam **Cloud Firestore**.
- **Skrin Splash:** Antarmuka permulaan yang profesional sebelum masuk ke aplikasi utama.
- **Antarmuka Moden:** Reka bentuk UI yang bersih dan responsif untuk pengalaman pengguna yang lebih baik.

## 🛠️ Teknologi yang Digunakan

- **Framework:** [Flutter](https://flutter.dev/) (Dart)
- **Backend/Database:** [Firebase](https://firebase.google.com/) (Authentication & Cloud Firestore)
- **Networking:** [http](https://pub.dev/packages/http) untuk integrasi perkhidmatan API.
- **QR Engine:** [mobile_scanner](https://pub.dev/packages/mobile_scanner) (atau pakej seumpamanya) untuk fungsi kamera.

## 📂 Struktur Projek
File README created at /mnt/data/README_QR_Scanner_App.md

```text
├── lib/
│   ├── auth/            # Skrin log masuk dan pendaftaran
│   ├── models/          # Model data (Ticket/Guest)
│   ├── services/        # Logika API, Firebase Auth, dan Firestore
│   ├── views/           # Skrin utama (Home, Splash, Add Guest)
│   ├── main.dart        # Titik permulaan aplikasi
│   └── firebase_options.dart # Konfigurasi Firebase
├── android/             # Konfigurasi platform Android (termasuk google-services.json)
├── ios/                 # Konfigurasi platform iOS (termasuk GoogleService-Info.plist)
└── pubspec.yaml         # Fail pengurusan dependensi
