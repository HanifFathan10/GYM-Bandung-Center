import 'package:flutter/material.dart';
import 'data_detail.dart';
import 'data_page.dart';

class DataForm extends StatefulWidget {
  const DataForm({super.key});

  @override
  State<DataForm> createState() => _DataFormState();
}

class _DataFormState extends State<DataForm> {
  final _namaGymController = TextEditingController();
  final _alamatController = TextEditingController();
  final _hargaController = TextEditingController();
  final _jamController = TextEditingController();

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isNumber = false,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          int hargaParsed = int.tryParse(_hargaController.text) ?? 0;

          DataPage.gymList.add({
            'nama': _namaGymController.text,
            'alamat': _alamatController.text,
            'harga': hargaParsed,
            'jam': _jamController.text,
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DataDetail(
                namaGym: _namaGymController.text,
                alamat: _alamatController.text,
                hargaMember: hargaParsed,
                jamOperasional: _jamController.text,
              ),
            ),
          );
        },
        icon: const Icon(Icons.save),
        label: const Text(
          'Simpan Data GYM',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Data GYM'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(
              Icons.add_business_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 10),
            const Text(
              'Masukkan detail gym baru di bawah ini',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            _buildTextField(
              'Nama GYM',
              _namaGymController,
              Icons.fitness_center,
            ),
            _buildTextField('Alamat Lengkap', _alamatController, Icons.map),
            _buildTextField(
              'Harga Member per Bulan',
              _hargaController,
              Icons.payments,
              isNumber: true,
              hint: 'Contoh: 150000',
            ),
            _buildTextField(
              'Jam Operasional',
              _jamController,
              Icons.access_time,
              hint: 'Contoh: 06.00 - 22.00',
            ),
            const SizedBox(height: 20),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }
}
