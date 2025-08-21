class CategoryConstants {
  static const Map<String, String> categoryEmojis = {
    // Pemasukan
    'Gaji': '💰',
    'Bonus': '🎁',
    'Investasi': '📈',
    'Lainnya': '📦',

    // Pengeluaran
    'Makanan': '🍔',
    'Transportasi': '🚗',
    'Hiburan': '🎬',
    'Tagihan': '🧾',
  };

  static List<String> get kategoriPemasukan => [
    'Gaji',
    'Bonus',
    'Investasi',
    'Lainnya',
  ];
  static List<String> get kategoriPengeluaran => [
    'Makanan',
    'Transportasi',
    'Hiburan',
    'Tagihan',
    'Lainnya',
  ];

  static String getEmojiForCategory(String category) {
    return categoryEmojis[category] ?? '📦'; // Default emoji
  }
}
