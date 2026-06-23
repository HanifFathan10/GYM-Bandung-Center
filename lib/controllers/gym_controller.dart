import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../model/data_model.dart';
import 'dart:typed_data';

class GymController {
  static final GymController _instance = GymController._internal();
  factory GymController() => _instance;

  final CollectionReference _gymCollection = FirebaseFirestore.instance
      .collection('gyms');

  final String cloudName = 'dyvlx0mzc';
  final String uploadPreset = 'gym_preset';

  late Stream<List<GymModel>> _gymsStream;

  GymController._internal() {
    _gymsStream = _gymCollection
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return GymModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();
        });
  }

  Stream<List<GymModel>> get gymStream => _gymsStream;

  Stream<List<GymModel>> getGymsStream() {
    return _gymCollection
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return GymModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();
        });
  }

  Future<String?> uploadImageToCloudinary(
    Uint8List imageBytes,
    String fileName,
  ) async {
    try {
      final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );

      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(
          http.MultipartFile.fromBytes('file', imageBytes, filename: fileName),
        );

      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(responseString);
        return jsonMap['secure_url'];
      } else {
        throw Exception(
          "Gagal upload Cloudinary. Status: ${response.statusCode} - $responseString",
        );
      }
    } catch (e) {
      throw Exception("Koneksi Upload Cloudinary gagal: $e");
    }
  }

  Future<void> addGym(
    GymModel gym,
    Uint8List? imageBytes,
    String? fileName,
  ) async {
    if (imageBytes != null && fileName != null) {
      String? uploadedUrl = await uploadImageToCloudinary(imageBytes, fileName);
      gym.imageUrl = uploadedUrl;
    }
    await _gymCollection.add(gym.toMap());
  }

  Future<void> updateGym(
    GymModel gym,
    Uint8List? newImageBytes,
    String? fileName,
  ) async {
    if (newImageBytes != null && fileName != null) {
      String? uploadedUrl = await uploadImageToCloudinary(
        newImageBytes,
        fileName,
      );
      gym.imageUrl = uploadedUrl;
    }
    await _gymCollection.doc(gym.id).update(gym.toMap());
  }

  Future<void> deleteGym(String id) async {
    await _gymCollection.doc(id).delete();
  }
}
