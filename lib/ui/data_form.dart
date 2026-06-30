import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../model/data_model.dart';
import '../controllers/gym_controller.dart';

class DataForm extends StatefulWidget {
  final GymModel? gymData;

  const DataForm({super.key, this.gymData});

  @override
  State<DataForm> createState() => _DataFormState();
}

class _DataFormState extends State<DataForm> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _hargaController = TextEditingController();
  final _jamBukaController = TextEditingController();
  final _jamTutupController = TextEditingController();
  final _fasilitasController = TextEditingController();
  final _kontakController = TextEditingController();

  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  bool _isLoading = false;

  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  static const _bg = Color(0xFF0D0D12);
  static const _accent = Color(0xFFFF5C3A);
  static const _teal = Color(0xFF00D9B8);
  static const _gold = Color(0xFFFFB547);
  static const _textPrimary = Color(0xFFF0F0F5);
  static const _textSub = Color(0xFF888899);

  bool get _isEditing => widget.gymData != null;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();

    if (_isEditing) {
      _namaController.text = widget.gymData!.nama;
      _alamatController.text = widget.gymData!.alamat;
      _hargaController.text = widget.gymData!.harga.toString();
      _fasilitasController.text = widget.gymData!.fasilitas;
      _kontakController.text = widget.gymData!.kontak;

      final jamUtuh = widget.gymData!.jam;
      if (jamUtuh.contains(' - ')) {
        final splitJam = jamUtuh.split(' - ');
        _jamBukaController.text = splitJam[0];
        _jamTutupController.text = splitJam[1];
      } else {
        _jamBukaController.text = jamUtuh;
      }
    }
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _namaController.dispose();
    _alamatController.dispose();
    _hargaController.dispose();
    _jamBukaController.dispose();
    _jamTutupController.dispose();
    _fasilitasController.dispose();
    _kontakController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    HapticFeedback.selectionClick();
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
          _selectedImageName = pickedFile.name;
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);

    final cleanHarga = _hargaController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final hargaParsed = int.tryParse(cleanHarga) ?? 0;
    final jamGabungan =
        '${_jamBukaController.text} - ${_jamTutupController.text}';

    final gym = GymModel(
      id: widget.gymData?.id,
      nama: _namaController.text,
      alamat: _alamatController.text,
      harga: hargaParsed,
      jam: jamGabungan,
      fasilitas: _fasilitasController.text,
      kontak: _kontakController.text,
      imageUrl: widget.gymData?.imageUrl,
    );

    try {
      if (!_isEditing) {
        await GymController().addGym(
          gym,
          _selectedImageBytes,
          _selectedImageName,
        );
      } else {
        await GymController().updateGym(
          gym,
          _selectedImageBytes,
          _selectedImageName,
        );
      }
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _selectTime(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFF5C3A),
              surface: Color(0xFF1E1E2A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        controller.text =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: _textPrimary),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEditing ? 'Edit Gym' : 'Tambah Gym',
              style: const TextStyle(
                color: _textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              _isEditing ? 'Perbarui informasi gym' : 'Lengkapi data gym baru',
              style: const TextStyle(
                color: _textSub,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? _buildLoadingState()
          : FadeTransition(
              opacity: _fadeAnim,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ImagePicker(
                        imageBytes: _selectedImageBytes,
                        networkUrl: widget.gymData?.imageUrl,
                        onTap: _pickImage,
                      ),

                      const SizedBox(height: 28),

                      const _SectionLabel(label: 'Identitas Gym'),
                      const SizedBox(height: 12),

                      _FormCard(
                        children: [
                          _FormField(
                            label: 'Nama GYM',
                            controller: _namaController,
                            icon: Icons.fitness_center_rounded,
                            iconColor: _accent,
                            textInputAction: TextInputAction.next,
                          ),
                          _FormField(
                            label: 'Alamat Lengkap',
                            hint: 'Masukkan alamat lengkap...',
                            controller: _alamatController,
                            icon: Icons.location_on_rounded,
                            iconColor: Colors.redAccent,
                            maxLines: 2,
                            textInputAction: TextInputAction.next,
                          ),
                          _FormField(
                            label: 'Nomor Kontak / WA',
                            controller: _kontakController,
                            icon: Icons.phone_rounded,
                            iconColor: _teal,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            isLast: true,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      const _SectionLabel(label: 'Operasional'),
                      const SizedBox(height: 12),

                      _FormCard(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _FormField(
                                  label: 'Jam Buka',
                                  hint: '06:00',
                                  controller: _jamBukaController,
                                  icon: Icons.access_time_rounded,
                                  iconColor: _gold,
                                  readOnly: true,
                                  onTap: () =>
                                      _selectTime(context, _jamBukaController),
                                  isLast: true,
                                ),
                              ),
                              // Garis pemisah vertikal di tengah
                              Container(
                                width: 1,
                                height: 40,
                                color: const Color(0xFF252532),
                              ),
                              Expanded(
                                child: _FormField(
                                  label: 'Jam Tutup',
                                  hint: '22:00',
                                  controller: _jamTutupController,
                                  icon: Icons.access_time_filled_rounded,
                                  iconColor: _gold,
                                  readOnly: true,
                                  onTap: () =>
                                      _selectTime(context, _jamTutupController),
                                  isLast: true,
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            height: 1,
                            color: Color(0xFF252532),
                            indent: 16,
                            endIndent: 16,
                          ),
                          _FormField(
                            label: 'Fasilitas',
                            hint:
                                'Contoh:\n- Loker & Shower\n- Area Angkat Beban\n- Kelas Zumba',
                            controller: _fasilitasController,
                            icon: Icons.star_rounded,
                            iconColor: _accent,
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                          ),
                          _FormField(
                            label: 'Harga Member / Bulan',
                            hint: 'Contoh: 250000',
                            controller: _hargaController,
                            icon: Icons.monetization_on_rounded,
                            iconColor: Colors.blueAccent,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            isLast: true,
                            prefix: 'Rp ',
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      _SaveButton(
                        label: _isEditing ? 'Perbarui Data' : 'Simpan Data',
                        onPressed: _saveData,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(color: _accent, strokeWidth: 3),
          ),
          const SizedBox(height: 16),
          Text(
            _isEditing ? 'Memperbarui data...' : 'Menyimpan data...',
            style: const TextStyle(color: _textSub, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _ImagePicker extends StatelessWidget {
  final Uint8List? imageBytes;
  final String? networkUrl;
  final VoidCallback onTap;

  const _ImagePicker({
    required this.imageBytes,
    required this.networkUrl,
    required this.onTap,
  });

  static const _accent = Color(0xFFFF5C3A);
  static const _surface = Color(0xFF16161F);
  static const _textSub = Color(0xFF888899);

  bool get _hasImage =>
      imageBytes != null || (networkUrl != null && networkUrl!.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _hasImage
                ? _accent.withOpacity(0.4)
                : const Color(0xFF252532),
          ),
          image: imageBytes != null
              ? DecorationImage(
                  image: MemoryImage(imageBytes!),
                  fit: BoxFit.cover,
                )
              : (networkUrl != null && networkUrl!.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(networkUrl!),
                        fit: BoxFit.cover,
                      )
                    : null),
        ),
        child: _hasImage
            ? Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.55),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 14,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.camera_alt_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Ganti Foto',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _accent.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: _accent.withOpacity(0.25)),
                    ),
                    child: const Icon(
                      Icons.add_a_photo_rounded,
                      color: _accent,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Upload Foto GYM',
                    style: TextStyle(
                      color: _textSub,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Tap untuk memilih foto',
                    style: TextStyle(color: Color(0xFF555566), fontSize: 12),
                  ),
                ],
              ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 15,
          decoration: BoxDecoration(
            color: const Color(0xFFFF5C3A),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 9),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFF0F0F5),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _FormCard extends StatelessWidget {
  final List<Widget> children;
  const _FormCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16161F),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF252532)),
      ),
      child: Column(children: children),
    );
  }
}

class _FormField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final IconData icon;
  final Color iconColor;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int maxLines;
  final bool isLast;
  final String? prefix;
  final Widget? suffixIcon;

  final bool readOnly;
  final VoidCallback? onTap;

  const _FormField({
    required this.label,
    required this.controller,
    required this.icon,
    required this.iconColor,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.isLast = false,
    this.prefix,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
  });

  @override
  State<_FormField> createState() => _FormFieldState();
}

class _FormFieldState extends State<_FormField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Focus(
          onFocusChange: (f) => setState(() => _focused = f),
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            maxLines: widget.maxLines,
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            style: const TextStyle(color: Color(0xFFF0F0F5), fontSize: 15),
            validator: (val) =>
                val == null || val.trim().isEmpty ? 'Tidak boleh kosong' : null,
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hint,
              hintStyle: const TextStyle(
                color: Color(0xFF444455),
                fontSize: 13,
              ),
              labelStyle: TextStyle(
                color: _focused
                    ? const Color(0xFFFF5C3A)
                    : const Color(0xFF888899),
                fontSize: 13,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16, right: 12),
                child: Icon(
                  widget.icon,
                  color: _focused ? widget.iconColor : const Color(0xFF555566),
                  size: 20,
                ),
              ),
              prefixText: widget.prefix,
              prefixStyle: const TextStyle(
                color: Color(0xFF888899),
                fontSize: 15,
              ),
              suffixIcon: widget.suffixIcon,
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              errorStyle: const TextStyle(
                color: Colors.redAccent,
                fontSize: 11,
              ),
            ),
          ),
        ),
        if (!widget.isLast)
          const Divider(
            height: 1,
            color: Color(0xFF252532),
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}

class _SaveButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _SaveButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF5C3A),
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_rounded, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
