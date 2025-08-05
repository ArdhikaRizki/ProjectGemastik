import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_gemastik/features/authtentications/UserModel.dart';

class Model_Catalog {
  final String docId; // ID unik dari dokumen di Firestore
  final String uid; // UID dari pengguna yang membuat produk
  final List<String> imageUrl;
  final String name;
  final String desc;
  final int harga; // Tipe data diubah menjadi int

  Model_Catalog({
    required this.docId,
    required this.uid,
    required this.imageUrl,
    required this.name,
    required this.desc,
    required this.harga, // Nama field diubah menjadi harga
  });

  // Factory constructor yang sudah diperbaiki dan lebih aman
  factory Model_Catalog.fromSnapshot(DocumentSnapshot doc) {
    // Ambil data sebagai Map
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Lakukan pengecekan null yang aman dengan nilai default
    return Model_Catalog(
      docId: doc.id, // Ambil ID dokumen
      uid: data['uid'] ?? '', // Ambil uid dari field 'uid'
      // Konversi List<dynamic> menjadi List<String> dengan aman
      imageUrl: List<String>.from(data['imageUrl'] ?? []),
      name: data['name'] ?? 'Tanpa Nama',
      desc: data['desc'] ?? 'Tanpa Deskripsi',
      harga: data['harga'] ?? 0, // Ambil harga dari field 'harga'
    );
  }

  // Method toJson untuk mengirim data ke Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'imageUrl': imageUrl,
      'name': name,
      'desc': desc,
      'harga': harga, // Nama field diubah menjadi harga
    };
  }
}

class StatusKoperasi {
  final UserModel koperasi;
  final bool hasBeenOffered;

  StatusKoperasi({
    required this.koperasi,
    required this.hasBeenOffered,
  });
}
