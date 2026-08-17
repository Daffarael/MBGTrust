/**
 * Seeder Data Demo MBGTrust
 * Jalankan: node prisma/seed.js
 *
 * AKUN DEMO (semua pakai sandi: MbgTrust@2026!)
 * Super Admin   -> email: superadmin@mbgtrust.go.id
 * Admin SPPG 1  -> email: admin.sppg1@mbgtrust.go.id
 * Admin SPPG 2  -> email: admin.sppg2@mbgtrust.go.id
 * Admin SPPG 3  -> email: admin.sppg3@mbgtrust.go.id
 * Siswa Jakarta -> nik_nisn: 1000012026 s/d 1000102026
 * Siswa Bandung -> nik_nisn: 2000012026 s/d 2000102026
 * Siswa Sby     -> nik_nisn: 3000012026 s/d 3000102026
 */

import 'dotenv/config';
import bcrypt from 'bcryptjs';
import prisma from '../src/config/prisma.js';
import { analisaSentimenUlasan } from '../src/modules/evaluasi/nlp.service.js';

const SALT = 10;
const SANDI = 'MbgTrust@2026!';

async function main() {
  console.log('Memulai seeder MBGTrust...');

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
  console.log('  OK Database lama dibersihkan');

  const alasanList = await Promise.all([
    prisma.alasanPenolakan.create({ data: { kode: 'SAKIT',          label: 'Sakit / Tidak Masuk Sekolah' } }),
    prisma.alasanPenolakan.create({ data: { kode: 'ALERGI',         label: 'Alergi terhadap Bahan Menu' } }),
    prisma.alasanPenolakan.create({ data: { kode: 'TIDAK_SELERA',   label: 'Tidak Selera Makan' } }),
    prisma.alasanPenolakan.create({ data: { kode: 'PORSI_BERLEBIH', label: 'Porsi Terlalu Banyak' } }),
    prisma.alasanPenolakan.create({ data: { kode: 'LAINNYA',        label: 'Alasan Lainnya' } }),
  ]);
  console.log('  OK 5 alasan penolakan');

  const sekolahList = await Promise.all([
    prisma.sekolah.create({ data: { nama: 'SDN 01 Jakarta Pusat', alamat: 'Jl. Medan Merdeka No.1, Jakarta Pusat' } }),
    prisma.sekolah.create({ data: { nama: 'SMPN 5 Bandung',       alamat: 'Jl. Sumatera No.40, Bandung' } }),
    prisma.sekolah.create({ data: { nama: 'SMAN 3 Surabaya',      alamat: 'Jl. Praban No.1, Surabaya' } }),
  ]);
  console.log('  OK 3 sekolah');

  const bahanList = await Promise.all([
    prisma.bahanBaku.create({ data: { namaBahan: 'Beras Putih Organik', satuan: 'kg',    kaloriPer100g: 360, proteinPer100g: 6.8,  potensiAlergen: false, hargaPerSatuan: 16000 } }),
    prisma.bahanBaku.create({ data: { namaBahan: 'Dada Ayam Fillet',    satuan: 'kg',    kaloriPer100g: 165, proteinPer100g: 31.0, potensiAlergen: false, hargaPerSatuan: 48000 } }),
    prisma.bahanBaku.create({ data: { namaBahan: 'Daging Sapi Has',     satuan: 'kg',    kaloriPer100g: 250, proteinPer100g: 26.0, potensiAlergen: false, hargaPerSatuan: 130000 } }),
    prisma.bahanBaku.create({ data: { namaBahan: 'Ikan Nila Segar',     satuan: 'kg',    kaloriPer100g: 128, proteinPer100g: 26.0, potensiAlergen: true,  hargaPerSatuan: 38000 } }),
    prisma.bahanBaku.create({ data: { namaBahan: 'Telur Ayam Negeri',   satuan: 'kg',    kaloriPer100g: 155, proteinPer100g: 13.0, potensiAlergen: true,  hargaPerSatuan: 28000 } }),
    prisma.bahanBaku.create({ data: { namaBahan: 'Tempe Kedelai Murni', satuan: 'kg',    kaloriPer100g: 193, proteinPer100g: 20.0, potensiAlergen: true,  hargaPerSatuan: 14000 } }),
    prisma.bahanBaku.create({ data: { namaBahan: 'Tahu Putih Sutra',    satuan: 'kg',    kaloriPer100g: 76,  proteinPer100g: 8.0,  potensiAlergen: true,  hargaPerSatuan: 12000 } }),
    prisma.bahanBaku.create({ data: { namaBahan: 'Wortel Manis',        satuan: 'kg',    kaloriPer100g: 41,  proteinPer100g: 0.9,  potensiAlergen: false, hargaPerSatuan: 15000 } }),
    prisma.bahanBaku.create({ data: { namaBahan: 'Bayam Hijau Segar',   satuan: 'kg',    kaloriPer100g: 23,  proteinPer100g: 2.9,  potensiAlergen: false, hargaPerSatuan: 10000 } }),
    prisma.bahanBaku.create({ data: { namaBahan: 'Buncis Muda',         satuan: 'kg',    kaloriPer100g: 31,  proteinPer100g: 1.8,  potensiAlergen: false, hargaPerSatuan: 18000 } }),
    prisma.bahanBaku.create({ data: { namaBahan: 'Kecap Manis Tradisi', satuan: 'kg',    kaloriPer100g: 150, proteinPer100g: 2.0,  potensiAlergen: true,  hargaPerSatuan: 22000 } }),
    prisma.bahanBaku.create({ data: { namaBahan: 'Minyak Goreng Sawit', satuan: 'liter', kaloriPer100g: 884, proteinPer100g: 0.0,  potensiAlergen: false, hargaPerSatuan: 17000 } }),
  ]);
  console.log('  OK 12 master bahan baku');

  const menuData = [
    { namaMenu: 'Nasi Ayam Goreng Rempah', kaloriKkal: 520, proteinGram: 28, karbohidratGram: 65, lemakGram: 15, estimasiHargaPerPorsi: 12000, potensiAlergen: [] },
    { namaMenu: 'Nasi Ikan Bakar Kecap',   kaloriKkal: 480, proteinGram: 30, karbohidratGram: 58, lemakGram: 11, estimasiHargaPerPorsi: 11000, potensiAlergen: ['Ikan'] },
    { namaMenu: 'Nasi Telur Dadar Sayur',  kaloriKkal: 440, proteinGram: 18, karbohidratGram: 60, lemakGram: 13, estimasiHargaPerPorsi: 9000,  potensiAlergen: ['Telur'] },
    { namaMenu: 'Nasi Tempe Orek Pedas',   kaloriKkal: 420, proteinGram: 20, karbohidratGram: 62, lemakGram: 10, estimasiHargaPerPorsi: 8500,  potensiAlergen: ['Kedelai'] },
    { namaMenu: 'Nasi Daging Sapi Semur',  kaloriKkal: 560, proteinGram: 32, karbohidratGram: 64, lemakGram: 18, estimasiHargaPerPorsi: 15000, potensiAlergen: [] },
    { namaMenu: 'Nasi Tahu Balado Sayur',  kaloriKkal: 400, proteinGram: 16, karbohidratGram: 58, lemakGram: 11, estimasiHargaPerPorsi: 8000,  potensiAlergen: ['Kedelai'] },
    { namaMenu: 'Nasi Ayam Soto Bening',   kaloriKkal: 450, proteinGram: 26, karbohidratGram: 60, lemakGram: 10, estimasiHargaPerPorsi: 11500, potensiAlergen: [] },
    { namaMenu: 'Nasi Rendang Daging Sapi',kaloriKkal: 590, proteinGram: 34, karbohidratGram: 63, lemakGram: 22, estimasiHargaPerPorsi: 16000, potensiAlergen: [] },
  ];
  const menus = await Promise.all(menuData.map((m) => prisma.menu.create({ data: m })));
  await Promise.all([
    prisma.menuBahanBaku.create({ data: { idMenu: menus[0].id, idBahanBaku: bahanList[0].id, porsiPerMenu: 0.15 } }),
    prisma.menuBahanBaku.create({ data: { idMenu: menus[0].id, idBahanBaku: bahanList[1].id, porsiPerMenu: 0.12 } }),
    prisma.menuBahanBaku.create({ data: { idMenu: menus[1].id, idBahanBaku: bahanList[0].id, porsiPerMenu: 0.15 } }),
    prisma.menuBahanBaku.create({ data: { idMenu: menus[1].id, idBahanBaku: bahanList[3].id, porsiPerMenu: 0.14 } }),
    prisma.menuBahanBaku.create({ data: { idMenu: menus[2].id, idBahanBaku: bahanList[0].id, porsiPerMenu: 0.15 } }),
    prisma.menuBahanBaku.create({ data: { idMenu: menus[2].id, idBahanBaku: bahanList[4].id, porsiPerMenu: 0.08 } }),
    prisma.menuBahanBaku.create({ data: { idMenu: menus[2].id, idBahanBaku: bahanList[7].id, porsiPerMenu: 0.05 } }),
    prisma.menuBahanBaku.create({ data: { idMenu: menus[4].id, idBahanBaku: bahanList[0].id, porsiPerMenu: 0.15 } }),
    prisma.menuBahanBaku.create({ data: { idMenu: menus[4].id, idBahanBaku: bahanList[2].id, porsiPerMenu: 0.10 } }),
  ]);
  console.log('  OK 8 menu');

  const pwHash = await bcrypt.hash(SANDI, SALT);

  await prisma.pengguna.create({
    data: { namaLengkap: 'Super Administrator MBGTrust', email: 'superadmin@mbgtrust.go.id', katasandi: pwHash, peran: 'SUPER_ADMIN' },
  });

  const adminList = await Promise.all(
    sekolahList.map((s, i) => prisma.pengguna.create({
      data: { namaLengkap: `Admin SPPG ${s.nama}`, email: `admin.sppg${i + 1}@mbgtrust.go.id`, katasandi: pwHash, peran: 'SPPG_ADMIN', idSekolah: s.id },
    }))
  );

  const namaSiswa = [
    'Aditya Pratama Putra', 'Bunga Citra Maharani', 'Clarissa Devira',
    'Danishwara Al-Fatih',  'Erlangga Kusuma',      'Fathir Muhammad',
    'Giselle Anatasya',     'Hafizh Syahputra',     'Intan Permata Sari',
    'Jovanka Aurelia',
  ];

  const siswaPerSekolah = [];
  for (let si = 0; si < sekolahList.length; si++) {
    const sekolah = sekolahList[si];
    const kodeSekolah = si + 1;
    const siswaBatch = await Promise.all(
      namaSiswa.map((nama, ni) => prisma.pengguna.create({
        data: {
          nikNisn: `${kodeSekolah}${String(ni + 1).padStart(5, '0')}2026`,
          namaLengkap: nama,
          katasandi: pwHash,
          peran: 'PENERIMA_MANFAAT',
          idSekolah: sekolah.id,
          tingkatKelas: `Kelas ${4 + (ni % 3)}-A`,
          poinXp: 150 + ni * 50,
          dampakLingkunganGram: (150 + ni * 50) * 3.5,
          riwayatAlergi: ni % 4 === 0 ? ['Ikan'] : ni % 6 === 0 ? ['Telur'] : [],
        },
      }))
    );
    siswaPerSekolah.push(siswaBatch);
  }
  console.log(`  OK ${1 + adminList.length + siswaPerSekolah.flat().length} pengguna`);

  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const jadwalRecords = [];

  for (let dayOffset = -13; dayOffset <= 0; dayOffset++) {
    const tanggal = new Date(today);
    tanggal.setDate(today.getDate() + dayOffset);
    for (let si = 0; si < sekolahList.length; si++) {
      const menuIdx = Math.abs((dayOffset + 13 + si * 2) % menus.length);
      const jadwal = await prisma.jadwalMenu.create({
        data: { idMenu: menus[menuIdx].id, idSekolah: sekolahList[si].id, tanggal, targetTotalPorsi: 50 },
      });
      jadwalRecords.push({ jadwal, siswa: siswaPerSekolah[si], dayOffset });
    }
  }
  console.log(`  OK ${jadwalRecords.length} jadwal menu`);

  const contohUlasan = [
    'Tekstur daging sangat empuk dan bumbunya meresap dengan baik. Porsi karbohidrat dan protein sangat seimbang.',
    'Sayuran dimasak dengan tingkat kematangan yang pas, menjaga kesegaran dan warna alaminya. Sangat memuaskan.',
    'Rasa secara keseluruhan sangat lezat, namun suhu nasi saat disajikan sudah agak menurun.',
    'Kualitas ikan segar dan tidak amis, meskipun sedikit terlalu berminyak di bagian kulitnya.',
    'Distribusi porsi sayur dan lauk pauk sangat proporsional. Sangat mendukung pemenuhan gizi seimbang harian.',
    'Bumbu sayur terasa sedikit kurang kuat (hambar) dan teksturnya sedikit keras saat dikunyah.',
    'Kombinasi menu hari ini sangat luar biasa. Cita rasa Nusantara terasa sangat otentik dan menggugah selera.',
    'Kualitas potongan daging sangat premium, kuah kaldu kaya akan rempah dan disajikan dalam keadaan hangat.',
  ];

  let totalEvaluasi = 0, totalKonfirmasi = 0, totalNlp = 0;

  for (const { jadwal, siswa, dayOffset } of jadwalRecords) {
    if (dayOffset === 0) continue;
    for (let ni = 0; ni < siswa.length; ni++) {
      const siswaItem = siswa[ni];
      const tidakHadir = ni % 7 === 0;
      await prisma.konfirmasi.create({
        data: { idPengguna: siswaItem.id, idJadwal: jadwal.id, status: tidakHadir ? 'TIDAK_HADIR' : 'HADIR', idAlasanPenolakan: tidakHadir ? alasanList[ni % alasanList.length].id : null },
      });
      totalKonfirmasi++;
      if (tidakHadir) continue;

      const ulasan = contohUlasan[(ni + Math.abs(dayOffset)) % contohUlasan.length];
      const evaluasi = await prisma.evaluasiMenu.create({
        data: {
          idPengguna: siswaItem.id, idJadwal: jadwal.id, menerimaPorsi: true,
          penilaianRasa: 3 + (ni % 3), tingkatKesukaan: 3 + ((ni + 1) % 3), kesesuaianPorsi: 4 + (ni % 2),
          persentaseDikonsumsi: ni % 5 === 0 ? 80.0 : ni % 3 === 0 ? 95.0 : 100.0,
          volumeSisaGram: (ni % 5 === 0 ? 20 : ni % 3 === 0 ? 5 : 0) * 3.5,
          ulasanTeks: ulasan,
        },
      });
      totalEvaluasi++;

      const nlp = analisaSentimenUlasan(ulasan);
      await prisma.hasilNlp.create({
        data: { idEvaluasi: evaluasi.id, idJadwal: jadwal.id, sentimen: nlp.sentimen, kataKunci: nlp.kataKunci, skorSentimen: nlp.skorSentimen },
      });
      totalNlp++;
    }

    const totalHadir = siswa.filter((_, ni) => ni % 7 !== 0).length;
    const estimasiPorsi = Math.ceil(totalHadir * 1.05);
    await prisma.rencanaProduksi.create({ data: { idJadwal: jadwal.id, estimasiPorsi, totalHadir, totalTidakHadir: siswa.length - totalHadir, bufferPersentase: 5.0 } });
    await prisma.produksi.create({ data: { idJadwal: jadwal.id, status: 'SELESAI', jumlahDimasak: estimasiPorsi } });
    await prisma.distribusi.create({ data: { idJadwal: jadwal.id, status: 'TIBA_DI_SEKOLAH', waktuTiba: new Date(jadwal.tanggal.getTime() + 7 * 3600 * 1000) } });
  }

  console.log(`  OK ${totalKonfirmasi} konfirmasi, ${totalEvaluasi} evaluasi, ${totalNlp} NLP`);
  console.log('');
  console.log('SEEDER SELESAI! Akun demo (sandi semua: MbgTrust@2026!)');
  console.log('--------------------------------------------------------------');
  console.log('Super Admin    | email: superadmin@mbgtrust.go.id');
  console.log('Admin SPPG 1   | email: admin.sppg1@mbgtrust.go.id  (Jakarta)');
  console.log('Admin SPPG 2   | email: admin.sppg2@mbgtrust.go.id  (Bandung)');
  console.log('Admin SPPG 3   | email: admin.sppg3@mbgtrust.go.id  (Surabaya)');
  console.log('Siswa Jakarta  | nik_nisn: 1000012026 (Aditya) ... 1000102026');
  console.log('Siswa Bandung  | nik_nisn: 2000012026 (Aditya) ... 2000102026');
  console.log('Siswa Surabaya | nik_nisn: 3000012026 (Aditya) ... 3000102026');
  console.log('--------------------------------------------------------------');
}

main()
  .catch((e) => { console.error('Seeder gagal:', e); process.exit(1); })
  .finally(async () => { await prisma.$disconnect(); });
