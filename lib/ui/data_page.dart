import 'package:flutter/material.dart';
import 'data_form.dart';
import 'data_detail.dart';

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  static List<Map<String, dynamic>> gymList = [
    {
      'nama': 'Baleendah Fitness Center',
      'alamat': 'Jl. Siliwangi, Baleendah',
      'harga': 150000,
      'jam': '06.00 - 21.00',
    },
    {
      'nama': 'Boomerang Gym Bojongsoang',
      'alamat': 'Kawasan Ciganitri',
      'harga': 120000,
      'jam': '07.00 - 22.00',
    },
    {
      'nama': 'Dayeuhkolot Muscle Studio',
      'alamat': 'Jl. Raya Dayeuhkolot',
      'harga': 100000,
      'jam': '06.00 - 21.00',
    },
    {
      'nama': 'Metro Margahayu Fit',
      'alamat': 'Metro Indah',
      'harga': 250000,
      'jam': '06.00 - 23.00',
    },
    {
      'nama': 'Soreang Gym Center',
      'alamat': 'Dekat Pemda Soreang',
      'harga': 175000,
      'jam': '08.00 - 20.00',
    },
  ];

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar GYM Bandung',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 10, bottom: 80),
        itemCount: DataPage.gymList.length,
        itemBuilder: (context, index) {
          final data = DataPage.gymList[index];
          return ItemGym(
            namaGym: data['nama'],
            alamat: data['alamat'],
            hargaMember: data['harga'],
            jamOperasional: data['jam'],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DataForm()),
          ).then((_) => setState(() {}));
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah GYM'),
      ),
    );
  }
}

class ItemGym extends StatelessWidget {
  final String namaGym;
  final String alamat;
  final int hargaMember;
  final String jamOperasional;

  const ItemGym({
    super.key,
    required this.namaGym,
    required this.alamat,
    required this.hargaMember,
    required this.jamOperasional,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.fitness_center,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          namaGym,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            children: [
              const Icon(Icons.location_on, size: 14, color: Color(0xD32F2F)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  alamat,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Member',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
            Text(
              'Rp ${hargaMember / 1000}K',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DataDetail(
                namaGym: namaGym,
                alamat: alamat,
                hargaMember: hargaMember,
                jamOperasional: jamOperasional,
              ),
            ),
          );
        },
      ),
    );
  }
}
