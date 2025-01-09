import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:freazy/constants/constants.dart';
import 'package:freazy/models/item.dart';
import 'package:freazy/utils/db_helper.dart';

class OverviewListTile extends StatelessWidget {
  final Function fetchItems;
  final Item item;

  const OverviewListTile(
      {super.key, required this.item, required this.fetchItems});

  @override
  Widget build(BuildContext context) {
    final DatabaseHelper dbHelper = DatabaseHelper();
    final theme = Theme.of(context);

    return ListTile(
      tileColor: DateTime.now().isBefore(item.expirationDate)
          ? Colors.transparent
          : Colors.red[100],
      title: Text('${item.title} (${item.weight}${item.weightUnit})'),
      subtitle: Text(
          "THT: ${DateFormat('dd-MM-yyyy').format(item.expirationDate)}\nLocatie: ${item.freezer}\nCategorie: ${item.category}"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: theme.colorScheme.primary,
            ),
            onPressed: () async {
              final result =
                  await context.push(ROUTE_ITEM_DETAILS, extra: item);
              if (result == true) {
                await fetchItems();
              }
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: theme.colorScheme.error,
            ),
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text(
                    'Weet je zeker dat je dit item wilt verwijderen?'),
                content: const Text(
                    'Deze actie kan NIET ongedaan worden. Weet je zeker dat je het item wilt verwijderen?'),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await dbHelper.delete(item.id!);
                      await fetchItems();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Verwijderen',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuleren'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
