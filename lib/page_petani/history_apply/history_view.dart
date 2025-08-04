import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project_gemastik/page_petani/history_apply/history_controller.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HistoryController controller = Get.put(HistoryController());
    const Color primaryColor = Color(0xFF018241);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Tawaran Saya'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchOfferHistory(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: primaryColor));
        }
        if (controller.offerHistoryList.isEmpty) {
          return const Center(
            child: Text('Anda belum memiliki riwayat tawaran.', style: TextStyle(fontSize: 16, color: Colors.grey)),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12.0),
          itemCount: controller.offerHistoryList.length,
          itemBuilder: (context, index) {
            final historyItem = controller.offerHistoryList[index];

            // Tentukan warna dan teks untuk status
            final bool isAccepted = historyItem.offer.status == 'accepted';
            final bool isRejected = historyItem.offer.status == 'rejected';
            final Color statusColor = isAccepted ? Colors.green : isRejected ? Colors.red : Colors.lime;
            final String statusText = isAccepted ? 'Diterima' : isRejected ? 'Ditolak' : 'Proses';

            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // Gambar Produk
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        historyItem.product.imageUrl,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(width: 70, height: 70, color: Colors.grey[200], child: const Icon(Icons.image, color: Colors.grey)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Detail Tawaran
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            historyItem.product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ditawarkan ke: ${historyItem.cooperative.name}',
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Status Tawaran
                    Chip(
                      label: Text(
                        statusText,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: statusColor,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}