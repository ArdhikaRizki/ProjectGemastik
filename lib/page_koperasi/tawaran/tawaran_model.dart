import 'package:cloud_firestore/cloud_firestore.dart';

class TawaranModel {
  final String offerId;
  final String idKoperasi;
  final String idPetani;
  final String idProduk;
  final String status;

  TawaranModel({
    required this.offerId,
    required this.idKoperasi,
    required this.idPetani,
    required this.idProduk,
    required this.status,
  });

  factory TawaranModel.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TawaranModel(
      offerId: doc.id,
      idKoperasi: data['IdKoperasi'] ?? '',
      idPetani: data['IdPetani'] ?? '',
      idProduk: data['IdProduk'] ?? '',
      status: data['status'] ?? 'pending',
    );
  }
}

// Model untuk data dari collection 'users' (petani)
class DataPetani {
  final String name;
  final String photoUrl;
  final String noTelp;

  DataPetani({required this.name, required this.photoUrl, required this.noTelp});

  factory DataPetani.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return DataPetani(
      name: data['name'] ?? 'Petani Tidak Dikenal',
      photoUrl: data['urlfoto'] ?? '',
      noTelp: data['phoneNumber'] ?? '',
    );
  }
}

// Model untuk data dari collection 'produk_petani'
class DataCatalog {
  final String docId;
  final String name;
  final String desc;
  final int harga;
  final List<dynamic> imageUrl; // Tambahkan field imageUrl jika diperlukan
  // Tambahkan field lain jika perlu

  DataCatalog({required this.docId ,required this.name, required this.desc, required this.harga, required this.imageUrl});

  factory DataCatalog.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return DataCatalog(
      docId: doc.id, // Ambil ID dokumen
      name: data['name'] ?? 'Produk Tidak Dikenal',
      desc: data['desc'] ?? '',
      harga: data['harga'] ?? 0,
      imageUrl: data['imageUrl'] ?? [], // Tambahkan imageUrl jika diperlukan
    );
  }
}

// Model gabungan untuk ditampilkan di UI
class DetailTawaran {
  final TawaranModel tawaran;
  final DataPetani petani;
  final DataCatalog catalog;

  DetailTawaran({
    required this.tawaran,
    required this.petani,
    required this.catalog,
  });
}