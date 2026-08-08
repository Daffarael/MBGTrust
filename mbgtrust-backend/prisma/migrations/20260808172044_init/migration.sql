-- CreateTable
CREATE TABLE `pengguna` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `nik_nisn` VARCHAR(191) NULL,
    `nama_lengkap` VARCHAR(191) NOT NULL,
    `email` VARCHAR(191) NULL,
    `katasandi` VARCHAR(191) NOT NULL,
    `peran` ENUM('PENERIMA_MANFAAT', 'SPPG_ADMIN', 'PETUGAS') NOT NULL DEFAULT 'PENERIMA_MANFAAT',
    `tingkat_kelas` VARCHAR(191) NULL,
    `riwayat_alergi` JSON NULL,
    `nomor_kontak` VARCHAR(191) NULL,
    `poin_xp` INTEGER NOT NULL DEFAULT 0,
    `id_sekolah` INTEGER NULL,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `diubah_pada` DATETIME(3) NOT NULL,

    UNIQUE INDEX `pengguna_nik_nisn_key`(`nik_nisn`),
    UNIQUE INDEX `pengguna_email_key`(`email`),
    INDEX `pengguna_id_sekolah_idx`(`id_sekolah`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `token_penyegar` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `id_pengguna` INTEGER NOT NULL,
    `token` VARCHAR(512) NOT NULL,
    `kedaluwarsa` DATETIME(3) NOT NULL,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `token_penyegar_token_key`(`token`),
    INDEX `token_penyegar_id_pengguna_idx`(`id_pengguna`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sekolah` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `nama` VARCHAR(191) NOT NULL,
    `alamat` VARCHAR(191) NULL,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `menu` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `nama_menu` VARCHAR(191) NOT NULL,
    `kategori` ENUM('MAKANAN_BERAT', 'SNACK', 'MINUMAN') NOT NULL DEFAULT 'MAKANAN_BERAT',
    `deskripsi` VARCHAR(191) NULL,
    `kalori_kkal` DOUBLE NULL,
    `protein_gram` DOUBLE NULL,
    `karbohidrat_gram` DOUBLE NULL,
    `lemak_gram` DOUBLE NULL,
    `komposisi_bahan` JSON NULL,
    `potensi_alergen` JSON NULL,
    `estimasi_biaya_per_porsi` INTEGER NULL,
    `gambar_url` VARCHAR(191) NULL,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `diubah_pada` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `jadwal_menu` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `id_menu` INTEGER NOT NULL,
    `id_sekolah` INTEGER NOT NULL,
    `tanggal` DATE NOT NULL,
    `target_total_porsi` INTEGER NULL,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `jadwal_menu_tanggal_idx`(`tanggal`),
    INDEX `jadwal_menu_id_menu_idx`(`id_menu`),
    UNIQUE INDEX `jadwal_menu_id_sekolah_tanggal_key`(`id_sekolah`, `tanggal`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `evaluasi_menu` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `id_pengguna` INTEGER NOT NULL,
    `id_jadwal` INTEGER NOT NULL,
    `menerima_porsi` BOOLEAN NULL,
    `penilaian_rasa` INTEGER NULL,
    `tingkat_kesukaan` INTEGER NULL,
    `kesesuaian_porsi` INTEGER NULL,
    `persentase_sisa_makanan` DOUBLE NULL,
    `masukan_kualitatif` VARCHAR(191) NULL,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `evaluasi_menu_id_jadwal_idx`(`id_jadwal`),
    UNIQUE INDEX `evaluasi_menu_id_pengguna_id_jadwal_key`(`id_pengguna`, `id_jadwal`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `konfirmasi` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `id_pengguna` INTEGER NOT NULL,
    `id_jadwal` INTEGER NOT NULL,
    `status` ENUM('HADIR', 'TIDAK_HADIR', 'BELUM_KONFIRMASI') NOT NULL DEFAULT 'BELUM_KONFIRMASI',
    `id_alasan_penolakan` INTEGER NULL,
    `catatan_khusus` VARCHAR(191) NULL,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `diubah_pada` DATETIME(3) NOT NULL,

    INDEX `konfirmasi_id_jadwal_idx`(`id_jadwal`),
    INDEX `konfirmasi_status_idx`(`status`),
    UNIQUE INDEX `konfirmasi_id_pengguna_id_jadwal_key`(`id_pengguna`, `id_jadwal`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `alasan_penolakan` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `kode` VARCHAR(191) NOT NULL,
    `label` VARCHAR(191) NOT NULL,

    UNIQUE INDEX `alasan_penolakan_kode_key`(`kode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `rencana_produksi` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `id_jadwal` INTEGER NOT NULL,
    `estimasi_porsi` INTEGER NOT NULL,
    `total_hadir` INTEGER NOT NULL,
    `total_tidak_hadir` INTEGER NOT NULL,
    `buffer_persentase` DOUBLE NOT NULL DEFAULT 5.0,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `diubah_pada` DATETIME(3) NOT NULL,

    UNIQUE INDEX `rencana_produksi_id_jadwal_key`(`id_jadwal`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `produksi` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `id_jadwal` INTEGER NOT NULL,
    `status` ENUM('PERSIAPAN', 'MEMASAK', 'SELESAI', 'DIBATALKAN') NOT NULL DEFAULT 'PERSIAPAN',
    `jumlah_dimasak` INTEGER NULL,
    `catatan_dapur` VARCHAR(191) NULL,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `diubah_pada` DATETIME(3) NOT NULL,

    UNIQUE INDEX `produksi_id_jadwal_key`(`id_jadwal`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `distribusi` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `id_jadwal` INTEGER NOT NULL,
    `status` ENUM('DISIAPKAN', 'DIKIRIM', 'TIBA_DI_SEKOLAH', 'GAGAL') NOT NULL DEFAULT 'DISIAPKAN',
    `waktu_tiba` DATETIME(3) NULL,
    `catatan_kurir` VARCHAR(191) NULL,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `diubah_pada` DATETIME(3) NOT NULL,

    INDEX `distribusi_id_jadwal_idx`(`id_jadwal`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `eksekusi_topsis` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `periode_awal` DATE NOT NULL,
    `periode_akhir` DATE NOT NULL,
    `hasil_json` JSON NOT NULL,
    `rekomendasi_json` JSON NOT NULL,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `eksekusi_topsis_periode_awal_periode_akhir_idx`(`periode_awal`, `periode_akhir`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `pengguna` ADD CONSTRAINT `pengguna_id_sekolah_fkey` FOREIGN KEY (`id_sekolah`) REFERENCES `sekolah`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `token_penyegar` ADD CONSTRAINT `token_penyegar_id_pengguna_fkey` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `jadwal_menu` ADD CONSTRAINT `jadwal_menu_id_menu_fkey` FOREIGN KEY (`id_menu`) REFERENCES `menu`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `jadwal_menu` ADD CONSTRAINT `jadwal_menu_id_sekolah_fkey` FOREIGN KEY (`id_sekolah`) REFERENCES `sekolah`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `evaluasi_menu` ADD CONSTRAINT `evaluasi_menu_id_pengguna_fkey` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `evaluasi_menu` ADD CONSTRAINT `evaluasi_menu_id_jadwal_fkey` FOREIGN KEY (`id_jadwal`) REFERENCES `jadwal_menu`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `konfirmasi` ADD CONSTRAINT `konfirmasi_id_pengguna_fkey` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `konfirmasi` ADD CONSTRAINT `konfirmasi_id_jadwal_fkey` FOREIGN KEY (`id_jadwal`) REFERENCES `jadwal_menu`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `konfirmasi` ADD CONSTRAINT `konfirmasi_id_alasan_penolakan_fkey` FOREIGN KEY (`id_alasan_penolakan`) REFERENCES `alasan_penolakan`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `rencana_produksi` ADD CONSTRAINT `rencana_produksi_id_jadwal_fkey` FOREIGN KEY (`id_jadwal`) REFERENCES `jadwal_menu`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `produksi` ADD CONSTRAINT `produksi_id_jadwal_fkey` FOREIGN KEY (`id_jadwal`) REFERENCES `jadwal_menu`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `distribusi` ADD CONSTRAINT `distribusi_id_jadwal_fkey` FOREIGN KEY (`id_jadwal`) REFERENCES `jadwal_menu`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
