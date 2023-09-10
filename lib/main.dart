// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(
    home: DiscoverListPage(),
  ));
}

class DiscoverItem {
  final String id;
  final String title;

  DiscoverItem({required this.id, required this.title});
}

class DiscoverListPage extends StatefulWidget {
  const DiscoverListPage({super.key});

  @override
  _DiscoverListPageState createState() => _DiscoverListPageState();
}

class _DiscoverListPageState extends State<DiscoverListPage> {
  List<DiscoverItem> discoverItems = [
    DiscoverItem(id: '1', title: 'Öğe 1'),
    DiscoverItem(id: '2', title: 'Öğe 2'),
    DiscoverItem(id: '3', title: 'Öğe 3'),
    DiscoverItem(id: '4', title: 'Öğe 4'),
    DiscoverItem(id: '5', title: 'Öğe 5'),
    DiscoverItem(id: '6', title: 'Öğe 6'),
  ];

  List<String> favoriteIds = []; //Favorilere eklememiz için getirilen listemiz.
  //Localde tutulan listenin değişkeni

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    //Eğer daha önce localde veri varsa bunların getirilmesini sağlayan fonksiyon.
    final prefs = await SharedPreferences.getInstance();
    final savedFavorites =
        prefs.getStringList('favorites') ?? []; //girilen keye ait değeri getir.
    setState(() {
      favoriteIds = savedFavorites;
    });
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', favoriteIds);
    //Tıklanan değerin beğenme durumunun kaydedilmesi için key - value olarak tutuyoruz.
  }

//Eğer liste içinde itemId değerinin olması durumunda like durumunda değeri sil
//Yoksa değeri listeye ekle
  void toggleFavorite(String itemId) {
    setState(() {
      if (favoriteIds.contains(itemId)) {
        favoriteIds.remove(itemId);
      } else {
        favoriteIds.add(itemId);
      }
    });
    saveFavorites(); //koşul herneyse durumu localde kaydet
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritesPage()),
            );
          },
          child: const Text('G'),
        ),
        title: const Text('Discover List'),
      ),
      body: ListView.builder(
        itemCount: discoverItems.length,
        itemBuilder: (ctx, index) {
          final item = discoverItems[index];
          //favoriteIds listesinde hangi değer varsa
          final isFavorite = favoriteIds.contains(item.id);

          return ListTile(
            title: Text(item.title),
            trailing: IconButton(
              icon: Icon(
                //isFavorite durumu ise ikon durumuna bak
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () {
                toggleFavorite(item
                    .id); //Gerekli değerin beğenme durumu kontrol edilir ve kaydedilir.
              },
            ),
          );
        },
      ),
    );
  }
}

//BEĞENİLEN LİSTE ELEMENLARININ GÖSTERİLDİĞİ SAYFA
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<String> favoriteIds = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final savedFavorites = prefs.getStringList('favorites') ?? [];
    setState(() {
      favoriteIds = savedFavorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: favoriteIds.length,
        itemBuilder: (ctx, index) {
          final itemId = favoriteIds[index];
          // Bu noktada, itemId'yi kullanarak favori öğeyi nasıl getireceğinizi uygulamanıza göre ayarlayabilirsiniz.
          // Örneğin, DiscoverItem nesnesini arayabilir veya favori öğe için başka bir model kullanabilirsiniz.
          return ListTile(
            title: Text('Favori Öğe #$itemId'),
          );
        },
      ),
    );
  }
}
