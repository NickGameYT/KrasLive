import 'package:flutter/material.dart';

class OutagesScreen extends StatelessWidget {
  const OutagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Отключения'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5, // Временное количество элементов
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.warning, color: Colors.orange),
              title: Text('Отключение ${index + 1}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Район: Центральный'),
                  Text('Улица: Примерная ${index + 1}'),
                  Text('Время: 10:00 - 18:00'),
                  Text('Причина: Плановые работы'),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  // TODO: Добавить функционал подписки на уведомления
                },
              ),
            ),
          );
        },
      ),
    );
  }
} 