import 'package:ecomz/data/product.dart';
import 'package:ecomz/modules/home/widgets/product_card.dart';
import 'package:ecomz/shared/app_footer.dart';
import 'package:ecomz/shared/app_header.dart';
import 'package:flutter/material.dart';
import '../../data/models/product.dart';
import '../product/product_detail_screen.dart';
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../signin_screen.dart';
import '../account/account_screen.dart'; // ✅ Import your account page

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

void _onTabTapped(int index) {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);

  if (index == 1) {
    if (authProvider.isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AccountScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SigninScreen()),
      );
    }
  } else if (index == 0) {
    // Already on Home → just update selectedIndex
    setState(() {
      selectedIndex = index;
    });
  }
}



  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final ProductService productService = ProductService();

    return Scaffold(
      appBar: AppHeader(
        title: 'Ecomz',
        isLoggedIn: authProvider.isLoggedIn,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: FutureBuilder<List<Product>>(
          future: productService.fetchProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No products found"));
            }

            final products = snapshot.data!;

            return GridView.builder(
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
                          builder: (_) => ProductDetailScreen(product: product),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SigninScreen(),
                        ),
                      );
                    }
                  },
                );
              },
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
