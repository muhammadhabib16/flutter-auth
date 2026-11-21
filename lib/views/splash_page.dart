import 'package:flutter/material.dart';

import '../viewmodels/auth_viewmodel.dart';
import 'login_page.dart';
import 'menu_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AuthViewModel authViewModel = AuthViewModel();

  @override
  void initState() {
    super.initState();
    _cekSesiLogin();
  }

  Future<void> _cekSesiLogin() async {
    await Future.delayed(const Duration(seconds: 1));
    final bool sudahLogin = await authViewModel.isLoggedIn();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => sudahLogin ? const MenuPage() : const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
