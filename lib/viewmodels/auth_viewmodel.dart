import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  Future<bool> login(String username, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String token = data['accessToken'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        debugPrint('token tersimpan : ${prefs.getString('token')}');
        await prefs.setString('username', data['username'] ?? username);
        return true;
      } else {
        errorMessage =
            'Username atau password salah! (Kode ${response.statusCode})';
        return false;
      }
    } catch (e) {
      errorMessage =
          'Gagal terhubung ke server. Periksa koneksi internet Anda.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    return token != null && token.isNotEmpty;
  }

  Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? 'Pengguna';
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('username');
  }
}
