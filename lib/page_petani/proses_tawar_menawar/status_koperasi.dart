// lib/page_petani/applying_page/status_koperasi_model.dart

import '../../LoginRegister/UserModel.dart';

class StatusKoperasi {
  final UserModel koperasi;
  final bool hasBeenOffered;
  final String? penawaranId; // Tambahkan properti ini

  StatusKoperasi({
    required this.koperasi,
    required this.hasBeenOffered,
    this.penawaranId, // Jadikan opsional
  });
}