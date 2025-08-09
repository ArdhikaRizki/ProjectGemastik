import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_gemastik/features/Dashboard/Controller/dashboard_controller.dart';
import 'package:project_gemastik/features/Dashboard/Model/product_model.dart';
import 'package:project_gemastik/features/Dashboard/View/ProductPageView.dart';

class DashboardView extends StatelessWidget {
  // final DashboardController controller = Get.put(DashboardController()); // Dihapus dari sini

  DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // PERBAIKAN: Pindahkan inisialisasi controller ke dalam method build.
    // GetX cukup pintar untuk memastikan ini hanya dijalankan sekali.
    final DashboardController controller = Get.put(DashboardController());

    // Scaffold dan BottomNav sudah disediakan oleh MainScreen
    return Scaffold(
      appBar: AppBar(title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('SiTani', style: TextStyle(color: Colors.white),),
          Image(image: AssetImage('lib/assets/logo.png'), height: 50, width: 50,),
        ],
      ),
        backgroundColor: Color(0xFF018241),
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.productList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildImageSlider(),
            const SizedBox(height: 32),
            _buildSectionHeader(context, 'Produk Unggulan'),
            const SizedBox(height: 16),
            _buildFeaturedProduct(controller, controller.productList.first),
            const SizedBox(height: 32),
            _buildSectionHeader(context, 'Produk Populer'),
            const SizedBox(height: 16),
            _buildPopularItems(controller, controller.productList),
          ],
        );
      }),
    );
  }

  // Method-method build sekarang menerima controller sebagai parameter
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Temukan Produk Segar', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text('Dari Pertanian Terbaik Di Indonesia', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildImageSlider() {
    final List<String> sliderImages = [
      "https://images.unsplash.com/photo-1499529112087-3cb3b73cec95?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1560493676-04071c5f467b?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1464226184884-fa280b87c399?auto=format&fit=crop&w=800&q=80",
    ];
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: sliderImages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(sliderImages[index], fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const Text('See All', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildFeaturedProduct(DashboardController controller, ProductModel product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: InkWell(
        onTap: () => controller.handleisTap(product),
        child: Card(
          color: const Color.fromARGB(255, 216, 248, 220),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(product.imageUrl, height: 120, width: 120, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.error)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 8),
                      Text(product.description, style: TextStyle(color: Colors.grey[600], fontSize: 13), maxLines: 3, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 12),
                      Text('\$${product.price}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPopularItems(DashboardController controller, List<ProductModel> products) {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        itemBuilder: (context, index) {
          final product = products[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () => controller.handleisTap(product),
              child: Card(
                color: const Color.fromARGB(255, 216, 248, 220),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Container(
                  width: 180,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(product.imageUrl, height: 120, width: double.infinity, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.error)),
                      ),
                      const SizedBox(height: 12),
                      Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(product.description, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      const Spacer(),
                      Text('\$${product.price}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}