import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// --- LANGKAH 1: BUAT MODEL-MODEL DATA ---

// Model untuk data mentah dari collection 'penawaran'
class OfferData {
  final String offerId;
  final String idKoperasi;
  final String idPetani;
  final String idProduk;
  final String status;

  OfferData({
    required this.offerId,
    required this.idKoperasi,
    required this.idPetani,
    required this.idProduk,
    required this.status,
  });

  factory OfferData.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return OfferData(
      offerId: doc.id,
      idKoperasi: data['IdKoperasi'] ?? '',
      idPetani: data['IdPetani'] ?? '',
      idProduk: data['IdProduk'] ?? '',
      status: data['status'] ?? 'pending',
    );
  }
}

// Model untuk data dari collection 'users' (koperasi)
class CooperativeModel {
  final String name;
  final String photoUrl;

  CooperativeModel({required this.name, required this.photoUrl});

  factory CooperativeModel.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CooperativeModel(
      name: data['name'] ?? 'Koperasi Tidak Dikenal',
      photoUrl: data['urlfoto'] ?? '',
    );
  }
}

// Model untuk data dari collection 'produk_petani'
class ProductModel {
  final String name;
  final String imageUrl; // Asumsi ada field imageUrl di produk

  ProductModel({required this.name, required this.imageUrl});

  factory ProductModel.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    // Ambil gambar pertama dari array imageUrl
    List<String> images = List<String>.from(data['imageUrl'] ?? []);
    return ProductModel(
      name: data['name'] ?? 'Produk Tidak Dikenal',
      imageUrl: images.isNotEmpty ? images.first : '',
    );
  }
}

// Model gabungan untuk ditampilkan di UI
class OfferHistoryModel {
  final OfferData offer;
  final CooperativeModel cooperative;
  final ProductModel product;

  OfferHistoryModel({
    required this.offer,
    required this.cooperative,
    required this.product,
  });
}