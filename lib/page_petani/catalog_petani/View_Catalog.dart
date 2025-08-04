import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:project_gemastik/page_petani/history_apply/history_view.dart';
import 'package:project_gemastik/routes/route_names.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'Controller_Catalog.dart';
import 'package:intl/intl.dart';


class View_Catalog extends StatelessWidget {
  const View_Catalog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller menggunakan Get.put()
    final Controller_Catalog controller = Get.put(Controller_Catalog());

    Widget _buildIndicator(bool isActive) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        width: isActive ? 12.0 : 8.0,
        height: isActive ? 12.0 : 8.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? Colors.green : Colors.grey,
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(
        0xFFF5F5F5,
      ), // Warna latar belakang abu-abu muda
      appBar: AppBar(
        backgroundColor: const Color(0xFF018241), // Warna hijau AppBar
        foregroundColor: Colors.white,
        title: const Text('Produk Mu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Get.to(const HistoryView()),
          ),
        ],
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
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (dialogContext) => AlertDialog(
                        title: Text(product.name),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: SizedBox(
                                  height: 200,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: CarouselSlider.builder(
                                          itemCount: product.imageUrl.length,
                                          itemBuilder: (
                                            context,
                                            index,
                                            realIndex,
                                          ) {
                                            final url = product.imageUrl[index];
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                url,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                              ),
                                            );
                                          },
                                          options: CarouselOptions(
                                            viewportFraction: 1.0,
                                            enlargeCenterPage: false,
                                            onPageChanged: (index, reason) {
                                              controller.onPageChanged(index);
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Obx(
                                        () => Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: List.generate(
                                            product.imageUrl.length,
                                            (index) {
                                              return _buildIndicator(
                                                index ==
                                                    controller
                                                        .activeIndex
                                                        .value,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text("Deskripsi: ${product.desc}"),
                              Text('Harga: Rp ${NumberFormat.decimalPattern('id_ID').format(product.harga)} /kg',),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            child: const Text("Tutup"),
                          ),
                        ],
                      ),
                );
              },
              child: Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                elevation: 2,
                shadowColor: Colors.black.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Detail Produk + Tombol
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.desc,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Rp ${NumberFormat.decimalPattern('id_ID').format(product.harga)} /kg',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (Get.isSnackbarOpen) {
                                        Get.closeCurrentSnackbar();
                                      }
                                      Get.defaultDialog(
                                        title: "Konfirmasi Hapus",
                                        middleText:
                                            "Apakah Anda yakin ingin menghapus produk ini?",
                                        textConfirm: "Hapus",
                                        textCancel: "Batal",
                                        confirmTextColor: Colors.white,
                                        onConfirm: () async {
                                          Get.back(); // Tutup dialog konfirmasi
                                          controller
                                              .deleteProduct(product)
                                              .then((_) {
                                                Get.snackbar(
                                                  "Berhasil",
                                                  "Produk berhasil dihapus",
                                                  snackPosition:
                                                      SnackPosition.TOP,
                                                );
                                              });
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Hapus',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Get.toNamed(
                                        RouteNames.applyCatalog,
                                        arguments: {
                                          'id': product.docId,
                                          'name': product.name,
                                          'imageUrl': product.imageUrl,
                                          'desc': product.desc,
                                          'harga': product.harga,
                                          'idPetani' : product.uid
                                        },
                                      );
                                      // Logika untuk mengarahkan ke halaman apply
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF018241),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Apply',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
