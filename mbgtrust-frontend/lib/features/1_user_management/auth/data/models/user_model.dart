/// Model data Pengguna / User (Penerima Manfaat, SPPG Admin, Petugas Sekolah)
class UserModel {
  final int idPengguna;
  final String? nikNisn;
  final String namaLengkap;
  final String peran; // PENERIMA_MANFAAT, SPPG_ADMIN, PETUGAS_SEKOLAH
  final int? idSekolah;
  final String? namaSekolah;
  final String? tingkatKelas;
  final List<String> riwayatAlergi;
  final String? nomorKontak;

  UserModel({
    required this.idPengguna,
    this.nikNisn,
    required this.namaLengkap,
    required this.peran,
    this.idSekolah,
    this.namaSekolah,
    this.tingkatKelas,
    this.riwayatAlergi = const [],
    this.nomorKontak,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    var rawAlergi = json['riwayat_alergi'] as List<dynamic>? ?? [];
    List<String> alergiList = rawAlergi.map((e) => e.toString()).toList();

    return UserModel(
      idPengguna: (json['id_pengguna'] as num?)?.toInt() ?? 0,
      nikNisn: json['nik_nisn'] as String?,
      namaLengkap: json['nama_lengkap'] as String? ?? '',
      peran: json['peran'] as String? ?? 'PENERIMA_MANFAAT',
      idSekolah: (json['id_sekolah'] as num?)?.toInt(),
      namaSekolah: json['nama_sekolah'] as String?,
      tingkatKelas: json['tingkat_kelas'] as String?,
      riwayatAlergi: alergiList,
      nomorKontak: json['nomor_kontak'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_pengguna': idPengguna,
      'nik_nisn': nikNisn,
      'nama_lengkap': namaLengkap,
      'peran': peran,
      'id_sekolah': idSekolah,
      'nama_sekolah': namaSekolah,
      'tingkat_kelas': tingkatKelas,
      'riwayat_alergi': riwayatAlergi,
      'nomor_kontak': nomorKontak,
    };
  }
}
