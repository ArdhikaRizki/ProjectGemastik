import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'Add_Catalog_Controller.dart';

class addCatalogView extends StatelessWidget {
  addCatalogView({Key? key}) : super(key: key);

  final addCatalogController controller = Get.put(addCatalogController());
  final nameC = TextEditingController();
  final descC = TextEditingController();
  final priceC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF018241);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Tambah Produk'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add Photos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Obx(() => SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.selectedImages.length + 1,
                itemBuilder: (context, index) {
                  if (index == controller.selectedImages.length) {
                    return GestureDetector(
                      onTap: () => _showImageSourceDialog(context, controller),
                      child: Container(
                        width: 100, height: 100,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: primaryColor.withOpacity(0.5)),
                        ),
                        child: const Icon(Icons.add_photo_alternate_rounded, color: primaryColor, size: 40),
                      ),
                    );
                  }
                  final imageFile = controller.selectedImages[index];
                  return Container(
                    width: 100, height: 100,
                    margin: const EdgeInsets.only(right: 8.0),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(File(imageFile.path), width: 100, height: 100, fit: BoxFit.cover),
                        ),
                        Positioned(
                          top: 0, right: 0,
                          child: GestureDetector(
                            onTap: () => controller.removeImage(index),
                            child: Container(
                              decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                              child: const Icon(Icons.close, color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )),
            const SizedBox(height: 16),
            const Text("Nama Produk"),
            const SizedBox(height: 6),
            TextField(
              controller: nameC,
              decoration: InputDecoration(
                hintText: 'Nama Produk',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Harga per Kg"),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: priceC,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Rupiah',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Bungkus IconButton dengan Obx untuk menampilkan loading
                Obx(() => IconButton(
                  onPressed: controller.isGeneratingAI.value ? null : () {
                    controller.generateAIDetails(
                      productName: nameC.text,
                      priceController: priceC,
                      descController: descC,
                    );
                  },
                  icon: controller.isGeneratingAI.value
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.auto_awesome, color: primaryColor),
                  tooltip: 'Generate Harga & Deskripsi Otomatis',
                )),
              ],
            ),
            const SizedBox(height: 10),
            const Text("Detail Produk"),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  // --- PERBAIKAN UTAMA ADA DI SINI ---
                  child: TextField(
                    controller: descC,
                    // 1. maxLines: null membuat field bisa membesar tanpa batas
                    maxLines: null,
                    // 2. minLines: 3 memberikan tinggi awal minimal 3 baris
                    minLines: 3,
                    // 3. keyboardType: TextInputType.multiline memberikan keyboard yang sesuai
                    keyboardType: TextInputType.multiline,
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
                ),
                const SizedBox(width: 8),
                // Bungkus IconButton dengan Obx untuk menampilkan loading
                Obx(() => IconButton(
                  onPressed: controller.isGeneratingAI.value ? null : () {
                    controller.generateAIDetails(
                      productName: nameC.text,
                      priceController: priceC,
                      descController: descC,
                    );
                  },
                  icon: controller.isGeneratingAI.value
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.auto_awesome, color: primaryColor),
                  tooltip: 'Generate Harga & Deskripsi Otomatis',
                )),
              ],
            ),
            const SizedBox(height: 32),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Tambah', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showImageSourceDialog(BuildContext context, addCatalogController controller) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
