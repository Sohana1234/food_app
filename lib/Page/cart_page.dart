import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import 'home_page.dart';

class CartPage extends StatefulWidget {
  final String? bannerMessage;

  const CartPage({super.key, this.bannerMessage});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final authService = AuthService();

  void logout() async {
    await authService.signOut();
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Grocery"),
        actions: [
          IconButton(onPressed: logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.only(
                  left: 80.0, right: 80, bottom: 40, top: 160),
              child: Image.asset('lib/images/Avocado.png'),
            ),


            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                "We deliver groceries at your doorstep",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),


            Text(
              "Fresh Items everyday",
              style: TextStyle(
                  fontSize: 18,
                color:Colors.grey[600]
              ),
            ),

            const SizedBox(height: 40),

            GestureDetector(
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const HomePage();
                  },
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(24),
                child: const Text(
                  "Get Started",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
