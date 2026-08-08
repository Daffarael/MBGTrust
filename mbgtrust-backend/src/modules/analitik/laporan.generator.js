import PDFDocument from 'pdfkit';
import ExcelJS from 'exceljs';

// ─── PDF Generator ─────────────────────────────────────────────

export const buatLaporanPdf = (res, { ringkasan, detailMenu }) => {
  const doc = new PDFDocument({ margin: 50, size: 'A4' });

  res.setHeader('Content-Type', 'application/pdf');
  res.setHeader(
    'Content-Disposition',
    `attachment; filename="laporan-mbgtrust-${ringkasan.periode.tanggal_mulai}-${ringkasan.periode.tanggal_selesai}.pdf"`
  );
  doc.pipe(res);

  // Header
  doc.fontSize(18).font('Helvetica-Bold').text('Laporan Evaluasi & Audit Program MBGTrust', { align: 'center' });
  doc.fontSize(11).font('Helvetica').text(
    `Periode: ${ringkasan.periode.tanggal_mulai} s.d. ${ringkasan.periode.tanggal_selesai}`,
    { align: 'center' }
  );
  doc.moveDown(1.5);

  // Ringkasan
  doc.fontSize(13).font('Helvetica-Bold').text('Ringkasan Dasbor');
  doc.moveDown(0.5);
  doc.fontSize(11).font('Helvetica');
  const metrikList = [
    ['Skor Kepuasan Keseluruhan', `${ringkasan.skor_kepuasan_keseluruhan} / 5.00`],
    ['Tingkat Penerimaan Menu', `${ringkasan.persentase_tingkat_penerimaan_menu}%`],
    ['Food Waste Tercegah', `${ringkasan.food_waste_tercegah_kg} kg`],
    ['Estimasi Efisiensi Anggaran', `Rp ${ringkasan.estimasi_efisiensi_anggaran_rupiah.toLocaleString('id-ID')}`],
  ];
  for (const [label, nilai] of metrikList) {
    doc.text(`• ${label}: ${nilai}`);
  }
  doc.fontSize(8).fillColor('gray').text(`*) ${ringkasan.catatan}`);
  doc.fillColor('black').moveDown(1.5);

  // Tabel detail per jadwal
  doc.fontSize(13).font('Helvetica-Bold').text('Rincian per Jadwal Menu');
  doc.moveDown(0.5);

  const kolomHeader = ['Tanggal', 'Menu', 'Porsi Dasar', 'Estimasi', 'Evaluasi', 'Avg Rasa', 'Sisa %', 'Hadir', 'Tdk Hadir'];
  const lebarKolom  = [65, 130, 52, 52, 45, 45, 40, 35, 50];

  // Header tabel
  doc.fontSize(8).font('Helvetica-Bold');
  let xPos = 50;
  kolomHeader.forEach((header, i) => {
    doc.text(header, xPos, doc.y, { width: lebarKolom[i], align: 'left' });
    xPos += lebarKolom[i];
  });
  doc.moveDown(0.3);
  doc.moveTo(50, doc.y).lineTo(555, doc.y).stroke();
  doc.moveDown(0.3);

  // Baris tabel
  doc.font('Helvetica').fontSize(7.5);
  for (const baris of detailMenu) {
    const nilaiKolom = [
      baris.tanggal,
      baris.nama_menu,
      String(baris.target_porsi ?? '-'),
      String(baris.estimasi_porsi),
      String(baris.total_evaluasi),
      String(baris.rata_rasa),
      `${baris.rata_sisa_persen}%`,
      String(baris.total_hadir),
      String(baris.total_tidak_hadir),
    ];
    const yBaris = doc.y;
    xPos = 50;
    nilaiKolom.forEach((val, i) => {
      doc.text(val, xPos, yBaris, { width: lebarKolom[i], align: 'left' });
      xPos += lebarKolom[i];
    });
    doc.moveDown(0.4);

    // Tambah halaman baru jika habis
    if (doc.y > 750) {
      doc.addPage();
      doc.moveDown(0.5);
    }
  }

  doc.moveDown(1);
  doc.fontSize(8).fillColor('gray').text(`Dokumen dibuat otomatis oleh sistem MBGTrust — ${new Date().toLocaleString('id-ID')}`, { align: 'center' });

  doc.end();
};

// ─── Excel Generator ───────────────────────────────────────────

export const buatLaporanExcel = async (res, { ringkasan, detailMenu }) => {
  const workbook  = new ExcelJS.Workbook();
  workbook.creator = 'MBGTrust';
  workbook.created = new Date();

  // Sheet 1: Ringkasan
  const sheetRingkasan = workbook.addWorksheet('Ringkasan Dasbor');
  sheetRingkasan.columns = [
    { header: 'Metrik', key: 'metrik', width: 40 },
    { header: 'Nilai', key: 'nilai', width: 25 },
  ];
  sheetRingkasan.addRows([
    { metrik: 'Periode', nilai: `${ringkasan.periode.tanggal_mulai} s.d. ${ringkasan.periode.tanggal_selesai}` },
    { metrik: 'Skor Kepuasan Keseluruhan', nilai: ringkasan.skor_kepuasan_keseluruhan },
    { metrik: 'Tingkat Penerimaan Menu (%)', nilai: ringkasan.persentase_tingkat_penerimaan_menu },
    { metrik: 'Food Waste Tercegah (kg)*', nilai: ringkasan.food_waste_tercegah_kg },
    { metrik: 'Estimasi Efisiensi Anggaran (Rp)', nilai: ringkasan.estimasi_efisiensi_anggaran_rupiah },
    { metrik: '*Catatan', nilai: ringkasan.catatan },
  ]);
  sheetRingkasan.getRow(1).font = { bold: true };

  // Sheet 2: Detail per Jadwal
  const sheetDetail = workbook.addWorksheet('Detail Per Jadwal');
  sheetDetail.columns = [
    { header: 'Tanggal',          key: 'tanggal',           width: 14 },
    { header: 'Nama Menu',        key: 'nama_menu',         width: 35 },
    { header: 'Kategori',         key: 'kategori',          width: 18 },
    { header: 'Target Porsi',     key: 'target_porsi',      width: 14 },
    { header: 'Estimasi Porsi',   key: 'estimasi_porsi',    width: 14 },
    { header: 'Total Evaluasi',   key: 'total_evaluasi',    width: 14 },
    { header: 'Avg Rasa (1-5)',   key: 'rata_rasa',         width: 14 },
    { header: 'Avg Kesukaan',     key: 'rata_kesukaan',     width: 14 },
    { header: 'Avg Porsi',        key: 'rata_porsi',        width: 12 },
    { header: 'Avg Sisa (%)',     key: 'rata_sisa_persen',  width: 12 },
    { header: 'Total Hadir',      key: 'total_hadir',       width: 12 },
    { header: 'Total Tdk Hadir',  key: 'total_tidak_hadir', width: 16 },
  ];
  sheetDetail.addRows(detailMenu);
  sheetDetail.getRow(1).font = { bold: true };

  res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
  res.setHeader(
    'Content-Disposition',
    `attachment; filename="laporan-mbgtrust-${ringkasan.periode.tanggal_mulai}-${ringkasan.periode.tanggal_selesai}.xlsx"`
  );

  await workbook.xlsx.write(res);
  res.end();
};
