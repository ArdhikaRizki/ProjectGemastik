import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'Add_Catalog_Controller.dart';

class addCatalogView extends StatelessWidget {
  addCatalogView({Key? key}) : super(key: key);

  addCatalogController controller = Get.put(addCatalogController());
  final nameC = TextEditingController();
  final descC = TextEditingController();
  final priceC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Warna utama yang digunakan di seluruh halaman
    const Color primaryColor = Color(0xFF018241);

    return Scaffold(
      // --- AppBar ---
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.green,
        title: const Text('Tambah Produk'), // Teks 'Profile' sesuai gambar
        elevation: 0,
      ),
      // --- Body ---
      body: SingleChildScrollView(
        // Padding untuk seluruh konten
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Bagian "Add Photos" ---
            const Text(
              'Add Photos',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Ikon untuk menambah foto
            Obx(
              () => SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.selectedImages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.selectedImages.length) {
                      // Tombol untuk menambah gambar
                      return GestureDetector(
                        onTap:
                            () => _showImageSourceDialog(context, controller),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: primaryColor.withOpacity(0.5),
                            ),
                          ),
                          child: const Icon(
                            Icons.add_photo_alternate_rounded,
                            color: primaryColor,
                            size: 40,
                          ),
                        ),
                      );
                    }
                    // Pratinjau gambar yang dipilih
                    final imageFile = controller.selectedImages[index];
                    return Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(right: 8.0),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(imageFile.path),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => controller.removeImage(index),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text("Nama Produk"),
            const SizedBox(height: 6),
            // --- Form Input ---
            // TextField untuk Nama Produk
            TextField(
              controller: nameC,
              decoration: InputDecoration(
                hintText: 'Nama Produk',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Harga per Kg"),
            const SizedBox(height: 6),
            // TextField untuk Lokasi
            TextField(
              controller: priceC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Rupiah',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Detail Produk"),
            // TextField untuk Deskripsi
            const SizedBox(height: 6),
            TextField(
              controller: descC,
              decoration: InputDecoration(
                hintText: 'Deskripsi Produk',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // --- Tombol Submit ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  controller.saveProduct(
                    name: nameC.text,
                    desc: descC.text,
                    price: priceC.text,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Tambah',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showImageSourceDialog(
    BuildContext context,
    addCatalogController controller,
  ) async {
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Pilih Sumber Gambar"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text("Galeri (Pilih Banyak)"),
                  onTap: () {
                    Navigator.of(context).pop();
                    controller.pickMultiImageFromGallery();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Kamera (Pilih Satu)"),
                  onTap: () {
                    Navigator.of(context).pop();
                    controller.pickSingleImageFromCamera();
                  },
                ),
              ],
            ),
          ),
    );
  }
}
