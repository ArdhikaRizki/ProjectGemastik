import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project_gemastik/page_koperasi/proses_tawaran/proses_tawaran_contollerl.dart';

import '../detail_tawaran/detail_tawaran_view.dart';

class ProsesTawaranView extends StatelessWidget {
  const ProsesTawaranView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProsesTawaranContoller controller = Get.put(ProsesTawaranContoller());
    const Color primaryColor = Color(0xFF018241);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tawaran Masuk'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchIncomingOffers(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: primaryColor));
        }
        if (controller.incomingOffers.isEmpty) {
          return const Center(
            child: Text('Tidak ada tawaran baru saat ini.', style: TextStyle(fontSize: 16, color: Colors.grey)),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12.0),
          itemCount: controller.incomingOffers.length,
          itemBuilder: (context, index) {
            final detailedOffer = controller.incomingOffers[index];

            return InkWell(
              onTap: (){
                Get.to(() => DetailTawaranView(), arguments: detailedOffer);
              },
              child: Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: (detailedOffer.petani.photoUrl.isNotEmpty)
                                ? NetworkImage(detailedOffer.petani.photoUrl)
                                : null,
                            child: (detailedOffer.petani.photoUrl.isEmpty)
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              detailedOffer.petani.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Text(
                        detailedOffer.catalog.name.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: primaryColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Deskripsi: ${detailedOffer.catalog.desc}',
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Harga: Rp ${detailedOffer.catalog.harga}',
                        style: TextStyle(fontSize: 15, color: Colors.grey[700], fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
