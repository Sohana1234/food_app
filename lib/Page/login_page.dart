import 'package:flutter/material.dart';
import 'package:my_ecommerce_app/Page/register_page.dart';

import 'package:my_ecommerce_app/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    try {
      await authService.signInWithEmailPassword(email, password);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error:$e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:const Text("Sign In"),
        ),
        body: ListView(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 50),
      children: [
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: "Email"),
        ),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: "Password"),
        ),
        const SizedBox(height: 12),
        ElevatedButton(onPressed: login, child: const Text("Login")),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: ()=>Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=>const RegisterPage())
          ),
          child: Center(child: Text("Don't have account? SignUp")),
        ),
      ],
    ));
  }
}
