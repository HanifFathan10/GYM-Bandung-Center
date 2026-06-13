import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
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
      'image':
          'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=1470&auto=format&fit=crop',
    },
    {
      'nama': 'Boomerang Gym Bojongsoang',
      'alamat': 'Kawasan Ciganitri',
      'harga': 120000,
      'jam': '07.00 - 22.00',
      'image':
          'https://images.unsplash.com/photo-1540497077202-7c8a3999166f?q=80&w=1470&auto=format&fit=crop',
    },
    {
      'nama': 'Dayeuhkolot Muscle Studio',
      'alamat': 'Jl. Raya Dayeuhkolot',
      'harga': 100000,
      'jam': '06.00 - 21.00',
      'image':
          'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?q=80&w=1470&auto=format&fit=crop',
    },
    {
      'nama': 'Metro Margahayu Fit',
      'alamat': 'Metro Indah',
      'harga': 250000,
      'jam': '06.00 - 23.00',
      'image':
          'https://images.unsplash.com/photo-1558611848-73f7eb4001a1?q=80&w=1471&auto=format&fit=crop',
    },
    {
      'nama': 'Soreang Gym Center',
      'alamat': 'Dekat Pemda Soreang',
      'harga': 175000,
      'jam': '08.00 - 20.00',
      'image':
          'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=1470&auto=format&fit=crop',
    },
  ];

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  final Color _bgColor = const Color(0xFF0F0F11);
  final Color _textColor = Colors.white;
  final Color _inputColor = const Color(0xFF1E1E22);

  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _filteredGymList = [];

  @override
  void initState() {
    super.initState();
    _filteredGymList = List.from(DataPage.gymList);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterData(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredGymList = List.from(DataPage.gymList);
      } else {
        _filteredGymList = DataPage.gymList.where((gym) {
          final String namaGym = gym['nama'].toString().toLowerCase();
          final String alamat = gym['alamat'].toString().toLowerCase();
          final String keyword = query.toLowerCase();

          return namaGym.contains(keyword) || alamat.contains(keyword);
        }).toList();
      }
    });
  }

  void _refreshList() {
    setState(() {
      _filterData(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: _textColor),
        centerTitle: true,
        title: Text(
          'Daftar GYM',
          style: TextStyle(color: _textColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: TextField(
              controller: _searchController,
              onChanged: _filterData,
              style: TextStyle(color: _textColor),
              decoration: InputDecoration(
                hintText: 'Cari nama atau lokasi gym...',
                hintStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey.shade500),
                        onPressed: () {
                          _searchController.clear();
                          _filterData('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: _inputColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          Expanded(
            child: _filteredGymList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 80,
                          color: Colors.grey.shade700,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Pencarian tidak ditemukan',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 80,
                      left: 20,
                      right: 20,
                    ),
                    itemCount: _filteredGymList.length,
                    itemBuilder: (context, index) {
                      final data = _filteredGymList[index];

                      final int originalIndex = DataPage.gymList.indexOf(data);

                      return ItemGym(
                        index: originalIndex,
                        namaGym: data['nama'],
                        alamat: data['alamat'],
                        hargaMember: data['harga'],
                        jamOperasional: data['jam'],
                        imageUrl:
                            data['image'] ??
                            'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=1470&auto=format&fit=crop',
                        onUpdate: _refreshList,
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DataForm()),
          ).then((_) => _refreshList());
        },
        icon: const Icon(Icons.add),
        label: const Text(
          'Tambah GYM',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ItemGym extends StatelessWidget {
  final int index;
  final String namaGym;
  final String alamat;
  final int hargaMember;
  final String jamOperasional;
  final String imageUrl;
  final VoidCallback onUpdate;

  const ItemGym({
    super.key,
    required this.index,
    required this.namaGym,
    required this.alamat,
    required this.hargaMember,
    required this.jamOperasional,
    required this.imageUrl,
    required this.onUpdate,
  });

  Widget _buildErrorImage() {
    return Container(
      height: 180,
      width: double.infinity,
      color: Colors.grey.shade800,
      child: const Icon(Icons.broken_image, color: Colors.white54, size: 50),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color cardColor = const Color(0xFF1E1E22);
    final Color subTextColor = Colors.grey.shade400;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DataDetail(
                  index: index,
                  namaGym: namaGym,
                  alamat: alamat,
                  hargaMember: hargaMember,
                  jamOperasional: jamOperasional,
                  imageUrl: imageUrl,
                ),
              ),
            ).then((_) => onUpdate());
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  (kIsWeb || imageUrl.startsWith('http'))
                      ? Image.network(
                          imageUrl,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildErrorImage(),
                        )
                      : Image.file(
                          File(imageUrl),
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildErrorImage(),
                        ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Rp ${hargaMember / 1000}K / Bln',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      namaGym,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.redAccent.shade100,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            alamat,
                            style: TextStyle(color: subTextColor, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_filled,
                          size: 16,
                          color: Colors.orange.shade300,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          jamOperasional,
                          style: TextStyle(color: subTextColor, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
