// lib/page_koperasi/tawaran/koperasi_proses_tawaran_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'koperasi_proses_tawaran_controller.dart';
import 'negosiasi_model.dart';

class KoperasiProsesTawaranView extends StatefulWidget {
  const KoperasiProsesTawaranView({super.key});

  @override
  State<KoperasiProsesTawaranView> createState() => _KoperasiProsesTawaranViewState();
}

class _KoperasiProsesTawaranViewState extends State<KoperasiProsesTawaranView> {
  final String penawaranId = Get.arguments;
  late final KoperasiProsesTawaranController _controller;
  final _hargaTawarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = Get.put(KoperasiProsesTawaranController(penawaranId: penawaranId));
  }

  @override
  void dispose() {
    _hargaTawarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Proses Tawar Menawar"),
        backgroundColor: const Color(0xFF018241),
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_controller.negotiationHistory.isEmpty) {
          return const Center(child: Text("Belum ada riwayat negosiasi."));
        }

        final latestOffer = _controller.negotiationHistory.first;
        final canReply = latestOffer.penawar == 'petani' && latestOffer.status == 'pending';

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(8.0),
                itemCount: _controller.negotiationHistory.length,
                itemBuilder: (context, index) {
                  final item = _controller.negotiationHistory[index];
                  final isMe = item.penawar == 'koperasi';
                  return ChatBubble(
                    isMe: isMe,
                    message: 'Rp ${NumberFormat.decimalPattern('id_ID').format(item.hargaTawar)} /kg',
                    status: item.status,
                    time: DateFormat('dd MMM yyyy, HH:mm').format(item.timestamp.toDate()),
                  );
                },
              ),
            ),
            if (canReply) _buildActionButtons(context),
          ],
        );
      }),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(children: [
        Expanded(child: OutlinedButton(onPressed: () => _showCounterOfferDialog(context), child: const Text("Tawar Ulang"))),
        const SizedBox(width: 10),
        Expanded(child: ElevatedButton(onPressed: _controller.acceptOffer, child: const Text("Terima Harga"), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF018241), foregroundColor: Colors.white)))
      ]),
    );
  }

  void _showCounterOfferDialog(BuildContext context) {
    final latestPrice = _controller.negotiationHistory.first.hargaTawar;
    _hargaTawarController.text = latestPrice.toString();
    Get.dialog(AlertDialog(
      title: const Text("Ajukan Harga Tawar"),
      content: TextFormField(controller: _hargaTawarController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Harga Tawar Anda (per kg)', prefixText: 'Rp ', border: OutlineInputBorder())),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
        ElevatedButton(onPressed: () {
          final newPrice = int.tryParse(_hargaTawarController.text);
          if (newPrice != null && newPrice > 0) {
            _controller.submitCounterOffer(newPrice);
          }
        }, child: const Text("Kirim"))
      ],
    ));
  }
}

class ChatBubble extends StatelessWidget {
  final bool isMe;
  final String message;
  final String status;
  final String time;

  const ChatBubble({super.key, required this.isMe, required this.message, required this.status, required this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.green.shade100 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(isMe ? "Tawaran Anda" : "Tawaran Petani", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 4),
            Text(message, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text("$status - $time", style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}