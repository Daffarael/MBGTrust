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

  // 3. Master Daftar Menu MBG (12 Katalog Menu Lengkap 100% Sesuai Kontrak API Modul 2)
  static const List<Map<String, dynamic>> foodMenuList = [
    {
      'id_menu': 'mnu_441209cc',
      'nama_menu': 'Nasi Ayam Bakar Kecap & Tumis Buncis',
      'name': 'Nasi Ayam Bakar Kecap & Tumis Buncis',
      'kategori': 'MAKANAN_BERAT',
      'category': 'Makanan Berat',
      'kalori_kkal': 550,
      'calories': 550,
      'protein_gram': 28.5,
      'protein': '28.5g',
      'karbohidrat_gram': 65.0,
      'lemak_gram': 14.2,
      'komposisi_bahan': ['Dada Ayam Bakar Kecap', 'Tumis Buncis & Wortel', 'Nasi Putih Warm'],
      'komposisi_bahan_detail': [
        {
          'nama': 'Dada Ayam Bakar Kecap',
          'sub': 'Sumber Utama Protein & Zat Besi',
          'berat': '80 gram',
        },
        {
          'nama': 'Tumis Buncis & Wortel',
          'sub': 'Kaya Serat & Vitamin A',
          'berat': '60 gram',
        },
        {
          'nama': 'Nasi Putih Warm',
          'sub': 'Karbohidrat Kompleks',
          'berat': '150 gram',
        },
      ],
      'potensi_alergen': ['Kedelai'],
      'estimasi_biaya_per_porsi': 15000,
      'foto_url':
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
      'photoUrl':
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
      'rating_rata_rata': 4.9,
      'tanggal_jadwal': 'Sabtu, 8 Agustus 2026',
    },
    {
      'id_menu': 'mnu_551902aa',
      'nama_menu': 'Nasi Semur Daging Sapi & Sup Sayur',
      'name': 'Nasi Semur Daging Sapi & Sup Sayur',
      'kategori': 'MAKANAN_BERAT',
      'category': 'Makanan Berat',
      'kalori_kkal': 580,
      'calories': 580,
      'protein_gram': 32.0,
      'protein': '32g',
      'karbohidrat_gram': 60.0,
      'lemak_gram': 15.0,
      'komposisi_bahan': [
        'Daging Sapi Empuk Semur',
        'Sup Brokoli & Wortel',
        'Telur Rebus Organik',
        'Nasi Putih Warm'
      ],
      'komposisi_bahan_detail': [
        {
          'nama': 'Daging Sapi Empuk Semur',
          'sub': 'Kaya Asam Amino & Protein Sapi',
          'berat': '90 gram',
        },
        {
          'nama': 'Sup Brokoli & Wortel',
          'sub': 'Antioksidan & Mineral Alami',
          'berat': '70 gram',
        },
        {
          'nama': 'Telur Rebus Organik',
          'sub': 'Sumber Kolin & B12',
          'berat': '50 gram',
        },
        {
          'nama': 'Nasi Putih Warm',
          'sub': 'Karbohidrat Kompleks',
          'berat': '150 gram',
        },
      ],
      'potensi_alergen': ['Kacang Tanah', 'Kedelai'],
      'estimasi_biaya_per_porsi': 16500,
      'foto_url':
          'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=600&q=80',
      'photoUrl':
          'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=600&q=80',
      'rating_rata_rata': 4.8,
      'tanggal_jadwal': 'Senin, 10 Agustus 2026',
    },
    {
      'id_menu': 'mnu_662011bb',
      'nama_menu': 'Nasi Ikan Kembung Bakar & Tumis Bayam',
      'name': 'Nasi Ikan Kembung Bakar & Tumis Bayam',
      'kategori': 'MAKANAN_BERAT',
      'category': 'Makanan Berat',
      'kalori_kkal': 440,
      'calories': 440,
      'protein_gram': 30.0,
      'protein': '30g',
      'karbohidrat_gram': 52.0,
      'lemak_gram': 10.0,
      'komposisi_bahan': ['Ikan Kembung Bakar', 'Tumis Bayam & Jagung', 'Nasi Putih'],
      'komposisi_bahan_detail': [
        {
          'nama': 'Ikan Kembung Bakar',
          'sub': 'Tinggi Omega-3 & DHA',
          'berat': '85 gram',
        },
        {
          'nama': 'Tumis Bayam & Jagung',
          'sub': 'Asam Folat & Zat Besi',
          'berat': '65 gram',
        },
        {
          'nama': 'Nasi Putih Warm',
          'sub': 'Karbohidrat Utama',
          'berat': '150 gram',
        },
      ],
      'potensi_alergen': ['Ikan Laut'],
      'estimasi_biaya_per_porsi': 14500,
      'foto_url':
          'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?auto=format&fit=crop&w=600&q=80',
      'photoUrl':
          'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?auto=format&fit=crop&w=600&q=80',
      'rating_rata_rata': 4.7,
      'tanggal_jadwal': 'Selasa, 11 Agustus 2026',
    },
    {
      'id_menu': 'mnu_773122cc',
      'nama_menu': 'Nasi Rolade Sapi & Capcay Sayur Segar',
      'name': 'Nasi Rolade Sapi & Capcay Sayur Segar',
      'kategori': 'MAKANAN_BERAT',
      'category': 'Makanan Berat',
      'kalori_kkal': 520,
      'calories': 520,
      'protein_gram': 26.0,
      'protein': '26g',
      'karbohidrat_gram': 58.0,
      'lemak_gram': 12.5,
      'komposisi_bahan': ['Rolade Daging Sapi', 'Capcay Sayur Kombinasi', 'Nasi Putih'],
      'komposisi_bahan_detail': [
        {
          'nama': 'Rolade Daging Sapi',
          'sub': 'Protein Olahan Berkualitas',
          'berat': '80 gram',
        },
        {
          'nama': 'Capcay Sayur Kombinasi',
          'sub': 'Kembang Kol, Wortel & Sawi',
          'berat': '70 gram',
        },
        {
          'nama': 'Nasi Putih Warm',
          'sub': 'Karbohidrat Utama',
          'berat': '150 gram',
        },
      ],
      'potensi_alergen': ['Telur', 'Kedelai'],
      'estimasi_biaya_per_porsi': 15000,
      'foto_url':
          'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
      'photoUrl':
          'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
      'rating_rata_rata': 4.8,
      'tanggal_jadwal': 'Rabu, 12 Agustus 2026',
    },
    {
      'id_menu': 'mnu_884233dd',
      'nama_menu': 'Nasi Ayam Goreng Lengkuas & Tahu Tempe',
      'name': 'Nasi Ayam Goreng Lengkuas & Tahu Tempe',
      'kategori': 'MAKANAN_BERAT',
      'category': 'Makanan Berat',
      'kalori_kkal': 560,
      'calories': 560,
      'protein_gram': 29.0,
      'protein': '29g',
      'karbohidrat_gram': 62.0,
      'lemak_gram': 16.0,
      'komposisi_bahan': ['Ayam Goreng Rempah', 'Tahu Tempe Goreng', 'Lalapan Segar'],
      'komposisi_bahan_detail': [
        {
          'nama': 'Ayam Goreng Rempah Lengkuas',
          'sub': 'Sumber Protein & Niacin',
          'berat': '85 gram',
        },
        {
          'nama': 'Tahu Tempe Bacem Kukus',
          'sub': 'Isoflavon & Protein Nabati',
          'berat': '50 gram',
        },
        {
          'nama': 'Nasi Putih Warm',
          'sub': 'Karbohidrat Kompleks',
          'berat': '150 gram',
        },
      ],
      'potensi_alergen': ['Kedelai'],
      'estimasi_biaya_per_porsi': 15000,
      'foto_url':
          'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?auto=format&fit=crop&w=600&q=80',
      'photoUrl':
          'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?auto=format&fit=crop&w=600&q=80',
      'rating_rata_rata': 4.9,
      'tanggal_jadwal': 'Kamis, 13 Agustus 2026',
    },
    {
      'id_menu': 'mnu_995344ee',
      'nama_menu': 'Nasi Telur Balado & Tumis Kacang Panjang',
      'name': 'Nasi Telur Balado & Tumis Kacang Panjang',
      'kategori': 'MAKANAN_BERAT',
      'category': 'Makanan Berat',
      'kalori_kkal': 480,
      'calories': 480,
      'protein_gram': 22.0,
      'protein': '22g',
      'karbohidrat_gram': 55.0,
      'lemak_gram': 11.0,
      'komposisi_bahan': ['Telur Balado Merah', 'Tumis Kacang Panjang', 'Tempe Oreg'],
      'komposisi_bahan_detail': [
        {
          'nama': 'Telur Balado Merah',
          'sub': 'Protein Telur Utuh',
          'berat': '60 gram',
        },
        {
          'nama': 'Tumis Kacang Panjang',
          'sub': 'Serat & Vitamin B Kompleks',
          'berat': '60 gram',
        },
        {
          'nama': 'Nasi Putih Warm',
          'sub': 'Karbohidrat Utama',
          'berat': '150 gram',
        },
      ],
      'potensi_alergen': ['Telur', 'Kedelai'],
      'estimasi_biaya_per_porsi': 13500,
      'foto_url':
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=600&q=80',
      'photoUrl':
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=600&q=80',
      'rating_rata_rata': 4.6,
      'tanggal_jadwal': 'Jumat, 14 Agustus 2026',
    },
    {
      'id_menu': 'mnu_106455ff',
      'nama_menu': 'Nasi Rendang Daging Sapi & Daun Singkong',
      'name': 'Nasi Rendang Daging Sapi & Daun Singkong',
      'kategori': 'MAKANAN_BERAT',
      'category': 'Makanan Berat',
      'kalori_kkal': 610,
      'calories': 610,
      'protein_gram': 34.0,
      'protein': '34g',
      'karbohidrat_gram': 59.0,
      'lemak_gram': 18.0,
      'komposisi_bahan': ['Daging Sapi Rendang Minang', 'Daun Singkong Rebus', 'Nasi Putih'],
      'komposisi_bahan_detail': [
        {
          'nama': 'Daging Sapi Rendang Minang',
          'sub': 'Protein Tinggi & Zat Besi',
          'berat': '90 gram',
        },
        {
          'nama': 'Daun Singkong Rebus',
          'sub': 'Serat Tinggi & Kalsium',
          'berat': '60 gram',
        },
        {
          'nama': 'Nasi Putih Warm',
          'sub': 'Karbohidrat Utama',
          'berat': '150 gram',
        },
      ],
      'potensi_alergen': [],
      'estimasi_biaya_per_porsi': 17000,
      'foto_url':
          'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?auto=format&fit=crop&w=600&q=80',
      'photoUrl':
          'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?auto=format&fit=crop&w=600&q=80',
      'rating_rata_rata': 4.95,
      'tanggal_jadwal': 'Sabtu, 15 Agustus 2026',
    },
    {
      'id_menu': 'mnu_117566aa',
      'nama_menu': 'Nasi Tumis Udang Paprika & Tahu Kukus',
      'name': 'Nasi Tumis Udang Paprika & Tahu Kukus',
      'kategori': 'MAKANAN_BERAT',
      'category': 'Makanan Berat',
      'kalori_kkal': 490,
      'calories': 490,
      'protein_gram': 31.0,
      'protein': '31g',
      'karbohidrat_gram': 54.0,
      'lemak_gram': 9.5,
      'komposisi_bahan': ['Udang Segar Paprika', 'Tahu Kukus Lembut', 'Nasi Putih'],
      'komposisi_bahan_detail': [
        {
          'nama': 'Udang Segar Paprika',
          'sub': 'Tinggi Protein & Zinc',
          'berat': '80 gram',
        },
        {
          'nama': 'Tahu Kukus Lembut',
          'sub': 'Protein Nabati',
          'berat': '50 gram',
        },
        {
          'nama': 'Nasi Putih Warm',
          'sub': 'Karbohidrat Utama',
          'berat': '150 gram',
        },
      ],
      'potensi_alergen': ['Udang', 'Kedelai'],
      'estimasi_biaya_per_porsi': 16000,
      'foto_url':
          'https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&w=600&q=80',
      'photoUrl':
          'https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&w=600&q=80',
      'rating_rata_rata': 4.75,
      'tanggal_jadwal': 'Senin, 17 Agustus 2026',
    },
    {
      'id_menu': 'mnu_128677bb',
      'nama_menu': 'Susu UHT Segar 200ml & Pisang Ambon Organik',
      'name': 'Susu UHT Segar 200ml & Pisang Ambon Organik',
      'kategori': 'SUSU_DAN_BUAH',
      'category': 'Susu & Buah',
      'kalori_kkal': 210,
      'calories': 210,
      'protein_gram': 8.0,
      'protein': '8g',
      'karbohidrat_gram': 32.0,
      'lemak_gram': 5.0,
      'komposisi_bahan': ['Susu Sapi Segar 200ml', 'Pisang Ambon Organik'],
      'komposisi_bahan_detail': [
        {
          'nama': 'Susu Sapi Segar UHT',
          'sub': 'Kalsium & Vitamin D',
          'berat': '200 ml',
        },
        {
          'nama': 'Pisang Ambon Organik',
          'sub': 'Kalium & Energi Cepat',
          'berat': '120 gram',
        },
      ],
      'potensi_alergen': ['Susu'],
      'estimasi_biaya_per_porsi': 6000,
      'foto_url':
          'https://images.unsplash.com/photo-1528498033373-3c6c08e93d79?auto=format&fit=crop&w=600&q=80',
      'photoUrl':
          'https://images.unsplash.com/photo-1528498033373-3c6c08e93d79?auto=format&fit=crop&w=600&q=80',
      'rating_rata_rata': 4.9,
      'tanggal_jadwal': 'Selasa, 18 Agustus 2026',
    },
    {
      'id_menu': 'mnu_139788cc',
      'nama_menu': 'Puding Mangga VLA Susu Sehat Rendah Gula',
      'name': 'Puding Mangga VLA Susu Sehat Rendah Gula',
      'kategori': 'SNACK_SEHAT',
      'category': 'Snack Sehat',
      'kalori_kkal': 180,
      'calories': 180,
      'protein_gram': 4.5,
      'protein': '4.5g',
      'karbohidrat_gram': 35.0,
      'lemak_gram': 3.0,
      'komposisi_bahan': ['Puding Mangga Alami', 'Vla Susu Rendah Gula'],
      'komposisi_bahan_detail': [
        {
          'nama': 'Puding Mangga Alami',
          'sub': 'Serat Buah Mangga Manis',
          'berat': '100 gram',
        },
        {
          'nama': 'Vla Susu Rendah Gula',
          'sub': 'Kalsium Ringan',
          'berat': '30 gram',
        },
      ],
      'potensi_alergen': ['Susu'],
      'estimasi_biaya_per_porsi': 5000,
      'foto_url':
          'https://images.unsplash.com/photo-1551024709-8f23befc6f87?auto=format&fit=crop&w=600&q=80',
      'photoUrl':
          'https://images.unsplash.com/photo-1551024709-8f23befc6f87?auto=format&fit=crop&w=600&q=80',
      'rating_rata_rata': 4.85,
      'tanggal_jadwal': 'Rabu, 19 Agustus 2026',
    },
    {
      'id_menu': 'mnu_140899dd',
      'nama_menu': 'Nasi Sup Ayam Kampung & Perkedel Kentang',
      'name': 'Nasi Sup Ayam Kampung & Perkedel Kentang',
      'kategori': 'MAKANAN_BERAT',
      'category': 'Makanan Berat',
      'kalori_kkal': 510,
      'calories': 510,
      'protein_gram': 27.0,
      'protein': '27g',
      'karbohidrat_gram': 61.0,
      'lemak_gram': 11.5,
      'komposisi_bahan': ['Ayam Kampung Suwir', 'Sup Sayur Bening', 'Perkedel Kentang'],
      'komposisi_bahan_detail': [
        {
          'nama': 'Ayam Kampung Suwir',
          'sub': 'Protein Bebas Lemak Jenuh',
          'berat': '80 gram',
        },
        {
          'nama': 'Sup Sayur Bening',
          'sub': 'Wortel, Buncis & Seledri',
          'berat': '70 gram',
        },
        {
          'nama': 'Perkedel Kentang Kukus',
          'sub': 'Karbohidrat & Protein Telur',
          'berat': '40 gram',
        },
      ],
      'potensi_alergen': ['Telur'],
      'estimasi_biaya_per_porsi': 15000,
      'foto_url':
          'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=600&q=80',
      'photoUrl':
          'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=600&q=80',
      'rating_rata_rata': 4.8,
      'tanggal_jadwal': 'Kamis, 20 Agustus 2026',
    },
    {
      'id_menu': 'mnu_151900ee',
      'nama_menu': 'Nasi Pesmol Ikan Nila & Sayur Asem Segar',
      'name': 'Nasi Pesmol Ikan Nila & Sayur Asem Segar',
      'kategori': 'MAKANAN_BERAT',
      'category': 'Makanan Berat',
      'kalori_kkal': 470,
      'calories': 470,
      'protein_gram': 29.5,
      'protein': '29.5g',
      'karbohidrat_gram': 56.0,
      'lemak_gram': 10.5,
      'komposisi_bahan': ['Ikan Nila Pesmol Bumbu Kuning', 'Sayur Asem Segar', 'Nasi Putih'],
      'komposisi_bahan_detail': [
        {
          'nama': 'Ikan Nila Pesmol Bumbu Kuning',
          'sub': 'Protein Ikan & Kunyit Antioksidan',
          'berat': '85 gram',
        },
        {
          'nama': 'Sayur Asem Segar',
          'sub': 'Labu Siam & Kacang Panjang',
          'berat': '65 gram',
        },
        {
          'nama': 'Nasi Putih Warm',
          'sub': 'Karbohidrat Utama',
          'berat': '150 gram',
        },
      ],
      'potensi_alergen': ['Kacang Tanah'],
      'estimasi_biaya_per_porsi': 15000,
      'foto_url':
          'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?auto=format&fit=crop&w=600&q=80',
      'photoUrl':
          'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?auto=format&fit=crop&w=600&q=80',
      'rating_rata_rata': 4.7,
      'tanggal_jadwal': 'Jumat, 21 Agustus 2026',
    },
  ];

  // 4. Menu Hari Ini & Menu Besok (Direct Reference ke foodMenuList 100% UNIFIED DATA)
  static Map<String, dynamic> get todayMenu => foodMenuList[0];
  static Map<String, dynamic> get tomorrowMenu => foodMenuList[1];

  // 5. Data Ringkasan Porsi untuk SPPG Kota Padang
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

  // 6. Master Bank Preset Bahan Makanan Sehat SPPG (Tinggal Pilih & Tambah)
  static const List<Map<String, String>> masterHealthyIngredients = [
    {
      'nama': 'Dada Ayam Bakar Kecap',
      'sub': 'Sumber Utama Protein & Zat Besi',
      'berat': '80 gram',
    },
    {
      'nama': 'Daging Sapi Semur Empuk',
      'sub': 'Kaya Asam Amino & Protein Sapi',
      'berat': '90 gram',
    },
    {
      'nama': 'Ikan Kembung Bakar Rempah',
      'sub': 'Tinggi Omega-3 & DHA',
      'berat': '85 gram',
    },
    {
      'nama': 'Udang Segar Tumis Paprika',
      'sub': 'Tinggi Protein & Zinc',
      'berat': '80 gram',
    },
    {
      'nama': 'Telur Rebus Organik',
      'sub': 'Sumber Kolin & Vitamin B12',
      'berat': '50 gram',
    },
    {
      'nama': 'Nasi Putih Warm',
      'sub': 'Karbohidrat Kompleks Utama',
      'berat': '150 gram',
    },
    {
      'nama': 'Tumis Buncis & Wortel',
      'sub': 'Kaya Serat & Vitamin A',
      'berat': '60 gram',
    },
    {
      'nama': 'Tumis Bayam & Jagung Manis',
      'sub': 'Asam Folat & Zat Besi',
      'berat': '65 gram',
    },
    {
      'nama': 'Capcay Sayur Kombinasi',
      'sub': 'Kembang Kol, Wortel & Sawi',
      'berat': '70 gram',
    },
    {
      'nama': 'Tahu & Tempe Bacem Kukus',
      'sub': 'Isoflavon & Protein Nabati',
      'berat': '50 gram',
    },
    {
      'nama': 'Susu Sapi Segar UHT 200ml',
      'sub': 'Kalsium & Vitamin D',
      'berat': '200 ml',
    },
    {
      'nama': 'Pisang Ambon Organik',
      'sub': 'Kalium & Energi Cepat',
      'berat': '120 gram',
    },
  ];
}
