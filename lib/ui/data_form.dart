import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'data_page.dart';
import '../widget/success_dialog.dart';
import '../widget/warning_dialog.dart';

class DataForm extends StatefulWidget {
  final int? index;
  final Map<String, dynamic>? gymData;

  const DataForm({super.key, this.index, this.gymData});

  @override
  State<DataForm> createState() => _DataFormState();
}

class _DataFormState extends State<DataForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaGymController = TextEditingController();
  final _alamatController = TextEditingController();
  final _hargaController = TextEditingController();
  final _jamController = TextEditingController();

  String? _imagePath;

  final Color _bgColor = const Color(0xFF0F0F11);
  final Color _inputColor = const Color(0xFF1E1E22);
  final Color _textColor = Colors.white;
  final Color _subTextColor = Colors.grey.shade500;

  @override
  void initState() {
    super.initState();
    if (widget.gymData != null) {
      _namaGymController.text = widget.gymData!['nama'];
      _alamatController.text = widget.gymData!['alamat'];
      _hargaController.text = widget.gymData!['harga'].toString();
      _jamController.text = widget.gymData!['jam'];
      _imagePath = widget.gymData!['image'];
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isNumber = false,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: _textColor),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) => (value == null || value.trim().isEmpty)
            ? '$label tidak boleh kosong'
            : null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(color: _subTextColor),
          hintStyle: TextStyle(color: Colors.grey.shade700),
          prefixIcon: Icon(icon, color: _subTextColor),
          filled: true,
          fillColor: _inputColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          errorStyle: const TextStyle(color: Colors.redAccent),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 200,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: _inputColor,
          borderRadius: BorderRadius.circular(16),
          image: _imagePath != null
              ? DecorationImage(
                  image: (kIsWeb || _imagePath!.startsWith('http'))
                      ? NetworkImage(_imagePath!) as ImageProvider
                      : FileImage(File(_imagePath!)),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _imagePath == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo,
                    size: 50,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tap untuk Upload Gambar',
                    style: TextStyle(color: _subTextColor),
                  ),
                ],
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.black.withOpacity(
                    0.4,
                  ), // Overlay gelap agar icon kamera terlihat
                ),
                child: const Icon(
                  Icons.cameraswitch_rounded,
                  size: 40,
                  color: Colors.white70,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: _textColor),
        centerTitle: true,
        title: Text(
          widget.index != null ? 'Edit GYM' : 'Tambah GYM',
          style: TextStyle(color: _textColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildImagePicker(),

              _buildTextField(
                'Nama GYM',
                _namaGymController,
                Icons.fitness_center,
              ),
              _buildTextField(
                'Alamat Lengkap',
                _alamatController,
                Icons.map_outlined,
              ),
              _buildTextField(
                'Harga Member',
                _hargaController,
                Icons.payments_outlined,
                isNumber: true,
                hint: 'Contoh: 150000',
              ),
              _buildTextField(
                'Jam Operasional',
                _jamController,
                Icons.access_time_rounded,
                hint: 'Contoh: 06.00 - 22.00',
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      int hargaParsed =
                          int.tryParse(_hargaController.text) ?? 0;

                      Map<String, dynamic> newData = {
                        'nama': _namaGymController.text,
                        'alamat': _alamatController.text,
                        'harga': hargaParsed,
                        'jam': _jamController.text,
                        'image':
                            _imagePath ??
                            'https://images.unsplash.com/photo-1593079831268-3381b0c023d6?q=80&w=1469&auto=format&fit=crop',
                      };

                      if (widget.index != null) {
                        DataPage.gymList[widget.index!] = newData;
                      } else {
                        DataPage.gymList.add(newData);
                      }

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => SuccessDialog(
                          message: widget.index != null
                              ? 'Data GYM berhasil diperbarui!'
                              : 'Data GYM baru berhasil ditambahkan!',
                          onOkPressed: () => Navigator.pop(context),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => const WarningDialog(
                          message: 'Semua kolom wajib diisi!',
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Simpan Data',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
