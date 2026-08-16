/**
 * Seeder Data Demo MBGTrust — Fase Final (15 Tabel & All-Benefit TOPSIS + NLP)
 * Mengisi database dengan data realistis untuk demo GEMASTIK PPL.
 *
 * Jalankan: node prisma/seed.js
 */

import 'dotenv/config';
import bcrypt from 'bcryptjs';
import prisma from '../src/config/prisma.js';
import { analisaSentimenUlasan } from '../src/modules/evaluasi/nlp.service.js';

const SALT = 10;

async function main() {
  console.log('🌱 Memulai seeder MBGTrust (15 Tabel & All-Benefit)...');

  // ──────────────────────────────────────────────
  // 0. Bersihkan data lama (urutan: child → parent)
  // ──────────────────────────────────────────────
  await prisma.hasilNlp.deleteMany();
  await prisma.eksekusiTopsis.deleteMany();
  await prisma.distribusi.deleteMany();
  await prisma.produksi.deleteMany();
  await prisma.rencanaProduksi.deleteMany();
  await prisma.konfirmasi.deleteMany();
  await prisma.evaluasiMenu.deleteMany();
  await prisma.jadwalMenu.deleteMany();
  await prisma.menuBahanBaku.deleteMany();
  await prisma.tokenPenyegar.deleteMany();
  await prisma.pengguna.deleteMany();
  await prisma.menu.deleteMany();
  await prisma.bahanBaku.deleteMany();
  await prisma.alasanPenolakan.deleteMany();
  await prisma.sekolah.deleteMany();

  console.log('  ✓ Database lama dibersihkan');

  // ──────────────────────────────────────────────
  // 1. Alasan Penolakan (lookup table)
  // ──────────────────────────────────────────────
  const alasanList = await Promise.all([
    prisma.alasanPenolakan.create({ data: { kode: 'ALERGI',          label: 'Alergi Makanan / Pantangan Medis' } }),
    prisma.alasanPenolakan.create({ data: { kode: 'SAKIT',           label: 'Sakit / Tidak Masuk Sekolah' } }),
    prisma.alasanPenolakan.create({ data: { kode: 'PANTANGAN_AGAMA', label: 'Pantangan Kepercayaan / Agama' } }),
    prisma.alasanPenolakan.create({ data: { kode: 'IZIN_ABSEN',      label: 'Izin / Kegiatan Luar Sekolah' } }),
  ]);
  console.log('  ✓ 4 alasan penolakan');

  // ──────────────────────────────────────────────
  // 2. Master Sekolah (3 sekolah)
  // ──────────────────────────────────────────────
  const sekolahList = await Promise.all([
    prisma.sekolah.create({ data: { nama: 'SDN 01 Menteng',  alamat: 'Jl. HOS Cokroaminoto No.1, Jakarta Pusat' } }),
    prisma.sekolah.create({ data: { nama: 'SMPN 5 Bandung',  alamat: 'Jl. Sumatera No.40, Bandung' } }),
    prisma.sekolah.create({ data: { nama: 'SMAN 3 Surabaya', alamat: 'Jl. Praban No.1, Surabaya' } }),
  ]);
  console.log('  ✓ 3 sekolah');

  // ──────────────────────────────────────────────
  // 3. Master Bahan Baku (12 bahan)
  // ──────────────────────────────────────────────
  const bahanList = await Promise.all([
    prisma.bahanBaku.create({ data: { namaBahan: 'Beras Putih Organik', satuan: 'kg', kaloriPer100g: 360, proteinPer100g: 6.8,  potensiAlergen: false, hargaPerSatuan: 16000 } }),
    prisma.bahanBaku.create({ data: { namaBahan: 'Dada Ayam Fillet',    satuan: 'kg', kaloriPer100g: 165, proteinPer100g: 31.0, potensiAlergen: false, hargaPerSatuan: 48000 } }),
    prisma.bahanBaku.create({ data: { namaBahan: 'Daging Sapi Has',     satuan: 'kg', kaloriPer100g: 250, proteinPer100g: 26.0, potensiAlergen: false, hargaPerSatuan: 130000 } }),
    prisma.bahanBaku.create({ data: { namaBahan: 'Ikan Nila Segar',     satuan: 'kg', kaloriPer100g: 128, proteinPer100g: 26.0, potensiAlergen: true,  hargaPerSatuan: 38000 } }),
    prisma.bahanBaku.create({ data: { namaBahan: 'Telur Ayam Negeri',   satuan: 'kg', kaloriPer100g: 155, proteinPer100g: 13.0, potensiAlergen: true,  hargaPerSatuan: 28000 } }),
    prisma.bahanBaku.create({ data: { namaBahan: 'Tempe Kedelai Murni', satuan: 'kg', kaloriPer100g: 193, proteinPer100g: 20.0, potensiAlergen: true,  hargaPerSatuan: 14000 } }),
    prisma.bahanBaku.create({ data: { namaBahan: 'Tahu Putih Sutra',    satuan: 'kg', kaloriPer100g: 76,  proteinPer100g: 8.0,  potensiAlergen: true,  hargaPerSatuan: 12000 } }),
    prisma.bahanBaku.create({ data: { namaBahan: 'Wortel Manis',        satuan: 'kg', kaloriPer100g: 41,  proteinPer100g: 0.9,  potensiAlergen: false, hargaPerSatuan: 15000 } }),
    prisma.bahanBaku.create({ data: { namaBahan: 'Bayam Hijau Segar',   satuan: 'kg', kaloriPer100g: 23,  proteinPer100g: 2.9,  potensiAlergen: false, hargaPerSatuan: 10000 } }),
    prisma.bahanBaku.create({ data: { namaBahan: 'Buncis Muda',         satuan: 'kg', kaloriPer100g: 31,  proteinPer100g: 1.8,  potensiAlergen: false, hargaPerSatuan: 18000 } }),
    prisma.bahanBaku.create({ data: { namaBahan: 'Kecap Manis Tradisi', satuan: 'kg', kaloriPer100g: 150, proteinPer100g: 2.0,  potensiAlergen: true,  hargaPerSatuan: 22000 } }),
    prisma.bahanBaku.create({ data: { namaBahan: 'Minyak Goreng Sawit', satuan: 'liter', kaloriPer100g: 884, proteinPer100g: 0.0, potensiAlergen: false, hargaPerSatuan: 17000 } }),
  ]);
  console.log('  ✓ 12 master bahan baku');

  // ──────────────────────────────────────────────
  // 4. Master Menu (8 menu lengkap dengan nutrisi)
  // ──────────────────────────────────────────────
  const menuData = [
    { namaMenu: 'Nasi Ayam Goreng Rempah', kaloriKkal: 520, proteinGram: 28, karbohidratGram: 65, lemakGram: 15, estimasiHargaPerPorsi: 12000, potensiAlergen: [] },
    { namaMenu: 'Nasi Ikan Bakar Kecap',    kaloriKkal: 480, proteinGram: 30, karbohidratGram: 58, lemakGram: 11, estimasiHargaPerPorsi: 11000, potensiAlergen: ['Ikan'] },
    { namaMenu: 'Nasi Telur Dadar Sayur',   kaloriKkal: 440, proteinGram: 18, karbohidratGram: 60, lemakGram: 13, estimasiHargaPerPorsi: 9000,  potensiAlergen: ['Telur'] },
    { namaMenu: 'Nasi Tempe Orek Pedas',    kaloriKkal: 420, proteinGram: 20, karbohidratGram: 62, lemakGram: 10, estimasiHargaPerPorsi: 8500,  potensiAlergen: ['Kedelai'] },
    { namaMenu: 'Nasi Daging Sapi Semur',   kaloriKkal: 560, proteinGram: 32, karbohidratGram: 64, lemakGram: 18, estimasiHargaPerPorsi: 15000, potensiAlergen: [] },
    { namaMenu: 'Nasi Tahu Balado Sayur',   kaloriKkal: 400, proteinGram: 16, karbohidratGram: 58, lemakGram: 11, estimasiHargaPerPorsi: 8000,  potensiAlergen: ['Kedelai'] },
    { namaMenu: 'Nasi Ayam Soto Bening',    kaloriKkal: 450, proteinGram: 26, karbohidratGram: 60, lemakGram: 10, estimasiHargaPerPorsi: 11500, potensiAlergen: [] },
    { namaMenu: 'Nasi Rendang Daging Sapi', kaloriKkal: 590, proteinGram: 34, karbohidratGram: 63, lemakGram: 22, estimasiHargaPerPorsi: 16000, potensiAlergen: [] },
  ];

  const menus = await Promise.all(
    menuData.map((m) => prisma.menu.create({ data: m }))
  );

  // Kaitkan Pivot MenuBahanBaku
  await Promise.all([
    // Nasi Ayam Goreng
    prisma.menuBahanBaku.create({ data: { idMenu: menus[0].id, idBahanBaku: bahanList[0].id, porsiPerMenu: 0.15 } }),
    prisma.menuBahanBaku.create({ data: { idMenu: menus[0].id, idBahanBaku: bahanList[1].id, porsiPerMenu: 0.12 } }),
    // Nasi Ikan Bakar
    prisma.menuBahanBaku.create({ data: { idMenu: menus[1].id, idBahanBaku: bahanList[0].id, porsiPerMenu: 0.15 } }),
    prisma.menuBahanBaku.create({ data: { idMenu: menus[1].id, idBahanBaku: bahanList[3].id, porsiPerMenu: 0.14 } }),
    // Nasi Telur Sayur
    prisma.menuBahanBaku.create({ data: { idMenu: menus[2].id, idBahanBaku: bahanList[0].id, porsiPerMenu: 0.15 } }),
    prisma.menuBahanBaku.create({ data: { idMenu: menus[2].id, idBahanBaku: bahanList[4].id, porsiPerMenu: 0.08 } }),
    prisma.menuBahanBaku.create({ data: { idMenu: menus[2].id, idBahanBaku: bahanList[7].id, porsiPerMenu: 0.05 } }),
    // Nasi Daging Sapi Semur
    prisma.menuBahanBaku.create({ data: { idMenu: menus[4].id, idBahanBaku: bahanList[0].id, porsiPerMenu: 0.15 } }),
    prisma.menuBahanBaku.create({ data: { idMenu: menus[4].id, idBahanBaku: bahanList[2].id, porsiPerMenu: 0.10 } }),
  ]);
  console.log('  ✓ 8 menu & pivot menu_bahan_baku');

  // ──────────────────────────────────────────────
  // 5. Pengguna (Super Admin, SPPG Admin, Siswa)
  // ──────────────────────────────────────────────
  const pwHash = await bcrypt.hash('password123', SALT);

  // 1 Super Admin Nasional
  const superAdmin = await prisma.pengguna.create({
    data: {
      namaLengkap: 'Super Administrator MBGTrust',
      email: 'superadmin@mbgtrust.go.id',
      katasandi: pwHash,
      peran: 'SUPER_ADMIN',
    },
  });

  // Admin SPPG per sekolah
  const adminList = await Promise.all(
    sekolahList.map((s, i) =>
      prisma.pengguna.create({
        data: {
          namaLengkap: `Admin SPPG ${s.nama}`,
          email: `admin.sekolah${i + 1}@sppg.id`,
          katasandi: pwHash,
          peran: 'SPPG_ADMIN',
          idSekolah: s.id,
        },
      })
    )
  );

  // Siswa per sekolah (10 per sekolah)
  const namaSiswa = [
    'Ahmad Fauzi', 'Budi Santoso', 'Citra Dewi', 'Dani Pratama', 'Eka Putri',
    'Fajar Ramadan', 'Gina Lestari', 'Hendra Wijaya', 'Indah Sari', 'Joko Purnomo'
  ];

  const siswaPerSekolah = [];
  for (let si = 0; si < sekolahList.length; si++) {
    const sekolah = sekolahList[si];
    const siswaBatch = await Promise.all(
      namaSiswa.map((nama, ni) =>
        prisma.pengguna.create({
          data: {
            nikNisn: `${sekolah.id}${String(ni + 1).padStart(4, '0')}2026`,
            namaLengkap: nama,
            katasandi: pwHash,
            peran: 'PENERIMA_MANFAAT',
            idSekolah: sekolah.id,
            tingkatKelas: `Kelas ${4 + (ni % 3)}-A`,
            poinXp: 150 + ni * 50,
            dampakLingkunganGram: (150 + ni * 50) * 3.5,
            riwayatAlergi: ni % 4 === 0 ? ['Ikan'] : ni % 6 === 0 ? ['Telur'] : [],
          },
        })
      )
    );
    siswaPerSekolah.push(siswaBatch);
  }
  console.log(`  ✓ ${1 + adminList.length + siswaPerSekolah.flat().length} pengguna (1 Super Admin, ${adminList.length} SPPG Admin, ${siswaPerSekolah.flat().length} Siswa)`);

  // ──────────────────────────────────────────────
  // 6. Jadwal Menu (14 hari ke belakang + hari ini)
  // ──────────────────────────────────────────────
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const jadwalRecords = [];

  for (let dayOffset = -13; dayOffset <= 0; dayOffset++) {
    const tanggal = new Date(today);
    tanggal.setDate(today.getDate() + dayOffset);

    for (let si = 0; si < sekolahList.length; si++) {
      const menuIdx = Math.abs((dayOffset + 13 + si * 2) % menus.length);
      const jadwal = await prisma.jadwalMenu.create({
        data: {
          idMenu: menus[menuIdx].id,
          idSekolah: sekolahList[si].id,
          tanggal,
          targetTotalPorsi: 50,
        },
      });
      jadwalRecords.push({ jadwal, siswa: siswaPerSekolah[si], dayOffset });
    }
  }
  console.log(`  ✓ ${jadwalRecords.length} jadwal menu`);

  // ──────────────────────────────────────────────
  // 7. Evaluasi, Konfirmasi, & Hasil NLP
  // ──────────────────────────────────────────────
  const contohUlasan = [
    'Ayamnya sangat gurih dan renyah, porsinya pas bikin kenyang!',
    'Sayurnya segar dan bersih, enak banget dimakan hangat-hangat.',
    'Rasanya lezat dan mantap, tapi nasinya agak sedikit dingin.',
    'Ikan bakarnya agak asin dan sedikit berminyak, tapi ikannya empuk.',
    'Porsinya kurang banyak untuk saya, tapi rasanya lumayan enak.',
    'Kurang suka karena agak hambar dan sayurnya sedikit alot.',
    'Menu favorit saya! Bumbunya meresap dan sangat nikmat juara.',
    'Dagingnya empuk banget dan kuahnya gurih sedap.',
  ];

  let totalEvaluasi = 0;
  let totalKonfirmasi = 0;
  let totalNlp = 0;

  for (const { jadwal, siswa, dayOffset } of jadwalRecords) {
    if (dayOffset === 0) continue; // Skip hari ini

    for (let ni = 0; ni < siswa.length; ni++) {
      const siswaItem = siswa[ni];

      // Konfirmasi H+1
      const tidakHadir = ni % 7 === 0;
      await prisma.konfirmasi.create({
        data: {
          idPengguna: siswaItem.id,
          idJadwal: jadwal.id,
          status: tidakHadir ? 'TIDAK_HADIR' : 'HADIR',
          idAlasanPenolakan: tidakHadir ? alasanList[ni % alasanList.length].id : null,
        },
      });
      totalKonfirmasi++;

      if (tidakHadir) continue;

      // Evaluasi All-Benefit C1..C4
      const rasa = 3 + (ni % 3);                 // 3, 4, 5 (Benefit)
      const kesukaan = 3 + ((ni + 1) % 3);       // 3, 4, 5 (Benefit)
      const porsi = 4 + (ni % 2);                // 4, 5 (Benefit)
      const persentaseDikonsumsi = ni % 5 === 0 ? 80.0 : ni % 3 === 0 ? 95.0 : 100.0; // Benefit (makanan dihabiskan)
      const ulasan = contohUlasan[(ni + Math.abs(dayOffset)) % contohUlasan.length];

      const evaluasi = await prisma.evaluasiMenu.create({
        data: {
          idPengguna: siswaItem.id,
          idJadwal: jadwal.id,
          menerimaPorsi: true,
          penilaianRasa: rasa,
          tingkatKesukaan: kesukaan,
          kesesuaianPorsi: porsi,
          persentaseDikonsumsi,
          volumeSisaGram: (100 - persentaseDikonsumsi) * 3.5,
          ulasanTeks: ulasan,
        },
      });
      totalEvaluasi++;

      // Proses NLP Otomatis
      const nlp = analisaSentimenUlasan(ulasan);
      await prisma.hasilNlp.create({
        data: {
          idEvaluasi: evaluasi.id,
          idJadwal: jadwal.id,
          sentimen: nlp.sentimen,
          kataKunci: nlp.kataKunci,
          skorSentimen: nlp.skorSentimen,
        },
      });
      totalNlp++;
    }

    // Rencana Produksi & Produksi
    const totalHadir = siswa.filter((_, ni) => ni % 7 !== 0).length;
    const estimasiPorsi = Math.ceil(totalHadir * 1.05);

    await prisma.rencanaProduksi.create({
      data: {
        idJadwal: jadwal.id,
        estimasiPorsi,
        totalHadir,
        totalTidakHadir: siswa.length - totalHadir,
        bufferPersentase: 5.0,
      },
    });

    await prisma.produksi.create({
      data: {
        idJadwal: jadwal.id,
        status: 'SELESAI',
        jumlahDimasak: estimasiPorsi,
      },
    });

    await prisma.distribusi.create({
      data: {
        idJadwal: jadwal.id,
        status: 'TIBA_DI_SEKOLAH',
        waktuTiba: new Date(jadwal.tanggal.getTime() + 7 * 3600 * 1000),
      },
    });
  }

  console.log(`  ✓ ${totalKonfirmasi} konfirmasi`);
  console.log(`  ✓ ${totalEvaluasi} evaluasi menu`);
  console.log(`  ✓ ${totalNlp} analisa NLP sentimen & kata kunci`);

  console.log('\n✅ Seeder selesai! Akun demo:');
  console.log('  Super Admin → email: superadmin@mbgtrust.go.id  | sandi: password123');
  console.log('  Admin SPPG  → email: admin.sekolah1@sppg.id      | sandi: password123');
  console.log('  Siswa       → nik_nisn: 100012026                 | sandi: password123');
}

main()
  .catch((e) => {
    console.error('❌ Seeder gagal:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
