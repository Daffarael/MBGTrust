/// Model data Pengguna / User (Penerima Manfaat, SPPG Admin, Petugas Sekolah)
class UserModel {
  final String idPengguna;
  final String? nikNisn;
  final String namaLengkap;
  final String peran; // PENERIMA_MANFAAT, SPPG_ADMIN, PETUGAS_SEKOLAH
  final String? idSekolah;
  final String? namaSekolah;
  final String? tingkatKelas;
  final List<String> riwayatAlergi;
  final String? nomorTelepon;

  UserModel({
    required this.idPengguna,
    this.nikNisn,
    required this.namaLengkap,
    required this.peran,
    this.idSekolah,
    this.namaSekolah,
    this.tingkatKelas,
    this.riwayatAlergi = const [],
    this.nomorTelepon,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    var rawAlergi = json['riwayat_alergi'] as List<dynamic>? ?? [];
    List<String> alergiList = rawAlergi.map((e) => e.toString()).toList();

    return UserModel(
      idPengguna: json['id_pengguna'] as String? ?? '',
      nikNisn: json['nik_nisn'] as String?,
      namaLengkap: json['nama_lengkap'] as String? ?? '',
      peran: json['peran'] as String? ?? 'PENERIMA_MANFAAT',
      idSekolah: json['id_sekolah'] as String?,
      namaSekolah: json['nama_sekolah'] as String?,
      tingkatKelas: json['tingkat_kelas'] as String?,
      riwayatAlergi: alergiList,
      nomorTelepon: json['nomor_telepon'] as String?,
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
      'nomor_telepon': nomorTelepon,
    };
  }
}
