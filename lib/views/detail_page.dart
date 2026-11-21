import 'package:flutter/material.dart';

import '../models/menu_kafe.dart';
import '../viewmodels/menu_viewmodel.dart';

class DetailPage extends StatelessWidget {
  final MenuKafe menu;
  final MenuViewModel viewModel;

  const DetailPage({super.key, required this.menu, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(menu.name),
        actions: [
          ListenableBuilder(
            listenable: viewModel,
            builder: (context, child) {
              final isFav = viewModel.isFavorit(menu.id);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : null,
                ),
                onPressed: () => viewModel.toggleFavorit(menu.id),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              menu.image,
              height: 240,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox(
                height: 240,
                child: Center(child: Icon(Icons.broken_image, size: 64)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(label: Text(menu.cuisine)),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            menu.rating.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    menu.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Rp ${menu.harga} / porsi',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.brown,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    menu.deskripsi,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                  const Divider(height: 32),

                  ListenableBuilder(
                    listenable: viewModel,
                    builder: (context, child) {
                      final total = viewModel.hitungTotalHarga(menu.harga);
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Jumlah Porsi',
                                style: TextStyle(fontSize: 16),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: viewModel.kurangPorsi,
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                    ),
                                  ),
                                  Text(
                                    '${viewModel.jumlahPorsi}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: viewModel.tambahPorsi,
                                    icon: const Icon(Icons.add_circle_outline),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Harga',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Rp $total',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
