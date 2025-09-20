import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../shared/app_footer.dart';
import '../../shared/app_header.dart';
import '../../signin_screen.dart';
import '../admin/add_product.dart';
import '../admin/view_edit_product.dart';
import '../admin/view_delete_product.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int selectedIndex = 1; // Account tab is index 1

  void _onTabTapped(int index) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      selectedIndex = index;
    });

    if (index == 0) {
      // Go to Home
      Navigator.pop(context); // Or push HomeScreen if needed
    }
    // Account is index 1 → already here
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppHeader(
        title: 'Account',
        isLoggedIn: authProvider.isLoggedIn,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Logged in as:",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Text(
              authProvider.userEmail ?? "Unknown",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddProductScreen()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Product"),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditProductScreen()),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit Product"),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DeleteProductScreen()),
                );
              },
              icon: const Icon(Icons.delete),
              label: const Text("Delete Product"),
            ),
            // const SizedBox(height: 12),
            // ElevatedButton.icon(
            //   onPressed: () {
            //     // TODO: Navigate to Settings screen
            //   },
            //   icon: const Icon(Icons.settings),
            //   label: const Text("Settings"),
            // ),
            // const SizedBox(height: 24),
            // Center(
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.red,
            //     ),
            //     onPressed: () {
            //       authProvider.logout();
            //       Navigator.pushAndRemoveUntil(
            //         context,
            //         MaterialPageRoute(builder: (_) => const SigninScreen()),
            //         (route) => false,
            //       );
            //     },
            //     child: const Text("Logout"),
            //   ),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: AppFooter(
        currentIndex: selectedIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
