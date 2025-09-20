import 'package:flutter/material.dart';           // Flutter widgets
import 'dart:convert';                             // jsonEncode / jsonDecode
import 'package:http/http.dart' as http;           // http requests
import '../../data/models/product.dart'; 

class EditProductFormScreen extends StatefulWidget {
  final Product product;
  final VoidCallback onUpdated;

  const EditProductFormScreen({
    super.key,
    required this.product,
    required this.onUpdated,
  });

  @override
  State<EditProductFormScreen> createState() => _EditProductFormScreenState();
}

class _EditProductFormScreenState extends State<EditProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;
  late String price;
  late String imageUrl;

  bool isLoading = false;

  final String baseUrl = "http://localhost:3000"; 

  @override
  void initState() {
    super.initState();
    title = widget.product.title;
    description = widget.product.description ?? '';
    price = widget.product.price.toString();
    imageUrl = widget.product.imageUrl ?? '';
  }

  Future<void> updateProduct() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => isLoading = true);

    try {
      final response = await http.put(
        Uri.parse("$baseUrl/edit_product/${widget.product.id}"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "title": title,
          "description": description,
          "price": double.tryParse(price) ?? 0,
          "imageUrl": imageUrl,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product updated successfully!")),
        );
        widget.onUpdated();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Error updating product")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Product")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter title" : null,
                onSaved: (val) => title = val!,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: "Description"),
                onSaved: (val) => description = val ?? '',
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: price,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter price" : null,
                onSaved: (val) => price = val!,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: imageUrl,
                decoration: const InputDecoration(labelText: "Image URL"),
                onSaved: (val) => imageUrl = val ?? '',
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: updateProduct,
                      child: const Text("Update Product"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
