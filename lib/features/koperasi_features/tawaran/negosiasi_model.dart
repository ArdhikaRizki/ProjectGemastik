// lib/page_koperasi/tawaran/negosiasi_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class NegosiasiModel {
  final String id;
  final int hargaTawar;
  final String penawar;
  final String status;
  final Timestamp timestamp;

  NegosiasiModel({
    required this.id,
    required this.hargaTawar,
    required this.penawar,
    required this.status,
    required this.timestamp,
  });

  factory NegosiasiModel.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return NegosiasiModel(
      id: doc.id,
      hargaTawar: data['hargaTawar'] ?? 0,
      penawar: data['penawar'] ?? '',
      status: data['status'] ?? 'pending',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}