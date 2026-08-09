/**
 * Seeder Data Demo MBGTrust — Fase 2
 * Mengisi database dengan data realistis untuk demo GEMASTIK PPL.
 *
 * Jalankan: node prisma/seed.js
 * (Atau dari Railway Shell: node prisma/seed.js)
 */

import 'dotenv/config';
import bcrypt from 'bcryptjs';
import prisma from '../src/config/prisma.js';

const SALT = 10;

async function main() {
  console.log('🌱 Memulai seeder MBGTrust...');

  // ──────────────────────────────────────────────
  // 0. Bersihkan data lama (urutan: child → parent)
  // ──────────────────────────────────────────────
  await prisma.eksekusiTopsis.deleteMany();
  await prisma.distribusi.deleteMany();
  await prisma.produksi.deleteMany();
  await prisma.rencanaProduksi.deleteMany();
  await prisma.konfirmasi.deleteMany();
  await prisma.evaluasiMenu.deleteMany();
  await prisma.jadwalMenu.deleteMany();
  await prisma.tokenPenyegar.deleteMany();
  await prisma.pengguna.deleteMany();
  await prisma.menu.deleteMany();
  await prisma.alasanPenolakan.deleteMany();
  await prisma.sekolah.deleteMany();

  console.log('  ✓ Database dibersihkan');

  // ──────────────────────────────────────────────
  // 1. Alasan Penolakan (lookup table wajib)
  // ──────────────────────────────────────────────
  const alasanList = await Promise.all([
    prisma.alasanPenolakan.create({ data: { kode: 'ALERGI',          label: 'Alergi Makanan / Pantangan Medis' } }),
    prisma.alasanPenolakan.create({ data: { kode: 'SAKIT',           label: 'Sakit / Tidak Masuk Sekolah' } }),
    prisma.alasanPenolakan.create({ data: { kode: 'PANTANGAN_AGAMA', label: 'Pantangan Kepercayaan / Agama' } }),
    prisma.alasanPenolakan.create({ data: { kode: 'IZIN_ABSEN',      label: 'Izin / Kegiatan Luar Sekolah' } }),
  ]);
  console.log('  ✓ 4 alasan penolakan');

  // ──────────────────────────────────────────────
  // 2. Sekolah
  // ──────────────────────────────────────────────
  const sekolahList = await Promise.all([
    prisma.sekolah.create({ data: { nama: 'SDN 01 Menteng',         alamat: 'Jl. HOS Cokroaminoto No.1, Jakarta Pusat' } }),
    prisma.sekolah.create({ data: { nama: 'SMPN 5 Bandung',         alamat: 'Jl. Sumatera No.40, Bandung' } }),
    prisma.sekolah.create({ data: { nama: 'SMAN 3 Surabaya',        alamat: 'Jl. Praban No.1, Surabaya' } }),
  ]);
  console.log('  ✓ 3 sekolah');

  // ──────────────────────────────────────────────
  // 3. Master Menu (10 menu)
  // ──────────────────────────────────────────────
  const menuData = [
    { namaMenu: 'Nasi Ayam Goreng Rempah',    kaloriKkal: 520, proteinGram: 28, karbohidratGram: 65, lemakGram: 15, komposisiBahan: ['Nasi Putih','Ayam','Bawang Putih','Kunyit','Ketumbar'], potensiAlergen: [], estimasiHargaPerPorsi: 12000 },
    { namaMenu: 'Nasi Ikan Bakar Kecap',       kaloriKkal: 480, proteinGram: 30, karbohidratGram: 58, lemakGram: 11, komposisiBahan: ['Nasi Putih','Ikan Nila','Kecap Manis','Bawang Merah'], potensiAlergen: ['Ikan'], estimasiHargaPerPorsi: 11000 },
    { namaMenu: 'Nasi Telur Dadar Sayur',      kaloriKkal: 440, proteinGram: 18, karbohidratGram: 60, lemakGram: 13, komposisiBahan: ['Nasi Putih','Telur','Wortel','Buncis','Daun Bawang'], potensiAlergen: ['Telur'], estimasiHargaPerPorsi: 9000 },
    { namaMenu: 'Nasi Tempe Orek Pedas',       kaloriKkal: 420, proteinGram: 20, karbohidratGram: 62, lemakGram: 10, komposisiBahan: ['Nasi Putih','Tempe','Cabai Merah','Bawang Putih'], potensiAlergen: ['Kedelai'], estimasiHargaPerPorsi: 8500 },
    { namaMenu: 'Nasi Daging Sapi Semur',      kaloriKkal: 560, proteinGram: 32, karbohidratGram: 64, lemakGram: 18, komposisiBahan: ['Nasi Putih','Daging Sapi','Kentang','Kecap Manis'], potensiAlergen: [], estimasiHargaPerPorsi: 15000 },
    { namaMenu: 'Nasi Tahu Balado',            kaloriKkal: 400, proteinGram: 16, karbohidratGram: 58, lemakGram: 11, komposisiBahan: ['Nasi Putih','Tahu','Cabai Merah','Tomat'], potensiAlergen: ['Kedelai'], estimasiHargaPerPorsi: 8000 },
    { namaMenu: 'Mie Goreng Ayam Sayuran',     kaloriKkal: 490, proteinGram: 22, karbohidratGram: 70, lemakGram: 13, komposisiBahan: ['Mie Telur','Ayam','Kol','Wortel','Telur'], potensiAlergen: ['Gluten','Telur'], estimasiHargaPerPorsi: 10000 },
    { namaMenu: 'Nasi Pecel Lalapan',          kaloriKkal: 380, proteinGram: 14, karbohidratGram: 55, lemakGram: 12, komposisiBahan: ['Nasi Putih','Kacang Panjang','Bayam','Sambal Pecel'], potensiAlergen: ['Kacang Tanah'], estimasiHargaPerPorsi: 9500 },
    { namaMenu: 'Nasi Ayam Soto Bening',       kaloriKkal: 450, proteinGram: 26, karbohidratGram: 60, lemakGram: 10, komposisiBahan: ['Nasi Putih','Ayam','Kunyit','Jahe','Soun'], potensiAlergen: [], estimasiHargaPerPorsi: 11500 },
    { namaMenu: 'Nasi Rendang Daging Sapi',    kaloriKkal: 590, proteinGram: 34, karbohidratGram: 63, lemakGram: 22, komposisiBahan: ['Nasi Putih','Daging Sapi','Santan','Cabai','Serai'], potensiAlergen: [], estimasiHargaPerPorsi: 16000 },
  ];

  const menus = await Promise.all(
    menuData.map((m) => prisma.menu.create({ data: { ...m, komposisiBahan: m.komposisiBahan, potensiAlergen: m.potensiAlergen } }))
  );
  console.log('  ✓ 10 master menu');

  // ──────────────────────────────────────────────
  // 4. Pengguna: 1 Admin SPPG + 1 Petugas per sekolah + 15 siswa per sekolah
  // ──────────────────────────────────────────────
  const pwHash = await bcrypt.hash('password123', SALT);

  // Admin SPPG (1 akun, tidak terikat sekolah spesifik)
  const admin = await prisma.pengguna.create({
    data: {
      namaLengkap: 'Administrator SPPG',
      email: 'admin@sppg.id',
      katasandi: pwHash,
      peran: 'SPPG_ADMIN',
      idSekolah: sekolahList[0].id,
    },
  });

  // Petugas per sekolah
  const petugasList = await Promise.all(
    sekolahList.map((s, i) =>
      prisma.pengguna.create({
        data: {
          namaLengkap: `Petugas ${s.nama}`,
          email: `petugas.sekolah${i + 1}@sppg.id`,
          katasandi: pwHash,
          peran: 'PETUGAS',
          idSekolah: s.id,
        },
      })
    )
  );

  // Siswa per sekolah (15 per sekolah = 45 total)
  const namaSiswa = [
    'Ahmad Fauzi','Budi Santoso','Citra Dewi','Dani Pratama','Eka Putri',
    'Fajar Ramadan','Gina Lestari','Hendra Wijaya','Indah Sari','Joko Purnomo',
    'Kania Rahman','Lukman Hakim','Mira Yunita','Naufal Rizki','Olivia Permata',
  ];

  const kelasPerSekolah = [
    ['4-A','4-B','5-A','5-B','6-A','6-B','4-A','4-B','5-A','5-B','6-A','6-B','4-A','5-A','6-A'],
    ['7-A','7-B','8-A','8-B','9-A','9-B','7-A','7-B','8-A','8-B','9-A','9-B','7-A','8-A','9-A'],
    ['10-IPA','10-IPS','11-IPA','11-IPS','12-IPA','12-IPS','10-IPA','10-IPS','11-IPA','11-IPS','12-IPA','12-IPS','10-IPA','11-IPA','12-IPA'],
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
            tingkatKelas: kelasPerSekolah[si][ni],
            riwayatAlergi: ni % 5 === 0 ? ['Kacang Tanah'] : ni % 7 === 0 ? ['Telur'] : [],
          },
        })
      )
    );
    siswaPerSekolah.push(siswaBatch);
  }
  console.log(`  ✓ ${1 + petugasList.length + siswaPerSekolah.flat().length} pengguna (1 admin, ${petugasList.length} petugas, ${siswaPerSekolah.flat().length} siswa)`);

  // ──────────────────────────────────────────────
  // 5. Jadwal Menu — 30 hari, 1 menu per sekolah per hari
  // ──────────────────────────────────────────────
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const jadwalRecords = [];

  for (let dayOffset = -29; dayOffset <= 0; dayOffset++) {
    const tanggal = new Date(today);
    tanggal.setDate(today.getDate() + dayOffset);

    for (let si = 0; si < sekolahList.length; si++) {
      // Rotasi menu: (dayOffset + si * 3) mod 10
      const menuIdx = Math.abs((dayOffset + 29 + si * 3) % menus.length);
      const jadwal = await prisma.jadwalMenu.create({
        data: {
          idMenu: menus[menuIdx].id,
          idSekolah: sekolahList[si].id,
          tanggal,
          targetTotalPorsi: 50 + si * 10,
        },
      });
      jadwalRecords.push({ jadwal, siswa: siswaPerSekolah[si], dayOffset });
    }
  }
  console.log(`  ✓ ${jadwalRecords.length} jadwal menu (30 hari × 3 sekolah)`);

  // ──────────────────────────────────────────────
  // 6. Evaluasi + Konfirmasi (untuk hari lalu, bukan hari ini)
  // ──────────────────────────────────────────────
  let totalEvaluasi = 0;
  let totalKonfirmasi = 0;

  const alasanIds = alasanList.map((a) => a.id);

  for (const { jadwal, siswa, dayOffset } of jadwalRecords) {
    // Skip jadwal hari ini (belum ada evaluasi)
    if (dayOffset === 0) continue;

    for (let ni = 0; ni < siswa.length; ni++) {
      const siswaItem = siswa[ni];

      // Evaluasi — variasi realistis berdasarkan indeks siswa dan hari
      const rasa         = 3 + (ni % 3);           // 3, 4, atau 5
      const kesukaan     = 2 + (ni % 4);           // 2, 3, 4, atau 5
      const porsi        = 3 + ((ni + dayOffset) % 3); // 3, 4, atau 5
      const persentaseSisa = ni % 4 === 0 ? 25.5 : ni % 3 === 0 ? 10.2 : 4.8; // Cost
      const menerima     = ni % 8 !== 0; // 1 dari 8 tidak menerima

      await prisma.evaluasiMenu.create({
        data: {
          idPengguna:       siswaItem.id,
          idJadwal:         jadwal.id,
          menerimaPorsi:    menerima,
          penilaianRasa:    rasa,
          tingkatKesukaan:  kesukaan,
          kesesuaianPorsi:  porsi,
          persentaseSisa,
        },
      });
      totalEvaluasi++;

      // Konfirmasi — simulasi beberapa siswa tidak hadir
      const tidakHadir = ni % 6 === 0;
      await prisma.konfirmasi.create({
        data: {
          idPengguna:       siswaItem.id,
          idJadwal:         jadwal.id,
          status:           tidakHadir ? 'TIDAK_HADIR' : 'HADIR',
          idAlasanPenolakan: tidakHadir ? alasanIds[ni % alasanIds.length] : null,
        },
      });
      totalKonfirmasi++;
    }
  }
  console.log(`  ✓ ${totalEvaluasi} evaluasi menu`);
  console.log(`  ✓ ${totalKonfirmasi} konfirmasi`);

  // ──────────────────────────────────────────────
  // 7. Rencana Produksi + Produksi + Distribusi
  // ──────────────────────────────────────────────
  let totalProduksi = 0;

  for (const { jadwal, siswa, dayOffset } of jadwalRecords) {
    if (dayOffset === 0) continue; // Skip hari ini

    const totalHadir      = siswa.filter((_, ni) => ni % 6 !== 0).length;
    const totalTidakHadir = siswa.length - totalHadir;
    const estimasiPorsi   = Math.ceil(totalHadir * 1.05); // 5% buffer

    await prisma.rencanaProduksi.create({
      data: {
        idJadwal:        jadwal.id,
        estimasiPorsi,
        totalHadir,
        totalTidakHadir,
        bufferPersentase: 5.0,
      },
    });

    await prisma.produksi.create({
      data: {
        idJadwal:     jadwal.id,
        status:       'SELESAI',
        jumlahDimasak: estimasiPorsi,
      },
    });

    await prisma.distribusi.create({
      data: {
        idJadwal: jadwal.id,
        status:   'TIBA_DI_SEKOLAH',
        waktuTiba: new Date(jadwal.tanggal.getTime() + 7 * 3600 * 1000), // 07:00
      },
    });

    totalProduksi++;
  }
  console.log(`  ✓ ${totalProduksi} rencana produksi + produksi + distribusi`);

  // ──────────────────────────────────────────────
  // Ringkasan akun login
  // ──────────────────────────────────────────────
  console.log('\n✅ Seeder selesai! Akun demo:');
  console.log('  Admin SPPG → email: admin@sppg.id         | kata sandi: password123');
  console.log('  Petugas    → email: petugas.sekolah1@sppg.id | kata sandi: password123');
  console.log('  Siswa      → nik_nisn: 100012026 (sekolah 1, siswa 1) | kata sandi: password123');
}

main()
  .catch((e) => {
    console.error('❌ Seeder gagal:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
