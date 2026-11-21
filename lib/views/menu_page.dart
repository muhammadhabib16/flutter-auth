import 'package:flutter/material.dart';

import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/menu_viewmodel.dart';
import 'detail_page.dart';
import 'login_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final MenuViewModel menuViewModel = MenuViewModel();
  final AuthViewModel authViewModel = AuthViewModel();
  String namaUser = '';

  @override
  void initState() {
    super.initState();
    menuViewModel.fetchMenus();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final user = await authViewModel.getUsername();
    if (mounted) {
      setState(() => namaUser = user);
    }
  }

  Future<void> _handleLogout() async {
    await authViewModel.logout();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(namaUser.isEmpty ? 'Menu Kafe' : 'Halo, $namaUser'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat Ulang',
            onPressed: () => menuViewModel.fetchMenus(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: menuViewModel,
        builder: (context, child) {
          // 1. State Loading
          if (menuViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. State Error
          if (menuViewModel.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
                    const SizedBox(height: 12),
                    Text(
                      menuViewModel.errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => menuViewModel.fetchMenus(),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3. State Data Berhasil Dimuat
          return ListView.builder(
            itemCount: menuViewModel.menus.length,
            itemBuilder: (context, index) {
              final menu = menuViewModel.menus[index];
              final isFav = menuViewModel.isFavorit(menu.id);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      menu.image,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.fastfood, size: 40),
                    ),
                  ),
                  title: Text(
                    menu.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${menu.cuisine} • Rp ${menu.harga}'),
                  trailing: Icon(
                    isFav ? Icons.favorite : Icons.chevron_right,
                    color: isFav ? Colors.red : Colors.grey,
                  ),
                  onTap: () {
                    menuViewModel.resetPorsi();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailPage(menu: menu, viewModel: menuViewModel),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
