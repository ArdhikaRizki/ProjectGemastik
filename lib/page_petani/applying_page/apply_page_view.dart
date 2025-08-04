import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'apply_page_controller.dart';
import 'package:intl/intl.dart';
import 'image_fullscreen_view.dart';

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
    // Tangkap data yang diparsing dari halaman sebelumnya
    final args = Get.arguments ?? {};

    final String name = args['name'] ?? 'Tidak ada nama';
    final String desc = args['desc'] ?? 'Tidak ada deskripsi';
    final int harga = args['harga'] ?? 0;
    final List<String> imageUrl = args['imageUrl'] ?? '';
    final _controller = Get.put(
      ApplyPageViewController(productId: args['id'] ?? ''),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF018241),
        foregroundColor: Colors.white,
        title: const Text('Apply Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF018241)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl.isNotEmpty)
                Stack(
                  children: [
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
                        height: 150.0,
                        viewportFraction: 1.0,
                        enlargeCenterPage: false,
                        // Panggil method dari controller saat halaman berubah.
                        onPageChanged: (index, reason) {
                          _controller.onPageChanged(index);
                        },
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 20.0,
                      // Bungkus widget yang perlu update dengan Obx.
                      child: Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(imageUrl.length, (index) {
                            // Bandingkan dengan nilai dari controller.
                            return _buildIndicator(
                              index == _controller.activeIndex.value,
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF018241),
                    ),
                  ),
                  Text(
                    'Rp ${NumberFormat.decimalPattern('id_ID').format(harga)} /kg',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF018241),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                desc,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              const Text(
                "Daftar Koperasi",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF018241),
                ),
              ),
              const SizedBox(height: 8),
              Obx(() {
                if (_controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF018241)),
                  );
                }
                if (_controller.cooperativeList.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada koperasi yang tersedia.'),
                  );
                }
                return SizedBox(
                  height: 300,

                  child: ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    itemCount: _controller.cooperativeList.length,
                    itemBuilder: (context, index) {
                      final item = _controller.cooperativeList[index];
                      final cooperative = item.koperasi;
                      final hasBeenOffered = item.hasBeenOffered;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                (cooperative.urlfoto.isNotEmpty)
                                    ? NetworkImage(cooperative.urlfoto)
                                    // ignore: prefer_const_constructors
                                    : null, // Menghilangkan warning
                            child:
                                (cooperative.urlfoto.isEmpty)
                                    ? const Icon(Icons.business)
                                    : null,
                          ),
                          title: Text(
                            cooperative.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            cooperative.email,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          // Tampilkan tombol atau teks berdasarkan status tawaran
                          trailing:
                              hasBeenOffered
                                  ? const Text(
                                    'Sudah Ditawarkan',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  )
                                  : ElevatedButton(
                                    onPressed:
                                        () => _controller.addPenawaran(
                                          cooperative.id,
                                        ),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      backgroundColor: const Color(0xFF018241),
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Tawarkan'),
                                  ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
