// lib/page_koperasi/tawaran/tawaran_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_gemastik/page_koperasi/detail_tawaran/detail_tawaran_view.dart';
import 'package:project_gemastik/page_koperasi/tawaran/tawaran_contoller.dart';
import 'package:project_gemastik/page_koperasi/tawaran/tawaran_model.dart';
// Import halaman proses tawaran yang akan kita buat
import 'koperasi_proses_tawaran_view.dart';

class TawaranView extends StatefulWidget {
  const TawaranView({super.key});

  @override
  State<TawaranView> createState() => _TawaranViewState();
}

class _TawaranViewState extends State<TawaranView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TawaranContoller controller = Get.put(TawaranContoller());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF018241);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Tawaran'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchAllOffers(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.amber,
          tabs: const [
            Tab(text: 'Tawaran Baru'),
            Tab(text: 'Dinegosiasi'),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: primaryColor));
        }
        return TabBarView(
          controller: _tabController,
          children: [
            // Tab 1: Menampilkan tawaran 'pending'
            buildOfferList(controller.incomingOffers, isNegotiating: false),
            // Tab 2: Menampilkan tawaran 'negotiating'
            buildOfferList(controller.negotiatingOffers, isNegotiating: true),
          ],
        );
      }),
    );
  }

  Widget buildOfferList(List<DetailTawaran> offers, {required bool isNegotiating}) {
    if (offers.isEmpty) {
      return Center(
        child: Text(
          isNegotiating ? 'Tidak ada tawaran yang sedang dinegosiasi.' : 'Tidak ada tawaran baru saat ini.',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: offers.length,
      itemBuilder: (context, index) {
        final detailedOffer = offers[index];
        return InkWell(
          onTap: () {
            if (isNegotiating) {
              // Jika dinegosiasi, buka halaman chat
              Get.to(() => const KoperasiProsesTawaranView(), arguments: detailedOffer.tawaran.offerId);
            } else {
              // Jika baru, buka halaman detail biasa
              Get.to(() => DetailTawaranView(), arguments: detailedOffer);
            }
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
                           if (isNegotiating)
                             const Icon(Icons.chat_bubble_outline, color: Colors.blue, size: 20,)
                        ],
                      ),
                      const Divider(height: 24),
                      Text(
                        detailedOffer.catalog.name.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF018241)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Harga Awal: Rp ${NumberFormat.decimalPattern('id_ID').format(detailedOffer.catalog.harga)} /kg',
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}