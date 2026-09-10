import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/item_editor.dart';

class ManageList extends ConsumerWidget {
  final String title;
  const ManageList({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          OutlinedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add new'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.grey, style: BorderStyle.solid),
            ),
            onPressed: () {
              // Open ItemEditor
            },
          ),
          const SizedBox(height: 16),
          // Sample items
          Card(
            child: ListTile(
              leading: const CircleAvatar( child: Icon(Icons.wallet, color: Colors.white)),
              title: const Text('Cash'),
              subtitle: const Text('रु 5000'),
              trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
            ),
          )
        ],
      ),
    );
  }
}
