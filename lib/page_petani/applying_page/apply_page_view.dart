import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Applypageview extends StatelessWidget {
  const Applypageview({super.key});

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
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl.first,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
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

