class MockData {
  // 1. Data Profil Siswa Utama (Faizullatif Fajran - MAN 2 Kota Padang)
  static const Map<String, dynamic> studentProfile = {
    'id': 'usr_991823ab',
    'nisn': '3171012345670001',
    'name': 'Faizullatif Fajran',
    'school': 'MAN 2 Kota Padang',
    'classGrade': 'XII.FA-3',
    'allergies': ['Kacang Tanah', 'Udang'],
    'phone': '081234567890',
  };

  // 2. Data Statistik Ringkasan Dasbor Siswa (Bulan Agustus 2026)
  static const Map<String, dynamic> studentDashboardStats = {
    'totalPortionsReceived': 18,
    'attendancePercentage': 95.0,
    'totalEvaluationsSubmitted': 16,
    'currentDateFormatted': 'Sabtu, 8 Agustus 2026',
  };

  // 3. Menu MBG Hari Ini (Sabtu, 8 Agustus 2026)
  static const Map<String, dynamic> todayMenu = {
    'id_menu': 'mnu_441209cc',
    'nama_menu': 'Nasi Ayam Bakar Kecap & Tumis Buncis',
    'kategori': 'MAKANAN_BERAT',
    'kalori_kkal': 550,
    'protein_gram': 28.5,
    'karbohidrat_gram': 65.0,
    'lemak_gram': 14.2,
    'komposisi_bahan': ['Dada Ayam Bakar', 'Nasi Putih Warm', 'Tumis Buncis Wortel'],
    'potensi_alergen': ['Kedelai'],
    'estimasi_biaya_per_porsi': 15000,
    'foto_url':
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
    'rating_rata_rata': 4.9,
    'tanggal_jadwal': 'Sabtu, 8 Agustus 2026',
  };

  // 4. Rencana Menu MBG Besok (Senin, 10 Agustus 2026)
  static const Map<String, dynamic> tomorrowMenu = {
    'id_menu': 'mnu_551902aa',
    'nama_menu': 'Nasi Semur Daging Sapi & Sup Sayur',
    'kategori': 'MAKANAN_BERAT',
    'kalori_kkal': 580,
    'protein_gram': 32.0,
    'karbohidrat_gram': 60.0,
    'lemak_gram': 15.0,
    'komposisi_bahan': [
      'Daging Sapi Empuk',
      'Nasi Putih Warm',
      'Sup Brokoli Wortel',
      'Telur Rebus'
    ],
    'potensi_alergen': ['Kacang Tanah', 'Kedelai'], // Mengandung alergi Faizullatif (Kacang Tanah)
    'estimasi_biaya_per_porsi': 16500,
    'foto_url':
        'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=600&q=80',
    'rating_rata_rata': 4.8,
    'tanggal_jadwal': 'Senin, 10 Agustus 2026',
  };

  // 5. Master Daftar Menu MBG (Untuk Admin SPPG)
  static const List<Map<String, dynamic>> foodMenuList = [
    {
      'id_menu': 'mnu_441209cc',
      'nama_menu': 'Nasi Ayam Bakar Kecap & Tumis Buncis',
      'kategori': 'MAKANAN_BERAT',
      'kalori_kkal': 550,
      'protein_gram': 28.5,
      'karbohidrat_gram': 65.0,
      'lemak_gram': 14.2,
      'komposisi_bahan': ['Dada Ayam', 'Nasi Putih', 'Buncis', 'Wortel'],
      'potensi_alergen': ['Kedelai'],
      'estimasi_biaya_per_porsi': 15000,
      'foto_url':
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
      'rating_rata_rata': 4.9,
    },
    {
      'id_menu': 'mnu_551902aa',
      'nama_menu': 'Nasi Semur Daging Sapi & Sup Sayur',
      'kategori': 'MAKANAN_BERAT',
      'kalori_kkal': 580,
      'protein_gram': 32.0,
      'karbohidrat_gram': 60.0,
      'lemak_gram': 15.0,
      'komposisi_bahan': [
        'Daging Sapi Empuk',
        'Nasi Putih',
        'Sup Brokoli Wortel',
        'Telur Rebus'
      ],
      'potensi_alergen': ['Kacang Tanah', 'Kedelai'],
      'estimasi_biaya_per_porsi': 16500,
      'foto_url':
          'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=600&q=80',
      'rating_rata_rata': 4.8,
    },
    {
      'id_menu': 'mnu_662011bb',
      'nama_menu': 'Nasi Ikan Kembung Bakar & Tumis Bayam',
      'kategori': 'MAKANAN_BERAT',
      'kalori_kkal': 440,
      'protein_gram': 30.0,
      'karbohidrat_gram': 52.0,
      'lemak_gram': 10.0,
      'komposisi_bahan': ['Ikan Kembung', 'Nasi Putih', 'Bayam', 'Jagung Manis'],
      'potensi_alergen': ['Ikan Laut'],
      'estimasi_biaya_per_porsi': 14500,
      'foto_url':
          'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?auto=format&fit=crop&w=600&q=80',
      'rating_rata_rata': 4.7,
    },
  ];

  // 6. Data Ringkasan Porsi untuk SPPG Kota Padang
  static const Map<String, dynamic> sppgPortionSummary = {
    'totalPortions': 500,
    'confirmedPortions': 450,
    'rejectedPortions': 50,
    'pendingPortions': 0,
    'deliveryDate': '2026-08-08',
    'sppgUnitName': 'SPPG Unit Kota Padang 01',
    'targetSchools': 5,
    'status': 'Dalam Pengiriman',
    'confirmationPercentage': 90.0,
  };
}
