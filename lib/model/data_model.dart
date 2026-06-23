import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String nama;
  final String email;

  UserModel({required this.uid, required this.nama, required this.email});

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      uid: documentId,
      nama: data['nama'] ?? 'Member',
      email: data['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'nama': nama, 'email': email};
  }
}

class GymModel {
  String? id;
  String nama;
  String alamat;
  int harga;
  String jam;
  String fasilitas;
  String kontak;

  String? imageUrl;

  GymModel({
    this.id,
    required this.nama,
    required this.alamat,
    required this.harga,
    required this.jam,
    required this.fasilitas,
    required this.kontak,
    this.imageUrl,
  });

  factory GymModel.fromMap(Map<String, dynamic> data, String documentId) {
    return GymModel(
      id: documentId,
      nama: data['nama'] ?? '',
      alamat: data['alamat'] ?? '',
      harga: data['harga']?.toInt() ?? 0,
      jam: data['jam'] ?? '',
      fasilitas: data['fasilitas'] ?? '-',
      kontak: data['kontak'] ?? '-',
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'alamat': alamat,
      'harga': harga,
      'jam': jam,
      'fasilitas': fasilitas,
      'kontak': kontak,
      'imageUrl': imageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
