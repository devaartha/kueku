class Kue {
  final int idKategori, id;
  final String namaKue;
  final double harga;
  final int stok;
  final String? kueImage;

  Kue({
    required this.id,
    required this.idKategori,
    required this.namaKue,
    required this.harga,
    required this.stok,
    this.kueImage,
  });

  factory Kue.fromJson(Map<String, dynamic> json) {
    return Kue(
      id : json['id_kue'] as int,
      idKategori: json['id_kategori'] as int,
      namaKue: json['nama_kue'] as String,
      harga: double.parse(json['harga'].toString()),
      stok: json['stok'] as int,
      kueImage: json['kue_image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_kategori': idKategori,
      'nama_kue': namaKue,
      'harga': harga,
      'stok': stok,
      'kue_image': kueImage,
    };
  }
}
