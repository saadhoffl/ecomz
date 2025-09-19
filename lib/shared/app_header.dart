import 'package:flutter/material.dart';
import '../signin_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  // Simulated login state (you can replace with real auth later)
  final bool isLoggedIn;

  const AppHeader({
    super.key,
    required this.title,
    this.isLoggedIn = false, // default: not logged in
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return AppBar(
      backgroundColor: Colors.grey[900],
      foregroundColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // 🔵 Blue background
              foregroundColor: Colors.white, // White text
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () {
               if (isLoggedIn) {
               authProvider.logout();
              } else {
                // 🔑 Navigate to signin screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SigninScreen()),
                );
              }
            },
            child: Text(isLoggedIn ? 'Logout' : 'Sign In'),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
