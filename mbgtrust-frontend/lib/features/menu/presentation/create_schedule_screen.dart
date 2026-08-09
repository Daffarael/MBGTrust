import 'package:flutter/material.dart';
import '../../../core/constants/mock_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../production/presentation/widgets/sppg_admin_layout.dart';

class CreateScheduleScreen extends StatefulWidget {
  final List<Map<String, dynamic>>? availableMenus;

  const CreateScheduleScreen({
    super.key,
    this.availableMenus,
  });

  @override
  State<CreateScheduleScreen> createState() => _CreateScheduleScreenState();
}

class _CreateScheduleScreenState extends State<CreateScheduleScreen> {
  // Form State
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1)); // Default H+1 (Besok)
  String? _selectedMenuId;
  String _selectedDeadlineTime = '17:00 WIB (Standar SPPG)';
  final TextEditingController _portionController =
      TextEditingController(text: '450');
  final TextEditingController _searchHistoryController =
      TextEditingController();

  late List<Map<String, dynamic>> _menuList;
  late List<Map<String, dynamic>> _scheduleHistory;
  String _historyQuery = '';

  int? _editingIndex; // Null if adding new, or index if editing

  final List<String> _deadlineOptions = [
    '15:00 WIB',
    '16:00 WIB',
    '17:00 WIB (Standar SPPG)',
    '18:00 WIB',
    '19:00 WIB',
  ];

  @override
  void initState() {
    super.initState();
    _menuList = widget.availableMenus ?? List.from(MockData.foodMenuList);

    if (_menuList.isNotEmpty) {
      _selectedMenuId = _menuList.first['id'] ?? _menuList.first['id_menu'];
    }

    // Full Schedule History Data
    _scheduleHistory = [
      {
        'id': 'sch_01',
        'tanggal': DateTime.now().add(const Duration(days: 1)),
        'nama_menu': 'Nasi Ayam Bakar Kecap & Tumis Buncis',
        'kategori': 'MAKANAN_BERAT',
        'kalori': '550 kcal',
        'target_porsi': 450,
        'batas_waktu': '17:00 WIB',
        'status': 'BELUM_BERJALAN', // Can be edited by SPPG
        'kepuasan': '96.5%',
        'rasa': '4.8 / 5.0',
      },
      {
        'id': 'sch_02',
        'tanggal': DateTime.now(),
        'nama_menu': 'Nasi Daging Sapi Lada Hitam & Capcay',
        'kategori': 'MAKANAN_BERAT',
        'kalori': '620 kcal',
        'target_porsi': 450,
        'batas_waktu': '17:00 WIB',
        'status': 'SEDANG_BERJALAN', // Locked
        'kepuasan': '94.0%',
        'rasa': '4.7 / 5.0',
      },
      {
        'id': 'sch_03',
        'tanggal': DateTime.now().subtract(const Duration(days: 1)),
        'nama_menu': 'Nasi Ikan Gurame Asam Manis & Sup Sayur',
        'kategori': 'MAKANAN_BERAT',
        'kalori': '580 kcal',
        'target_porsi': 440,
        'batas_waktu': '17:00 WIB',
        'status': 'SELESAI', // Locked
        'kepuasan': '91.8%',
        'rasa': '4.6 / 5.0',
      },
      {
        'id': 'sch_04',
        'tanggal': DateTime.now().subtract(const Duration(days: 2)),
        'nama_menu': 'Nasi Telur Balado & Sayur Asem',
        'kategori': 'MAKANAN_BERAT',
        'kalori': '510 kcal',
        'target_porsi': 445,
        'batas_waktu': '17:00 WIB',
        'status': 'SELESAI', // Locked
        'kepuasan': '88.5%',
        'rasa': '4.4 / 5.0',
      },
      {
        'id': 'sch_05',
        'tanggal': DateTime.now().subtract(const Duration(days: 3)),
        'nama_menu': 'Nasi Ayam Goreng Lengkuas & Lalapan',
        'kategori': 'MAKANAN_BERAT',
        'kalori': '560 kcal',
        'target_porsi': 450,
        'batas_waktu': '17:00 WIB',
        'status': 'SELESAI', // Locked
        'kepuasan': '85.0%',
        'rasa': '4.3 / 5.0',
      },
    ];
  }

  @override
  void dispose() {
    _portionController.dispose();
    _searchHistoryController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    const days = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu'
    ];
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    final dayName = days[date.weekday % 7];
    final monthName = months[date.month - 1];
    return '$dayName, ${date.day} $monthName ${date.year}';
  }

  bool _isTomorrowScheduled() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return _scheduleHistory.any((item) {
      final DateTime dt = item['tanggal'];
      return dt.year == tomorrow.year &&
          dt.month == tomorrow.month &&
          dt.day == tomorrow.day;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitSchedule() {
    if (_selectedMenuId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih menu makanan terlebih dahulu.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final selectedMenuObj = _menuList.firstWhere(
      (m) => (m['id'] ?? m['id_menu']) == _selectedMenuId,
      orElse: () => _menuList.first,
    );

    final namaMenu =
        selectedMenuObj['nama_menu'] ?? selectedMenuObj['name'] ?? 'Menu Pilihan';
    final kalori =
        '${selectedMenuObj['kalori_kkal'] ?? selectedMenuObj['calories'] ?? 500} kcal';
    final targetPorsi = int.tryParse(_portionController.text.trim()) ?? 450;

    setState(() {
      if (_editingIndex != null && _editingIndex! < _scheduleHistory.length) {
        _scheduleHistory[_editingIndex!] = {
          ..._scheduleHistory[_editingIndex!],
          'tanggal': _selectedDate,
          'nama_menu': namaMenu,
          'kalori': kalori,
          'target_porsi': targetPorsi,
          'batas_waktu': _selectedDeadlineTime,
        };
        _editingIndex = null;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Jadwal menu "$namaMenu" untuk ${_formatDate(_selectedDate)} berhasil diperbarui!'),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        _scheduleHistory.insert(0, {
          'id': 'sch_${DateTime.now().millisecondsSinceEpoch}',
          'tanggal': _selectedDate,
          'nama_menu': namaMenu,
          'kategori': selectedMenuObj['kategori'] ?? 'MAKANAN_BERAT',
          'kalori': kalori,
          'target_porsi': targetPorsi,
          'batas_waktu': _selectedDeadlineTime,
          'status': 'BELUM_BERJALAN',
          'kepuasan': 'Belum Ada Ulasan',
          'rasa': '4.8 / 5.0',
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Jadwal menu "$namaMenu" untuk ${_formatDate(_selectedDate)} berhasil dipublikasikan!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    });
  }

  void _editSchedule(int index) {
    final item = _scheduleHistory[index];
    if (item['status'] != 'BELUM_BERJALAN') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Jadwal yang sedang berjalan atau sudah selesai tidak dapat diubah.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final matchedMenu = _menuList.firstWhere(
      (m) => (m['nama_menu'] ?? m['name']) == item['nama_menu'],
      orElse: () => _menuList.first,
    );

    setState(() {
      _editingIndex = index;
      _selectedDate = item['tanggal'];
      _selectedMenuId = matchedMenu['id'] ?? matchedMenu['id_menu'];
      _portionController.text = item['target_porsi'].toString();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mengedit jadwal "${item['nama_menu']}". Silakan ubah data pada form.'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _deleteSchedule(int index) {
    final item = _scheduleHistory[index];
    if (item['status'] != 'BELUM_BERJALAN') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jadwal yang sedang berjalan tidak dapat dihapus.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Jadwal Menu',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
            'Apakah Anda yakin ingin menghapus jadwal menu "${item['nama_menu']}" untuk ${_formatDate(item['tanggal'])}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Batal',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(dialogCtx);
              setState(() {
                _scheduleHistory.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Jadwal menu berhasil dihapus.'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final bool tomorrowIsScheduled = _isTomorrowScheduled();

    final filteredHistory = _historyQuery.isEmpty
        ? _scheduleHistory
        : _scheduleHistory.where((item) {
            final name = item['nama_menu'].toString().toLowerCase();
            final dateStr = _formatDate(item['tanggal']).toLowerCase();
            final q = _historyQuery.toLowerCase();
            return name.contains(q) || dateStr.contains(q);
          }).toList();

    return SppgAdminLayout(
      currentRoute: '/create-schedule',
      title: 'Jadwal Menu Harian',
      subtitle: 'Pengaturan Jadwal Penyajian Makanan & Riwayat Sekolah',
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 720),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ⚠️ BANNER PERINGATAN H-1 (Hanya muncul jika menu besok belum diisi)
                if (!tomorrowIsScheduled)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFCD34D)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            color: Color(0xFFD97706), size: 24),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Peringatan Dapur SPPG',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF92400E),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Rencana menu makanan untuk Besok (${_formatDate(tomorrow)}) belum diatur. Segera pilih menu makanan agar siswa dapat memberikan konfirmasi kehadiran.',
                                softWrap: true,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFB45309),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                // Card Form Plotting Jadwal Baru / Edit
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                              _editingIndex != null
                                  ? Icons.edit_note_rounded
                                  : Icons.add_task_rounded,
                              color: AppColors.primary,
                              size: 22),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _editingIndex != null
                                  ? 'Edit Jadwal Menu Makanan'
                                  : 'Buat Jadwal Menu Makanan Baru',
                              softWrap: true,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (_editingIndex != null)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _editingIndex = null;
                                });
                              },
                              child: const Text('Batal Edit',
                                  style: TextStyle(color: AppColors.error)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // 1. Pilih Tanggal Penyajian
                      const Text(
                        '1. Tanggal Penyajian Makanan',
                        style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: _pickDate,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(Icons.event_rounded,
                                        color: AppColors.primary, size: 20),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        _formatDate(_selectedDate),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down_rounded,
                                  color: AppColors.textSecondary),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 2. Pilih Menu Makanan (isExpanded: true to prevent overflow)
                      const Text(
                        '2. Pilih Menu Makanan Seimbang',
                        style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: _selectedMenuId,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          filled: true,
                          fillColor: AppColors.background,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: AppColors.primary, width: 1.5),
                          ),
                        ),
                        items: _menuList.map((m) {
                          final id = m['id'] ?? m['id_menu'];
                          final name = m['nama_menu'] ?? m['name'] ?? '';
                          final cal = m['kalori_kkal'] ?? m['calories'] ?? 500;
                          return DropdownMenuItem<String>(
                            value: id,
                            child: Text(
                              '$name ($cal kcal)',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(fontSize: 12.5),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedMenuId = val);
                          }
                        },
                      ),
                      const SizedBox(height: 14),

                      // 3 & 4. Responsive Layout (Column on Mobile, Row on Desktop)
                      LayoutBuilder(
                        builder: (context, boxConstraints) {
                          final isNarrow = boxConstraints.maxWidth < 420;

                          Widget field3 = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '3. Jam Batas Konfirmasi',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                isExpanded: true,
                                initialValue: _selectedDeadlineTime,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  filled: true,
                                  fillColor: AppColors.background,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        const BorderSide(color: AppColors.border),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: AppColors.primary, width: 1.5),
                                  ),
                                ),
                                items: _deadlineOptions.map((t) {
                                  return DropdownMenuItem<String>(
                                    value: t,
                                    child: Text(
                                      t,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(fontSize: 11.5),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => _selectedDeadlineTime = val);
                                  }
                                },
                              ),
                            ],
                          );

                          Widget field4 = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '4. Target Porsi Masak',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _portionController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '450 porsi',
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  filled: true,
                                  fillColor: AppColors.background,
                                  suffixText: 'porsi',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        const BorderSide(color: AppColors.border),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: AppColors.primary, width: 1.5),
                                  ),
                                ),
                              ),
                            ],
                          );

                          if (isNarrow) {
                            return Column(
                              children: [
                                field3,
                                const SizedBox(height: 12),
                                field4,
                              ],
                            );
                          } else {
                            return Row(
                              children: [
                                Expanded(child: field3),
                                const SizedBox(width: 12),
                                Expanded(child: field4),
                              ],
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 18),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: Icon(
                              _editingIndex != null
                                  ? Icons.save_rounded
                                  : Icons.send_rounded,
                              size: 18),
                          label: Text(
                            _editingIndex != null
                                ? 'Simpan Perubahan Jadwal'
                                : 'Publikasikan Jadwal Menu',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          onPressed: _submitSchedule,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Header Riwayat Jadwal & Search Bar Input
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Expanded(
                      child: Text(
                        'Riwayat Lengkap Jadwal Menu per Tanggal',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      'Terurut Terbaru',
                      style:
                          TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Filter Search Input
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    controller: _searchHistoryController,
                    onChanged: (val) {
                      setState(() {
                        _historyQuery = val.trim();
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Cari riwayat berdasarkan tanggal atau nama menu...',
                      hintStyle:
                          TextStyle(fontSize: 12, color: AppColors.textLight),
                      prefixIcon: Icon(Icons.search_rounded,
                          color: AppColors.primary, size: 20),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // List Riwayat Jadwal
                filteredHistory.isEmpty
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Center(
                          child: Text(
                            'Tidak ada riwayat jadwal yang sesuai pencarian.',
                            style: TextStyle(
                                fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredHistory.length,
                        itemBuilder: (context, index) {
                          final item = filteredHistory[index];
                          final DateTime date = item['tanggal'];
                          final String formattedDate = _formatDate(date);
                          final String status = item['status'];
                          final bool isEditable = status == 'BELUM_BERJALAN';

                          Color statusColor = AppColors.primary;
                          String statusLabel = 'BELUM BERJALAN';
                          if (status == 'SEDANG_BERJALAN') {
                            statusColor = Colors.orange;
                            statusLabel = 'SEDANG BERJALAN (TERKUNCI)';
                          } else if (status == 'SELESAI') {
                            statusColor = Colors.grey;
                            statusLabel = 'SELESAI DISAJIKAN';
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryLight,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(Icons.restaurant_rounded,
                                          color: AppColors.primary, size: 18),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  formattedDate,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.primaryDark,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: statusColor.withValues(
                                                      alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  statusLabel,
                                                  style: TextStyle(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                    color: statusColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            item['nama_menu'],
                                            softWrap: true,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                const Divider(height: 1),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Porsi: ${item['target_porsi']} • Batas: ${item['batas_waktu']} • Kesukaan: ${item['kepuasan']}',
                                        softWrap: true,
                                        style: const TextStyle(
                                          fontSize: 10.5,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                    if (isEditable) ...[
                                      IconButton(
                                        icon: const Icon(Icons.edit_rounded,
                                            color: AppColors.primary, size: 18),
                                        onPressed: () => _editSchedule(index),
                                        tooltip: 'Edit Jadwal',
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                            Icons.delete_outline_rounded,
                                            color: AppColors.error,
                                            size: 18),
                                        onPressed: () => _deleteSchedule(index),
                                        tooltip: 'Hapus Jadwal',
                                      ),
                                    ] else ...[
                                      const Tooltip(
                                        message:
                                            'Status sedang berjalan / selesai terkunci',
                                        child: Icon(Icons.lock_rounded,
                                            color: AppColors.textLight,
                                            size: 16),
                                      ),
                                    ]
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
