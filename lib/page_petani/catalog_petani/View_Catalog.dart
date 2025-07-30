import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'Controller_Catalog.dart';

class View_Catalog extends StatelessWidget {
  const View_Catalog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller menggunakan Get.put()
    final Controller_Catalog controller = Get.put(Controller_Catalog());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Warna latar belakang abu-abu muda
      appBar: AppBar(
        backgroundColor: const Color(0xFF018241), // Warna hijau AppBar
        foregroundColor: Colors.white,
        title: const Text('Produk Mu'),
        elevation: 0,
      ),
      // Gunakan Obx untuk membuat UI reaktif terhadap perubahan state
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.productList.length,
          itemBuilder: (context, index) {
            final product = controller.productList[index];
            // --- KODE UNTUK KARTU PRODUK DIMASUKKAN LANGSUNG DI SINI ---
            return Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              elevation: 2,
              shadowColor: Colors.black.withOpacity(0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // Gambar Produk
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        product.imageUrl.first,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Detail Produk
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.desc,
                            style: TextStyle(color: Colors.grey[600], fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.harga.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    // Tombol Beli
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF018241),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: const Text('NUNUA'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      // --- KODE UNTUK TOMBOL BAWAH DIMASUKKAN LANGSUNG DI SINI ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        color: const Color(0xFFF5F5F5), // Warna sama dengan background body
        child: ElevatedButton(
          onPressed: () {
            Get.toNamed('/addCatalog');
            // Logika untuk menambah produk
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF018241),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Tambah Produk',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
