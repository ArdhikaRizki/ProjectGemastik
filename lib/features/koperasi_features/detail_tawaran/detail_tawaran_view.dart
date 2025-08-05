import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:project_gemastik/features/koperasi_features/tawaran/tawaran_contoller.dart';
import 'package:project_gemastik/features/koperasi_features/tawaran/tawaran_model.dart';
import 'package:project_gemastik/features/petani_features/applying_page/image_fullscreen_view.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:project_gemastik/page_koperasi/detail_tawaran/negosiasi_controller.dart';
class ProductPageController extends GetxController {
  var activeIndex = 0.obs;

  void onPageChanged(int index) {
    activeIndex.value = index;
  }
}

class DetailTawaranView extends StatelessWidget {
  DetailTawaranView({super.key});
  DetailTawaran detailTawaran = Get.arguments;
  final TextEditingController _hargaTawarController = TextEditingController();
  // final hargaController = TextEditingController();
// final negosiasiController = Get.put(NegosiasiController());


  // Helper method untuk membangun indikator
  Widget _buildIndicator(bool isActive) {
    final ProductPageController controller = Get.put(ProductPageController());
    final TawaranContoller controllerTawaran = Get.find<TawaranContoller>();

    _hargaTawarController.text = detailTawaran.catalog.harga.toString();
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
    final TawaranContoller controllerTawaran =
        Get.find<TawaranContoller>();
    // Halaman sebaiknya mengembalikan Scaffold, bukan MaterialApp.
    return Scaffold(
      appBar: AppBar(
        title: Text(detailTawaran.catalog.name.toUpperCase()),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        // Menggunakan SingleChildScrollView agar bisa di-scroll
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CarouselSlider.builder(
                  itemCount: detailTawaran.catalog.imageUrl.length,
                  itemBuilder: (context, index, realIndex) {
                    final url = detailTawaran.catalog.imageUrl[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(
                          () => ImageFullscreenView(
                            imageUrls: List<String>.from(
                              detailTawaran.catalog.imageUrl,
                            ),
                            initialIndex: index,
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        child: Image.network(
                          url,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
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
                      children: List.generate(
                        detailTawaran.catalog.imageUrl.length,
                        (index) {
                          // Bandingkan dengan nilai dari controller.
                          return _buildIndicator(
                            index == controller.activeIndex.value,
                          );
                        },
                      ),
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
                        detailTawaran.catalog.name.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rp ${NumberFormat.decimalPattern('id_ID').format(detailTawaran.catalog.harga)} /kg',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    detailTawaran.catalog.desc,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          detailTawaran.petani.photoUrl,
                        ),
                        radius: 50,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detailTawaran.petani.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          GestureDetector(
                            onTap: () {
                              controllerTawaran.urlWhatsApp(
                                detailTawaran.petani.noTelp,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.green),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(FontAwesomeIcons.whatsapp, color: Colors.green),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Hubungi Petani',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            // Action for Reject Offer button
                            controllerTawaran.rejectOffer(
                              detailTawaran.tawaran.offerId,
                            );
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Tolak Tawaran",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            // Action for Accept Offer button
                            controllerTawaran.acceptOffer(
                              detailTawaran.tawaran.offerId,
                            );
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Terima Tawaran",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 360,
                    child: ElevatedButton(
                      onPressed: () {
                         Get.dialog(
                          AlertDialog(
                            title: const Text('Ajukan Harga Tawar'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Harga awal dari petani: Rp ${NumberFormat.decimalPattern('id_ID').format(detailTawaran.catalog.harga)} /kg',
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _hargaTawarController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Harga Tawar Anda (per kg)',
                                    prefixText: 'Rp ',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text('Batal'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Ambil harga dan kirim negosiasi
                                  final newPrice = int.tryParse(_hargaTawarController.text);
                                  if (newPrice != null && newPrice > 0) {
                                    controllerTawaran.submitNegotiation(
                                      detailTawaran.tawaran.offerId,
                                      newPrice,
                                    );
                                  } else {
                                    Get.snackbar(
                                      "Input Tidak Valid",
                                      "Mohon masukkan angka yang benar.",
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                },
                                child: const Text('Kirim Tawaran'),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Tawar Harga",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
