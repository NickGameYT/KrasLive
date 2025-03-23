import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RatingItem {
  final String name;
  final double rating;

  RatingItem({required this.name, required this.rating});
}

class RatingCard extends StatelessWidget {
  final RatingItem item;

  const RatingCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              item.name,
              style: const TextStyle(
                color: Color(0xFF4A3780),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              item.rating.toString().replaceAll('.', ','),
              style: const TextStyle(
                color: Color(0xFF4A3780),
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RatingScreen extends StatelessWidget {
  const RatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Эти данные можно загружать из Firebase
    final List<RatingItem> items = [
      RatingItem(name: 'ЖК "АКАДЕМГОРОДОК"', rating: 4.8),
      RatingItem(name: 'ЖК "ФЕСТИВАЛЬ"', rating: 4.7),
      RatingItem(name: 'ЖК "ПОКРОВСКИЙ"', rating: 4.5),
      RatingItem(name: 'ЖК "ПРЕОБРАЖЕНСКИЙ"', rating: 4.4),
      RatingItem(name: 'ЖК "ЮЖНЫЙ БЕРЕГ"', rating: 4.3),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFE6E9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3780),
        foregroundColor: Colors.white,
        title: const Text('РЕЙТИНГ ЖК'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Звезды на фоне
          ...List.generate(20, (index) {
            final double top = index * 20.0 % MediaQuery.of(context).size.height;
            final double left = (index * 33) % MediaQuery.of(context).size.width;
            final double size = (index % 3 + 1) * 10.0;
            
            return Positioned(
              top: top,
              left: left,
              child: Icon(
                Icons.star,
                color: const Color(0xFF4A3780).withOpacity(0.2),
                size: size,
              ),
            );
          }),
          
          // Список ЖК
          ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return RatingCard(item: items[index]);
            },
          ),
        ],
      ),
    );
  }
} 