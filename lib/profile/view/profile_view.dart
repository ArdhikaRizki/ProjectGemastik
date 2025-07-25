import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Catatan: Untuk menggunakan image_picker, Anda perlu menambahkannya ke pubspec.yaml
// import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:get/get_core/src/get_main.dart';
import 'package:project_gemastik/LoginRegister/View/RegisterView.dart';
import 'package:project_gemastik/main.dart';

// Ganti ini dengan path model dan controller Anda yang sebenarnya
import '../../LoginRegister/Controlller/SignInUpController.dart';
import '../../LoginRegister/Model/UserModel.dart';
import '../Controller/profileController.dart';


// --- WIDGET HALAMAN PROFIL ---
class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileView> {
  // --- Controllers ---
  // Deklarasikan sebagai final, nilainya akan diatur di initState.
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _genderController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // --- GetX Controller ---
  final controller = Get.put(profileController(), permanent: true);
  final authC = Get.find<SignInUpController>();
  // --- Variabel State ---
  File? _image;
  String? _imageUrl; // Variabel untuk menyimpan URL gambar dari input
  bool _safeMode = false;
  String? _editingField;

  @override
  void initState() {
    super.initState();
    // Panggil method untuk mengambil dan mengatur data awal.
    _loadInitialData();
  }

  /// Mengambil data dari controller dan mengatur nilai awal untuk semua field.
  Future<void> _loadInitialData() async {
    // Ambil data pengguna dari controller Anda
    UserModel userdata = await controller.getUserData();

    // Gunakan setState untuk memberitahu UI agar diperbarui setelah data diterima.
    setState(() {
      _nameController.text = userdata.name;
      _emailController.text = userdata.email;
      _imageUrl = userdata.urlfoto; // Asumsikan ada field urlfoto di model
      // Anda bisa menambahkan _imageUrl = userdata.imageUrl jika ada di model

      // Atur nilai default untuk field lain di sini jika perlu
      _dobController.text = '30 Desember 2000'; // Ganti dengan data asli jika ada
      _genderController.text = 'Waria'; // Ganti dengan data asli jika ada
      _phoneController.text = userdata.phoneNumber; // Ganti dengan data asli jika ada
    });
  }

  @override
  void dispose() {
    // Membersihkan controller untuk membebaskan sumber daya
    _nameController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // --- Method untuk logika UI ---

  // PERUBAHAN: Mengubah SnackBar menjadi Dialog untuk input URL
  Future<void> _pickImage() async {
    final urlController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Masukkan URL Gambar Profil'),
        content: TextField(
          controller: urlController,
          decoration: const InputDecoration(hintText: "https://contoh.com/gambar.jpg"),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (urlController.text.isNotEmpty) {
                setState(() {
                  _imageUrl = urlController.text;
                  _image = null; // Hapus gambar lokal jika ada
                  controller.updateImage(urlController.text);
                });
              }
              Navigator.of(context).pop();
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // PERBAIKAN: Method diubah menjadi async untuk menggunakan await.
  void _handleEditToggle(String fieldKey) async {
    if (_editingField == fieldKey) {
      // Ini adalah aksi "Simpan"
      // Panggil fungsi update dan tunggu hingga selesai.
      // (Anda bisa menambahkan indikator loading di sini untuk UX yang lebih baik)
      if (fieldKey == 'name') {
        await controller.updateName(_nameController.text);
      }
      if (fieldKey == 'phone') {
        await controller.updatePhoneNumber(_phoneController.text);
      }
      setState(() {
        _editingField = null;
      });
    } else {
      // Ini adalah aksi "Ubah"
      setState(() {
        _editingField = fieldKey;
      });
    }
  }

  // --- Method utama untuk membangun seluruh UI ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Profil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ubah Biodata Diri',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildProfileCard(),
            const SizedBox(height: 24),
            _buildSafeModeSection(),
            const SizedBox(height: 24),
            _buildLogOutSection(),
          ],
        ),
      ),
    );
  }

  // --- Method bantuan untuk membangun setiap bagian dari halaman ---

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: _buildProfileImageSection()),
          const SizedBox(height: 24),
          _buildInfoRow('Nama', _nameController, 'name'),
          // _buildInfoRow('Tanggal Lahir', _dobController, 'dob'),
          const Divider(height: 32),
          Text(
            'Ubah Kontak',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Email', _emailController, 'email', isVerified: true),
          _buildInfoRow('Nomor HP', _phoneController, 'phone', isVerified: true),
        ],
      ),
    );
  }

  Widget _buildProfileImageSection() {
    // Logika untuk menentukan gambar yang akan ditampilkan
    ImageProvider backgroundImage;
    if (_image != null) {
      backgroundImage = FileImage(_image!);
    } else if (_imageUrl != null && _imageUrl!.isNotEmpty) {
      backgroundImage = NetworkImage(_imageUrl!);
    } else {
      // Gambar placeholder default
      backgroundImage = const NetworkImage('https://placehold.co/400x400/FF5722/FFFFFF?text=R');
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 70,
          backgroundImage: backgroundImage,
          backgroundColor: Colors.grey[200],
          // Menambahkan errorBuilder untuk NetworkImage
          onBackgroundImageError: _imageUrl != null && _imageUrl!.isNotEmpty ? (exception, stackTrace) {
            // Anda bisa menampilkan pesan error atau gambar default lain jika URL gagal dimuat
            print('Error loading image: $exception');
          } : null,
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: (){
            controller.pickImage();
            controller.getUserData();
          },
          icon: const Icon(Icons.photo_camera_outlined),
          label: const Text('Ubah Foto'), // Teks diubah agar lebih sesuai
        ),
        const SizedBox(height: 8),
        Text(
          'Besar file: maks 10 MB. Ekstensi: JPG, JPEG, PNG',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
      String label, TextEditingController controller, String fieldKey,
      {bool isVerified = false}) {
    bool isEditing = _editingField == fieldKey;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(color: Colors.grey[600])),
          ),
          Expanded(
            child: isEditing
                ? TextField(controller: controller, autofocus: true)
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(controller.text,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                if (isVerified) ...[
                  const SizedBox(height: 4),
                  const Text('Terverifikasi',
                      style: TextStyle(
                          color: Color(0xFF00AA5B),
                          fontWeight: FontWeight.bold)),
                ]
              ],
            ),
          ),
          TextButton(
            onPressed: () => _handleEditToggle(fieldKey),
            child: Text(
              isEditing ? 'Simpan' : 'Ubah',
              style: const TextStyle(
                  color: Color(0xFF00AA5B), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafeModeSection() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Safe Mode',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Menyaring hasil pencarian.',
                    style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
          Switch(
            value: _safeMode,
            onChanged: (value) => setState(() => _safeMode = value),
            activeColor: const Color(0xFF00AA5B),
          ),
        ],
      ),
    );
  }

  Widget _buildLogOutSection() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Keluar',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Anda telah keluar.')),
                );
                authC.signOut();
                Get.back();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Keluar', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
