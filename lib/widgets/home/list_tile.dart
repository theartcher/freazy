import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:freazy/constants/constants.dart';
import 'package:freazy/models/item.dart';
import 'package:freazy/utils/databases/item_database_helper.dart';

class OverviewListTile extends StatelessWidget {
  final Function fetchItems;
  final Item item;

  const OverviewListTile(
      {super.key, required this.item, required this.fetchItems});

  @override
  Widget build(BuildContext context) {
    final ItemDatabaseHelper dbHelper = ItemDatabaseHelper();
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(item.id.toString()),
      background: Container(
        color: theme.colorScheme.primary,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.edit, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: theme.colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      direction:
          DismissDirection.horizontal, // Enable swiping both left and right
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Swipe to edit
          final result = await context.push(ROUTE_ITEM_EDIT, extra: item);
          if (result == true) {
            await fetchItems();
          }
          return false; // Prevent Dismissible from removing the widget
        } else if (direction == DismissDirection.endToStart) {
          return true;
        }
        return false;
      },
      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Handle deletion
          final deletedItem = item;
          await dbHelper.delete(item.id!);
          await fetchItems();

          // Show a SnackBar with an undo option
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${item.title} verwijderd.'),
              action: SnackBarAction(
                label: 'Ongedaan maken',
                onPressed: () async {
                  // Reinsert the item into the database and refresh the list
                  await dbHelper.insertItem(deletedItem);
                  await fetchItems();
                },
              ),
            ),
          );
        }
      },
      child: ListTile(
        tileColor: DateTime.now().isBefore(item.expirationDate)
            ? Colors.transparent
            : Colors.red[100],
        title: Text('${item.title} (${item.weight}${item.weightUnit})'),
        subtitle: Text(
            "THT: ${DateFormat('dd-MM-yyyy').format(item.expirationDate)}\nLocatie: ${item.freezer}\nCategorie: ${item.category}"),
        trailing: IconButton(
          icon: Icon(
            Icons.edit,
            color: theme.colorScheme.primary,
          ),
          onPressed: () async {
            final result = await context.push(ROUTE_ITEM_EDIT, extra: item);
            if (result == true) {
              await fetchItems();
            }
          },
        ),
      ),
    );
  }
}
