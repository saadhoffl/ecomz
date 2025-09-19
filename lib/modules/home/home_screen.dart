import 'package:ecomz/data/dummy_data.dart';
import 'package:ecomz/modules/home/widgets/product_card.dart';
import 'package:ecomz/shared/app_footer.dart';
import 'package:ecomz/shared/app_header.dart';
import 'package:flutter/material.dart';
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
      // TODO: Navigate to Cart or Account if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppHeader(title: 'Ecomz', isLoggedIn: authProvider.isLoggedIn,),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: dummyProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final product = dummyProducts[index];
            return ProductCard(product: product);
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
