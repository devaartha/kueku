

class User {
  final int id;
  final String name;

  User({
    required this.id,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class Order {
  final int id;
  final User user;
  final Cake kue;
  final int quantity;
  final String createdAt;

  Order({
    required this.id,
    required this.user,
    required this.kue,
    required this.quantity,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      kue: Cake.fromJson(json['kue'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      createdAt: json['created_at'] as String,
    );
  }
}

class Cake {
  final int id;
  final String namaKue;
  final double harga;

  Cake({
    required this.id,
    required this.namaKue,
    required this.harga,
  });

  factory Cake.fromJson(Map<String, dynamic> json) {
    return Cake(
      id: json['id'] as int,
      namaKue: json['nama_kue'] as String,
      harga: (json['harga'] as num).toDouble(),
    );
  }
}

