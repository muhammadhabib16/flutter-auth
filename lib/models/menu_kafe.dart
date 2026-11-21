class MenuKafe {
  final int id;
  final String name;
  final String image;
  final String cuisine;
  final double rating;
  final int harga;
  final String deskripsi;

  MenuKafe({
    required this.id,
    required this.name,
    required this.image,
    required this.cuisine,
    required this.rating,
    required this.harga,
    required this.deskripsi,
  });

  factory MenuKafe.fromJson(Map<String, dynamic> json) {
    final List<dynamic> listBahan = json['ingredients'] ?? [];

    return MenuKafe(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'no named',
      image: json['image'] ?? '',
      cuisine: json['cuisine'] ?? '_',
      rating: (json['rating'] ?? 0).toDouble(),
      harga: ((json['caloriesPerServing'] ?? 250) as num).toInt() * 100,
      deskripsi: listBahan.isNotEmpty
          ? 'Komposisi: ${listBahan.join(', ')}'
          : 'Menu Spesial',
    );
  }
}
