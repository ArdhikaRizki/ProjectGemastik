import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ApplyPageViewController extends GetxController {
  var activeIndex = 0.obs;

  void onPageChanged(int index) {
    activeIndex.value = index;
  }
}


class Applypageview extends StatelessWidget {

  Applypageview({super.key});
  final _controller = Get.put(ApplyPageViewController());

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF018241),
        foregroundColor: Colors.white,
        title: const Text('Apply Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16),
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
                        return ClipRRect(
                          child: Image.network(
                            url,
                            fit: BoxFit.cover,
                            width: double.infinity,
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
                                index == _controller.activeIndex.value);
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 12),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF018241),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                desc,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Harga: Rp${harga.toString()}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

