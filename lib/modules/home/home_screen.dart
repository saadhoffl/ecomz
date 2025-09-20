import 'package:ecomz/data/product.dart';
import 'package:ecomz/modules/home/widgets/product_card.dart';
import 'package:ecomz/shared/app_footer.dart';
import 'package:ecomz/shared/app_header.dart';
import 'package:flutter/material.dart';
import '../../data/models/product.dart';
import '../product/product_detail_screen.dart';
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../auth/signin_screen.dart';
import '../account/account_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  late Future<List<Product>> _productsFuture;
  final ProductService _productService = ProductService();

  @override
  void initState() {
    super.initState();
    _productsFuture = _productService.fetchProducts();
  }

  void _onTabTapped(int index) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (index == 1) {
      if (authProvider.isLoggedIn) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AccountScreen()),
        ).then((_) => _refreshProducts()); // Refresh after coming back
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SigninScreen()),
        ).then((_) => _refreshProducts());
      }
    } else if (index == 0) {
      setState(() {
        selectedIndex = index;
        _refreshProducts(); // Refresh when tapping home tab
      });
    }
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _productsFuture = _productService.fetchProducts();
    });
    await _productsFuture;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppHeader(
        title: 'Ecomz',
        isLoggedIn: authProvider.isLoggedIn,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: FutureBuilder<List<Product>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No products found"));
            }

            final products = snapshot.data!;

            return RefreshIndicator(
              onRefresh: _refreshProducts,
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    product: product,
                    onTap: () {
                      if (authProvider.isLoggedIn) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailScreen(product: product),
                          ),
                        ).then((_) => _refreshProducts()); // Refresh after returning from product detail
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SigninScreen(),
                          ),
                        ).then((_) => _refreshProducts());
                      }
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: AppFooter(
        currentIndex: selectedIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
