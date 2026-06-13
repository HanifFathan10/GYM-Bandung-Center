class GymController {
  // Singleton Pattern
  static final GymController _instance = GymController._internal();
  factory GymController() => _instance;
  GymController._internal();

  // Data tersentralisasi di Controller (Model data sementara)
  final List<Map<String, dynamic>> _gymList = [
    {
      'nama': 'Baleendah Fitness Center',
      'alamat': 'Jl. Siliwangi, Baleendah',
      'harga': 150000,
      'jam': '06.00 - 21.00',
      'image':
          'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=1470&auto=format&fit=crop',
    },
    // ... (Masukkan sisa data dummy kamu di sini)
    {
      'nama': 'Soreang Gym Center',
      'alamat': 'Dekat Pemda Soreang',
      'harga': 175000,
      'jam': '08.00 - 20.00',
      'image':
          'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=1470&auto=format&fit=crop',
    },
  ];

  // Mengambil semua data
  List<Map<String, dynamic>> getAllGyms() {
    return _gymList;
  }

  // Menambah data
  void addGym(Map<String, dynamic> newData) {
    _gymList.add(newData);
  }

  // Memperbarui data
  void updateGym(int index, Map<String, dynamic> updatedData) {
    _gymList[index] = updatedData;
  }

  // Menghapus data
  void deleteGym(int index) {
    _gymList.removeAt(index);
  }

  // Logika Pencarian (Search)
  List<Map<String, dynamic>> searchGym(String query) {
    if (query.isEmpty) return List.from(_gymList);

    return _gymList.where((gym) {
      final String namaGym = gym['nama'].toString().toLowerCase();
      final String alamat = gym['alamat'].toString().toLowerCase();
      final String keyword = query.toLowerCase();
      return namaGym.contains(keyword) || alamat.contains(keyword);
    }).toList();
  }

  // Mendapatkan index asli (diperlukan untuk fungsi search)
  int getOriginalIndex(Map<String, dynamic> gymItem) {
    return _gymList.indexOf(gymItem);
  }
}
