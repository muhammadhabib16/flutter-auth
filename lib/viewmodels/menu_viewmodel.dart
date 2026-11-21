import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/menu_kafe.dart';

class MenuViewModel extends ChangeNotifier {
  List<MenuKafe> menus = [];
  bool isLoading = false;
  String? errorMessage;

  int jumlahPorsi = 1;
  final Set<int> _favoritIds = {};

  Future<void> fetchMenus() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://dummyjson.com/recipes'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> list = data['recipes'];
        menus = list.map((item) => MenuKafe.fromJson(item)).toList();
      } else {
        errorMessage = 'Server Bermasalah (kode ${response.statusCode})';
      }
    } catch (e) {
      errorMessage = 'Gagal memuat data. Periksa koneksi internet anda.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void resetPorsi() {
    jumlahPorsi = 1;
    notifyListeners();
  }

  void tambahPorsi() {
    jumlahPorsi++;
    notifyListeners();
  }

  void kurangPorsi() {
    if (jumlahPorsi > 1) {
      jumlahPorsi--;
      notifyListeners();
    }
  }

  int hitungTotalHarga(int hargaSatuan) => hargaSatuan * jumlahPorsi;

  bool isFavorit(int menuId) => _favoritIds.contains(menuId);

  void toggleFavorit(int menuId) {
    if (_favoritIds.contains(menuId)) {
      _favoritIds.remove(menuId);
    } else {
      _favoritIds.add(menuId);
    }
    notifyListeners();
  }
}
