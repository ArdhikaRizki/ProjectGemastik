import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:project_gemastik/Dashboard/Model/product_model.dart';

class ProductPageController extends GetxController {
  var activeIndex = 0.obs;

  void onPageChanged(int index) {
    activeIndex.value = index;
  }
}

class Productpageview extends StatelessWidget {
  Productpageview({super.key});
  ProductModel produk = Get.arguments as ProductModel;

  final List<String> urlImage = const [
    "https://www.pertanianku.com/wp-content/uploads/2021/04/Efek-Samping-Aflatoksin-pada-Kacang-Tanah-Berkualitas-Buruk.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR0QQ7EtC4wqszok8OlBcp0hyxRG1Zgv9Tp9A&s",
    "https://id-test-11.slatic.net/p/d33a1356319979b77b2a365e21dc291f.jpg",
    "https://eborong.com.my/wp-content/uploads/2019/07/kacang_tanah_india_1.jpg"
  ];

  // Helper method untuk membangun indikator
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
    // Inisialisasi controller menggunakan Get.put().
    final ProductPageController controller = Get.put(ProductPageController());

    // Halaman sebaiknya mengembalikan Scaffold, bukan MaterialApp.
    return Scaffold(
      appBar: AppBar(
        title: Text(produk.title),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView( // Menggunakan SingleChildScrollView agar bisa di-scroll
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CarouselSlider.builder(
                  itemCount: 1,
                  itemBuilder: (context, index, realIndex) {
                    final url = produk.imageUrl;
                    return ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 300.0,
                    viewportFraction: 1.0,
                    enlargeCenterPage: false,
                    // Panggil method dari controller saat halaman berubah.
                    onPageChanged: (index, reason) {
                      controller.onPageChanged(index);
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
                      children: List.generate(1, (index) {
                        // Bandingkan dengan nilai dari controller.
                        return _buildIndicator(
                            index == controller.activeIndex.value);
                      }),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        produk.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Rp ${produk.price} / Kg",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.right,
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    produk.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://assets.promediateknologi.id/crop/0x0:0x0/750x500/webp/photo/2022/11/27/4181532000.jpg'),
                        radius: 50,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Mas Gibran asal Solo",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Petani Kacang Tanah",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Action for Buy Now button
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Beli Sekarang",
                              style:
                              TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Action for Add to Cart button
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child:
                        const Icon(Icons.shopping_cart, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
