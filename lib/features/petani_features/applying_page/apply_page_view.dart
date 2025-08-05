// lib/page_petani/applying_page/apply_page_view.dart

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'image_fullscreen_view.dart';
import '../proses_tawar_menawar/proses_tawaran_view.dart';
import 'apply_page_view_controller.dart';

class Applypageview extends StatelessWidget {
  Applypageview({super.key});

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

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final String name = args['name'] ?? 'Tidak ada nama';
    final String desc = args['desc'] ?? 'Tidak ada deskripsi';
    final int harga = args['harga'] ?? 0;
    final List<String> imageUrl = List<String>.from(args['imageUrl'] ?? []);
    final _controller = Get.put(
      ApplyPageViewController(productId: args['id'] ?? ''),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF018241),
        foregroundColor: Colors.white,
        title: const Text('Tawarkan ke Koperasi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian detail produk (Carousel, nama, deskripsi)
            if (imageUrl.isNotEmpty)
              Stack(
                children: [
                  // --- KODE CAROUSEL YANG HILANG, SAYA KEMBALIKAN DI SINI ---
                  CarouselSlider.builder(
                    itemCount: imageUrl.length,
                    itemBuilder: (context, index, realIndex) {
                      final url = imageUrl[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            () => ImageFullscreenView(
                              imageUrls: imageUrl,
                              initialIndex: index,
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            url,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 200.0,
                      viewportFraction: 1.0,
                      enlargeCenterPage: false,
                      onPageChanged: (index, reason) {
                        _controller.onPageChanged(index);
                      },
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 10.0,
                    child: Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(imageUrl.length, (index) {
                          return _buildIndicator(
                            index == _controller.activeIndex.value,
                          );
                        }),
                      ),
                    ),
                  ),
                  // --- BATAS AKHIR KODE CAROUSEL ---
                ],
              ),
            const SizedBox(height: 12),
            Text(name.toUpperCase(),
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF018241))),
            const SizedBox(height: 4),
            Text(
                'Rp ${NumberFormat.decimalPattern('id_ID').format(harga)} /kg',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            const SizedBox(height: 8),
            Text(desc,
                style: const TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            const Text("Daftar Koperasi",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF018241))),
            const SizedBox(height: 8),
            Obx(() {
              if (_controller.isLoading.value) {
                return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF018241)));
              }
              if (_controller.cooperativeList.isEmpty) {
                return const Center(
                    child: Text('Tidak ada koperasi yang tersedia.'));
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _controller.cooperativeList.length,
                itemBuilder: (context, index) {
                  final item = _controller.cooperativeList[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundImage: (item.koperasi.urlfoto.isNotEmpty)
                              ? NetworkImage(item.koperasi.urlfoto)
                              : null,
                          child: (item.koperasi.urlfoto.isEmpty)
                              ? const Icon(Icons.business)
                              : null),
                      title: Text(item.koperasi.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(item.koperasi.email),
                      trailing: item.hasBeenOffered
                          ? IconButton(
                              icon: const Icon(Icons.history,
                                  color: Color(0xFF018241)),
                              tooltip: 'Lihat Proses Penawaran',
                              onPressed: () {
                                if (item.penawaranId != null) {
                                  Get.to(() => const ProsesTawaranView(),
                                      arguments: item.penawaranId);
                                } else {
                                  Get.snackbar('Error',
                                      'ID Penawaran tidak ditemukan.');
                                }
                              },
                            )
                          : ElevatedButton(
                              onPressed: () =>
                                  _controller.addPenawaran(item.koperasi.id),
                              child: const Text('Tawarkan'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF018241),
                                foregroundColor: Colors.white,
                              ),
                            ),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}