import 'models/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Replace dummyProducts with API-based Future
Future<List<Product>> dummyProducts() async {
  const String baseUrl = "http://localhost:3000"; 
  // ⚠️ Change to your machine IP when testing on device

  final response = await http.get(Uri.parse("$baseUrl/products"));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((item) => Product.fromJson(item)).toList();
  } else {
    throw Exception("Failed to load products");
  }
}
