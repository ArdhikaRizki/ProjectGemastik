import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../LoginRegister/SignInUpController.dart';
import '../LoginRegister/UserModel.dart';
import 'profileController.dart';

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
  String _role =
      "loading"; // Ganti dengan logika yang sesuai untuk mendapatkan role
  @override
  void initState() {
    super.initState();
    // Panggil method untuk mengambil dan mengatur data awal.
    _loadInitialData();
  }

  /// Mengambil data dari controller dan mengatur nilai awal untuk semua field.
  Future<void> _loadInitialData() async {
    UserModel userdata = await controller.getUserData();
    _role = userdata.role; // Ambil role dari userdata
    // Pastikan widget masih ada sebelum memanggil setState
    if (mounted) {
      setState(() {
        _nameController.text = userdata.name;
        _emailController.text = userdata.email;
        _imageUrl = userdata.urlfoto;
        _dobController.text = '30 Desember 2000';
        _genderController.text = 'Waria';
        _phoneController.text = userdata.phoneNumber;
      });
    }
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

  // PERBAIKAN: Method diubah menjadi async untuk menggunakan await.
  void _handleEditToggle(String fieldKey) async {
    if (_editingField == fieldKey) {
      // Ini adalah aksi "Simpan"
      // Panggil fungsi update dan tunggu hingga selesai.
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
      appBar: AppBar(title: const Text('Pengaturan Profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ubah Biodata Diri',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
          const Divider(height: 32),
          Text(
            'Ubah Kontak',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Email', _emailController, 'email', isVerified: true),
          _buildInfoRow(
            'Nomor HP',
            _phoneController,
            'phone',
            isVerified: true,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    "Sebagai",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                Text(
                  _role.toUpperCase(),
                  style: TextStyle(
                    color: Color(0xFF00AA5B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // PERBAIKAN UTAMA ADA DI SINI
  Widget _buildProfileImageSection() {
    ImageProvider backgroundImage;
    if (_imageUrl != null && _imageUrl!.isNotEmpty) {
      // Buat NetworkImage tanpa key
      backgroundImage = NetworkImage(_imageUrl!);
    } else {
      // Gambar placeholder default
      backgroundImage = const NetworkImage(
        'https://placehold.co/400x400/FF5722/FFFFFF?text=R',
      );
    }

    return Column(
      children: [
        Obx(() {
          backgroundImage.evict();
          return CircleAvatar(
            // PERBAIKAN: Tempatkan UniqueKey() di sini, pada widget CircleAvatar
            key: controller.imageKey.value,
            radius: 70,
            backgroundImage: backgroundImage,
            backgroundColor: Colors.grey[200],
          );
        }),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () async {
            // 1. Wait for the image to be picked and uploaded
            await controller.pickImage();

            // 2. Refresh the user data on the screen
            await _loadInitialData();
          },
          icon: const Icon(Icons.photo_camera_outlined),
          label: const Text('Ubah Foto'),
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
    String label,
    TextEditingController controller,
    String fieldKey, {
    bool isVerified = false,
  }) {
    bool isEditing = _editingField == fieldKey;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: TextStyle(color: Colors.grey[600])),
          ),
          Expanded(
            child:
                isEditing
                    ? TextField(controller: controller, autofocus: true)
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.text,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        if (isVerified) ...[
                          const SizedBox(height: 4),
                          const Text(
                            'Terverifikasi',
                            style: TextStyle(
                              color: Color(0xFF00AA5B),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
          ),
          TextButton(
            onPressed: () => _handleEditToggle(fieldKey),
            child: Text(
              isEditing ? 'Simpan' : 'Ubah',
              style: const TextStyle(
                color: Color(0xFF00AA5B),
                fontWeight: FontWeight.bold,
              ),
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
                Text(
                  'Safe Mode',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Menyaring hasil pencarian.',
                  style: TextStyle(color: Colors.grey[600]),
                ),
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
          Text(
            'Keluar',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
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
              child: const Text(
                'Keluar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
