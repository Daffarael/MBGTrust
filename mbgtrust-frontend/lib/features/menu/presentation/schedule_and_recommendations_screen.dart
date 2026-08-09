import 'package:flutter/material.dart';
import '../../../core/constants/mock_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../production/presentation/widgets/sppg_admin_layout.dart';

class ScheduleAndRecommendationsScreen extends StatefulWidget {
  final List<Map<String, dynamic>>? initialMenuList;

  const ScheduleAndRecommendationsScreen({
    super.key,
    this.initialMenuList,
  });

  @override
  State<ScheduleAndRecommendationsScreen> createState() =>
      _ScheduleAndRecommendationsScreenState();
}

class _ScheduleAndRecommendationsScreenState
    extends State<ScheduleAndRecommendationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Form State
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1)); // Default H+1 (Besok)
  String? _selectedMenuId;
  String _selectedDeadlineTime = '17:00 WIB (Standar SPPG)';
  final TextEditingController _portionController =
      TextEditingController(text: '450');

  late List<Map<String, dynamic>> _menuList;
  late List<Map<String, dynamic>> _scheduleHistory;

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
    _tabController = TabController(length: 2, vsync: this);
    _menuList = widget.initialMenuList ?? List.from(MockData.foodMenuList);

    if (_menuList.isNotEmpty) {
      _selectedMenuId = _menuList.first['id'] ?? _menuList.first['id_menu'];
    }

    _scheduleHistory = [
      {
        'id': 'sch_01',
        'tanggal': DateTime.now().add(const Duration(days: 1)),
        'nama_menu': 'Nasi Ayam Bakar Kecap & Tumis Buncis',
        'kategori': 'MAKANAN_BERAT',
        'kalori': '550 kcal',
        'target_porsi': 450,
        'batas_waktu': '17:00 WIB',
        'status': 'MENUNGGU_KONFIRMASI',
        'kepuasan': '96.5%',
      },
      {
        'id': 'sch_02',
        'tanggal': DateTime.now(),
        'nama_menu': 'Nasi Daging Sapi Lada Hitam & Capcay',
        'kategori': 'MAKANAN_BERAT',
        'kalori': '620 kcal',
        'target_porsi': 450,
        'batas_waktu': '17:00 WIB',
        'status': 'SEDANG_BERJALAN',
        'kepuasan': '94.0%',
      },
      {
        'id': 'sch_03',
        'tanggal': DateTime.now().subtract(const Duration(days: 1)),
        'nama_menu': 'Nasi Ikan Gurame Asam Manis & Sup Sayur',
        'kategori': 'MAKANAN_BERAT',
        'kalori': '580 kcal',
        'target_porsi': 440,
        'batas_waktu': '17:00 WIB',
        'status': 'SELESAI',
        'kepuasan': '91.8%',
      },
      {
        'id': 'sch_04',
        'tanggal': DateTime.now().subtract(const Duration(days: 2)),
        'nama_menu': 'Nasi Telur Balado & Sayur Asem',
        'kategori': 'MAKANAN_BERAT',
        'kalori': '510 kcal',
        'target_porsi': 445,
        'batas_waktu': '17:00 WIB',
        'status': 'SELESAI',
        'kepuasan': '88.5%',
      },
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    _portionController.dispose();
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

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
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
      _scheduleHistory.insert(0, {
        'id': 'sch_${DateTime.now().millisecondsSinceEpoch}',
        'tanggal': _selectedDate,
        'nama_menu': namaMenu,
        'kategori': selectedMenuObj['kategori'] ?? 'MAKANAN_BERAT',
        'kalori': kalori,
        'target_porsi': targetPorsi,
        'batas_waktu': _selectedDeadlineTime,
        'status': 'MENUNGGU_KONFIRMASI',
        'kepuasan': '95.0%',
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Jadwal menu "$namaMenu" untuk ${_formatDate(_selectedDate)} berhasil dipublikasikan!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _scheduleFromRecommendation(Map<String, dynamic> recItem) {
    final recName = recItem['nama_menu'];
    final matchedMenu = _menuList.firstWhere(
      (m) => (m['nama_menu'] ?? m['name']) == recName,
      orElse: () => _menuList.first,
    );

    setState(() {
      _selectedMenuId = matchedMenu['id'] ?? matchedMenu['id_menu'];
      _tabController.animateTo(0); // Switch to Tab 1
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Menu "$recName" dipilih! Silakan sesuaikan tanggal jadwal.'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SppgAdminLayout(
      currentRoute: '/schedule-and-recommendations',
      title: 'Jadwal & Rekomendasi Menu',
      subtitle: 'Pengaturan Jadwal Menu Harian & Rekomendasi Terfavorit Siswa',
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            children: [
              // Custom TabBar (Over-flow Free)
              Container(
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.textSecondary,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                  labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
                  tabs: const [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_month_rounded, size: 16),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'Jadwal & Riwayat',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star_rounded, size: 16),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'Top 5 Rekomendasi',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // TabBar View Body
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildJadwalAndRiwayatTab(),
                    _buildTopRekomendasiTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // TAB 1: JADWAL & RIWAYAT MENU
  // ===========================================================================
  Widget _buildJadwalAndRiwayatTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Form Plotting Jadwal Baru
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
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
                  children: const [
                    Icon(Icons.add_task_rounded,
                        color: AppColors.primary, size: 22),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Buat Jadwal Menu Makanan Baru',
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
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

                // 2. Pilih Menu Makanan (isExpanded: true to prevent 211px overflow)
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

                // 3 & 4. Responsive Layout (Column on Mobile Narrow, Row on Desktop)
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
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: const Text(
                      'Publikasikan Jadwal Menu',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    onPressed: _submitSchedule,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Header Riwayat Jadwal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(
                child: Text(
                  'Riwayat Jadwal Menu per Tanggal',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                'Terurut Terbaru',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // List Riwayat Jadwal
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _scheduleHistory.length,
            itemBuilder: (context, index) {
              final item = _scheduleHistory[index];
              final DateTime date = item['tanggal'];
              final String formattedDate = _formatDate(date);
              final String status = item['status'];

              Color statusColor = AppColors.primary;
              String statusLabel = 'MENUNGGU KONFIRMASI';
              if (status == 'SEDANG_BERJALAN') {
                statusColor = Colors.orange;
                statusLabel = 'SEDANG BERJALAN';
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
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.restaurant_rounded,
                          color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
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
                          const SizedBox(height: 4),
                          Text(
                            item['nama_menu'],
                            softWrap: true,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Target: ${item['target_porsi']} Porsi • Batas Jam: ${item['batas_waktu']} • Kepuasan: ${item['kepuasan']}',
                            softWrap: true,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // TAB 2: TOP 5 REKOMENDASI MENU SISWA (BEBAS TEKNIS TOPSIS/SPK)
  // ===========================================================================
  Widget _buildTopRekomendasiTab() {
    final List<Map<String, dynamic>> topRecommendations = [
      {
        'rank': 1,
        'nama_menu': 'Nasi Ayam Bakar Kecap & Tumis Buncis',
        'kepuasan': '96.5%',
        'kategori': 'Makanan Berat',
        'kalori': '550 kcal',
        'ulasan': 'Favorit utama siswa, rasa enak & porsi sangat pas.',
        'badge': 'Sangat Direkomendasikan',
        'badgeColor': AppColors.primary,
      },
      {
        'rank': 2,
        'nama_menu': 'Nasi Daging Sapi Lada Hitam & Capcay',
        'kepuasan': '94.0%',
        'kategori': 'Makanan Berat',
        'kalori': '620 kcal',
        'ulasan': 'Daging empuk, sisa makanan terendah di sekolah.',
        'badge': 'Sangat Direkomendasikan',
        'badgeColor': AppColors.primary,
      },
      {
        'rank': 3,
        'nama_menu': 'Nasi Ikan Gurame Asam Manis & Sup Sayur',
        'kepuasan': '91.8%',
        'kategori': 'Makanan Berat',
        'kalori': '580 kcal',
        'ulasan': 'Sangat disukai untuk variasi menu protein ikan.',
        'badge': 'Rekomendasi Tinggi',
        'badgeColor': Colors.blue,
      },
      {
        'rank': 4,
        'nama_menu': 'Nasi Telur Balado & Sayur Asem',
        'kepuasan': '88.5%',
        'kategori': 'Makanan Berat',
        'kalori': '510 kcal',
        'ulasan': 'Pilihan ekonomis dengan tingkat kesukaan stabil.',
        'badge': 'Rekomendasi Baik',
        'badgeColor': Colors.teal,
      },
      {
        'rank': 5,
        'nama_menu': 'Nasi Ayam Goreng Lengkuas & Lalapan',
        'kepuasan': '85.0%',
        'kategori': 'Makanan Berat',
        'kalori': '560 kcal',
        'ulasan': 'Perlu sedikit penyesuaian porsi lalapan bumbu.',
        'badge': 'Evaluasi Porsi',
        'badgeColor': Colors.amber.shade800,
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Penjelasan Peringkat
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: const [
                Icon(Icons.emoji_events_rounded,
                    color: AppColors.primaryDark, size: 24),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Top 5 Menu Paling Disukai Siswa berdasarkan analisis tingkat kesukaan rasa, kecukupan porsi, dan persentase makanan yang dihabiskan.',
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // List Top 5 Menu
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: topRecommendations.length,
            itemBuilder: (context, index) {
              final rec = topRecommendations[index];
              final int rank = rec['rank'];
              final Color badgeColor = rec['badgeColor'];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: rank == 1
                          ? AppColors.primary
                          : AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Rank Badge Icon
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: rank == 1
                                ? const Color(0xFFFFD700)
                                : (rank == 2
                                    ? const Color(0xFFC0C0C0)
                                    : (rank == 3
                                        ? const Color(0xFFCD7F32)
                                        : AppColors.primaryLight)),
                          ),
                          child: Center(
                            child: Text(
                              '#$rank',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: rank <= 3
                                    ? Colors.black87
                                    : AppColors.primaryDark,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                rec['nama_menu'],
                                softWrap: true,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${rec['kategori']} • ${rec['kalori']}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Text(
                                rec['kepuasan'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                              const Text(
                                'Kepuasan Siswa',
                                style: TextStyle(
                                  fontSize: 8.5,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '💬 "${rec['ulasan']}"',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Wrap for Card Footer (Overflow-proof on narrow screen)
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: badgeColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            rec['badge'],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: badgeColor,
                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.event_available_rounded,
                              color: AppColors.primary, size: 15),
                          label: const Text(
                            'Jadwalkan Menu Ini',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          onPressed: () => _scheduleFromRecommendation(rec),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
