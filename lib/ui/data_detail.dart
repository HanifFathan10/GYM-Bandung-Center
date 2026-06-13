import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'data_form.dart';
import 'data_page.dart';
import '../widget/success_dialog.dart';

class DataDetail extends StatelessWidget {
  final int index;
  final String namaGym;
  final String alamat;
  final int hargaMember;
  final String jamOperasional;
  final String imageUrl;

  const DataDetail({
    super.key,
    required this.index,
    required this.namaGym,
    required this.alamat,
    required this.hargaMember,
    required this.jamOperasional,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = const Color(0xFF0F0F11);
    final Color cardColor = const Color(0xFF1E1E22);
    final Color textColor = Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DataForm(
                    index: index,
                    gymData: {
                      'nama': namaGym,
                      'alamat': alamat,
                      'harga': hargaMember,
                      'jam': jamOperasional,
                      'image': imageUrl,
                    },
                  ),
                ),
              ).then((_) => Navigator.pop(context));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: cardColor,
                  title: const Text(
                    'Hapus Data',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: const Text(
                    'Apakah Anda yakin ingin menghapus data gym ini?',
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Batal',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        DataPage.gymList.removeAt(index);
                        Navigator.pop(context);

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => SuccessDialog(
                            message: 'Data GYM berhasil dihapus dari sistem.',
                            onOkPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                      child: const Text(
                        'Ya, Hapus',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            (kIsWeb || imageUrl.startsWith('http'))
                ? Image.network(
                    imageUrl,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(imageUrl),
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

            Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      namaGym,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            Icons.location_on,
                            Colors.redAccent,
                            'Alamat Lokasi',
                            alamat,
                          ),
                          const Divider(
                            color: Colors.white10,
                            height: 30,
                            thickness: 1,
                          ),
                          _buildDetailRow(
                            Icons.access_time_filled,
                            Colors.orange,
                            'Jam Operasional',
                            jamOperasional,
                          ),
                          const Divider(
                            color: Colors.white10,
                            height: 30,
                            thickness: 1,
                          ),
                          _buildDetailRow(
                            Icons.monetization_on,
                            Colors.green,
                            'Biaya Member (Per Bulan)',
                            'Rp $hargaMember',
                            isPrice: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    Color iconColor,
    String title,
    String value, {
    bool isPrice = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: isPrice ? Colors.green : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
