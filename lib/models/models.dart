// models.dart

class UserModel {
  final int id;
  final String name;
  final String username;
  final String foto;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.foto,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      foto: json['foto'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class HistoryModel {
  final int id;
  final String foto;
  final String hasil;
  final double akurasi;
  final DateTime createdAt;

  HistoryModel({
    required this.id,
    required this.foto,
    required this.hasil,
    required this.akurasi,
    required this.createdAt,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'],
      foto: json['foto'],
      hasil: json['hasil'],
      akurasi: (json['akurasi'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class ScanResultModel {
  final String hasil;
  final String akurasi;

  ScanResultModel({required this.hasil, required this.akurasi});
}
