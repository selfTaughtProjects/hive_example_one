import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FristScreen extends StatefulWidget {
  FristScreen({super.key});

  @override
  State<FristScreen> createState() => _FristScreenState();
}

class _FristScreenState extends State<FristScreen> {
  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  _refreshItems() {
    final data = _shoppingBox.keys.map((key) {
      final item = _shoppingBox.get(key);
      return {
        'key': key,
        'name': item['name'],
        'quantity': item['quantity'],
      };
    }).toList();
    setState(() {
      _items = data.reversed.toList();
    });
  }

  List<Map<String, dynamic>> _items = [];

  final _shoppingBox = Hive.box('shopping_box');

  _createItem(Map<String, dynamic> newItem) async {
    await _shoppingBox.add(newItem);
    _refreshItems();
  }

  _updateItem(int itemKey, Map<String, dynamic> item) async {
    await _shoppingBox.put(itemKey, item);

    _refreshItems();
  }

  _deleteItem(int itemKey) async {
    await _shoppingBox.delete(itemKey);
    _refreshItems();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('an item has been deleted'),
      ),
    );
  }

  _showForm(BuildContext ctx, int? itemKey) {
    if (itemKey != null) {
      final existingItem =
          _items.firstWhere((element) => element['key'] == itemKey);
      _nameController.text = existingItem['name'];
      _quantityController.text = existingItem['quantity'];
    }

    showModalBottomSheet(
      context: ctx,
      builder: (_) => Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'name'),
            ),
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(hintText: 'quantity'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (itemKey == null) {
                  _createItem({
                    'name': _nameController.text,
                    'quantity': _quantityController.text,
                  });
                }

                if (itemKey != null) {
                  _updateItem(itemKey, {
                    'name': _nameController.text.trim(),
                    'quantity': _quantityController.text.trim(),
                  });
                }

                _nameController.text = '';
                _quantityController.text = '';
                Navigator.of(ctx).pop();
              },
              child: Text(itemKey == null ? 'create' : 'update'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (_, i) {
          final currentItem = _items[i];
          return Card(
            child: ListTile(
              title: Text(
                currentItem['name'],
              ),
              subtitle: Text(
                currentItem['quantity'].toString(),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _showForm(context, currentItem['key']),
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () => _deleteItem(currentItem['key']),
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context, null),
        child: const Center(
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
