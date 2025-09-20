import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../data/models/product.dart';
import '../../data/product.dart'; // ProductService
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'edit_product.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late Future<List<Product>> productsFuture;

  @override
  void initState() {
    super.initState();
    productsFuture = ProductService().fetchProducts();
  }

  void refreshProducts() {
    setState(() {
      productsFuture = ProductService().fetchProducts();
    });
  }

  void editProduct(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProductFormScreen(
          product: product,
          onUpdated: refreshProducts,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Products")),
      body: FutureBuilder<List<Product>>(
        future: productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No products found"));
          }

          final products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                leading: product.imageUrl != null
                    ? Image.network(product.imageUrl!, width: 50, height: 50)
                    : const Icon(Icons.image),
                title: Text(product.title),
                subtitle: Text("\$${product.price.toString()}"),
                trailing: ElevatedButton(
                  onPressed: () => editProduct(product),
                  child: const Text("Edit"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
