import 'package:flutter/material.dart';
// Note: To use image_picker, you would need to add it to your pubspec.yaml
// import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const ProfileView());
}

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Profile Page',
      theme: ThemeData(
        primaryColor: const Color(0xFF00AA5B),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          shadowColor: Color(0xFFE0E0E0),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Color(0xFF00AA5B), width: 2.0),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14.0,
            horizontal: 16.0,
          ),
        ),
      ),
      home: const ProfilePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Profil'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: const Color(0xFF00AA5B),
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: const Color(0xFF00AA5B),
          indicatorWeight: 3.0,
          tabs: const [
            Tab(text: 'Biodata Diri'),
            Tab(text: 'Daftar Alamat'),
            Tab(text: 'Notifikasi'),
            Tab(text: 'Mode Tampilan'),
            Tab(text: 'Keamanan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const ProfileDetailsTab(),
          // Placeholder for other tabs
          const Center(child: Text('Daftar Alamat')),
          const Center(child: Text('Notifikasi')),
          const Center(child: Text('Mode Tampilan')),
          const Center(child: Text('Keamanan')),
        ],
      ),
    );
  }
}

class ProfileDetailsTab extends StatefulWidget {
  const ProfileDetailsTab({Key? key}) : super(key: key);

  @override
  _ProfileDetailsTabState createState() => _ProfileDetailsTabState();
}

class _ProfileDetailsTabState extends State<ProfileDetailsTab> {
  final TextEditingController _nameController = TextEditingController(
    text: 'Firman Arman Elyuzar',
  );
  final TextEditingController _dobController = TextEditingController(
    text: '30 Desember 2000',
  );
  final TextEditingController _genderController = TextEditingController(
    text: 'Waria',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'NgentotAsik@gmail.com',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '628789823345',
  );

  File? _image;
  bool _safeMode = false;

  // State to track which field is being edited
  String? _editingField;

  Future<void> _pickImage() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Image picker functionality would be implemented here.',
        ),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required TextEditingController controller,
    bool isVerified = false,
    required String fieldKey,
  }) {
    bool isEditing = _editingField == fieldKey;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 15),
            ),
          ),
          Expanded(
            child:
                isEditing
                    ? TextField(
                      controller: controller,
                      autofocus: true,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                      ),
                    )
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.text,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (isVerified) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              'Terverifikasi',
                              style: TextStyle(
                                color: Color(0xFF00AA5B),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
          ),
          const SizedBox(width: 16),
          TextButton(
            onPressed: () {
              setState(() {
                if (isEditing) {
                  // This is where you would save the data
                  _editingField = null;
                } else {
                  _editingField = fieldKey;
                }
              });
            },
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWideScreen = constraints.maxWidth > 600;
        return SingleChildScrollView(
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
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Flex(
                  direction: isWideScreen ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: isWideScreen ? 1 : 0,
                      child: _buildProfileImageSection(),
                    ),
                    if (isWideScreen) const SizedBox(width: 32),
                    Flexible(
                      flex: isWideScreen ? 2 : 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                            label: 'Nama',
                            controller: _nameController,
                            fieldKey: 'name',
                          ),
                          _buildInfoRow(
                            label: 'Tanggal Lahir',
                            controller: _dobController,
                            fieldKey: 'dob',
                          ),
                          _buildInfoRow(
                            label: 'Jenis Kelamin',
                            controller: _genderController,
                            fieldKey: 'gender',
                          ),
                          const Divider(height: 32),
                          Text(
                            'Ubah Kontak',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                            label: 'Email',
                            controller: _emailController,
                            isVerified: true,
                            fieldKey: 'email',
                          ),
                          _buildInfoRow(
                            label: 'Nomor HP',
                            controller: _phoneController,
                            isVerified: true,
                            fieldKey: 'phone',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildSafeModeSection(),
              const SizedBox(height: 24),
              _buildLogOutSection(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileImageSection() {
    return Column(
      children: [
        CircleAvatar(
          radius: 70,
          backgroundImage:
              _image != null
                  ? FileImage(_image!)
                  : const NetworkImage(
                        'https://placehold.co/400x400/FF5722/FFFFFF?text=R',
                      )
                      as ImageProvider,
          backgroundColor: Colors.grey[200],
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.photo_camera_outlined),
          label: const Text('Pilih Foto'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.grey[700],
            side: BorderSide(color: Colors.grey[300]!),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Besar file: maksimum 10.000.000 bytes (10 Megabytes). Ekstensi file yang diperbolehkan: JPG, JPEG, PNG',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
      ],
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
                  'Fitur ini akan otomatis menyaring hasil pencarian sesuai kebijakan dan batasan usia pengguna.',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Switch(
            value: _safeMode,
            onChanged: (value) {
              setState(() {
                _safeMode = value;
              });
            },
            activeColor: const Color(0xFF00AA5B),
          ),
        ],
      ),
    );
  }

  @override
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
          const SizedBox(height: 8),
          Text(
            'Anda dapat keluar dari akun Anda dengan menekan tombol di bawah ini.',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Handle logout logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Anda telah keluar.'),
                    backgroundColor: Colors.red[700],
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
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
