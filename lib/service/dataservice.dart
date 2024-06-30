import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kueku/dto/cake.dart';
import 'package:kueku/dto/order.dart';
import 'package:kueku/endpoints/kue.dart';
import 'package:kueku/helpers/database_helper.dart'; // Sesuaikan dengan file yang berisi endpoint URL

class DataService {
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Method to fetch all cakes from backend
  static Future<List<Kue>> fetchKue() async {
    DatabaseHelper db = DatabaseHelper();
    String? token = await db.getToken();
    final response = await http.get(Uri.parse(Endpoints.kue), headers: {});
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> responseData = jsonResponse['data'];

      return responseData.map((json) => Kue.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cakes');
    }
  }

  static Future<List<Order>> fetchOrders() async {
    var token = await _secureStorage.read(key: 'jwt_token');
    final response = await http.get(Uri.parse(Endpoints.orders), headers: {
      'Authorization': 'Bearer $token',
    });
    // final response = await http.get(Uri.parse(Endpoints.orders));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> responseData = jsonResponse['data'];
      print(responseData);
      return responseData.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  // Method untuk menambahkan data Kue baru ke backend
  static Future<void> createKue(
      String idKategori, String namaKue, String stok, double price) async {
    final response = await http.post(
      Uri.parse(Endpoints.kue),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'id_kategori': idKategori,
        'nama_kue': namaKue,
        'stok': stok,
        'harga': price,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create product: ${response.statusCode}');
    }
  }

  // Method untuk memperbarui data Kue di backend berdasarkan ID
  static Future<void> updateKue(String id, String name, File? imageFile) async {
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('${Endpoints.kue}/$id'),
    );

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );
    }

    request.fields['nama_kue'] = name;

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception('Failed to update datas: ${response.statusCode}');
    }
  }

  // Method untuk menghapus data Kue dari backend berdasarkan ID
  static Future<void> deleteKue(String id) async {
    final response = await http.delete(
      Uri.parse('${Endpoints.kue}/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete datas: ${response.statusCode}');
    }
  }

  static Future<void> createOrder({required Kue kue, required int qty}) async {
    var token = await _secureStorage.read(key: 'jwt_token');
    print(token);
    try {
      final response = await http.post(
        Uri.parse('${Endpoints.orders}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'kue_id': kue.id, 'quantity': qty}),
      );

      print(response.statusCode);
      print(response.body);
    } catch (e) {
      print('Create order error: $e');
    }
  }
  static Future<void> deleteOrder({required int id}) async {
    var token = await _secureStorage.read(key: 'jwt_token');
    print(token);
    try {
      final response = await http.delete(
        Uri.parse('${Endpoints.orders}/${id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      print(response.statusCode);
      print(response.body);
    } catch (e) {
      print('Create order error: $e');
    }
  }
}
