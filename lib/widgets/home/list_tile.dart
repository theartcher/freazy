import 'package:flutter/material.dart';
import 'package:freazy/main.dart';
import 'package:freazy/widgets/messenger.dart';
import 'package:go_router/go_router.dart';
import 'package:freazy/constants/constants.dart';
import 'package:freazy/models/item.dart';
import 'package:freazy/utils/databases/item_database_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class OverviewListTile extends StatelessWidget {
  final Function fetchItems;
  final Item item;

  const OverviewListTile(
      {super.key, required this.item, required this.fetchItems});

  @override
  Widget build(BuildContext context) {
    final ItemDatabaseHelper dbHelper = ItemDatabaseHelper();
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context)!;
    const paddingEdges = 18.0;

    deleteCurrentItem() async {
      final deletedItem = item;
      await dbHelper.delete(item.id!);
      await fetchItems();

      // Show a SnackBar with an undo option
      MessengerService().showMessage(
        message: localization.homePage_item_deletedItem(item.title),
        closeMessage: localization.generic_undo,
        type: MessageType.success,
        position: MessagePosition.bottom,
        onClose: () async {
          // Reinsert the item into the database and refresh the list
          await dbHelper.insertItem(deletedItem);
          await fetchItems();
        },
      );
    }

    return Dismissible(
      key: Key(item.id.toString()),
      background: Container(
        color: theme.colorScheme.primary,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: paddingEdges),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: theme.colorScheme.error,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: paddingEdges),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          final result = await context.push(ROUTE_ITEM_EDIT, extra: item);
          if (result == true) {
            await fetchItems();
          }
          return false;
        } else if (direction == DismissDirection.endToStart) {
          return true;
        }
        return false;
      },
      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart) {
          deleteCurrentItem();
        }
      },
      child: ListTile(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localization.homePage_item_header(
                item.title,
                item.weight,
                item.weightUnit,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            if (DateTime.now().isAfter(item.expirationDate))
              Expanded(
                child: Text(
                  localization.homePage_item_expiredAttribute,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              )
          ],
        ),
        subtitle: Text(
          localization.homePage_item_description(
            DateFormat.yMd(
              MainApp.of(context).selectedLocale.languageCode,
            ).format(
              item.expirationDate,
            ),
            item.freezer,
            item.category,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
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
            IconButton(
              icon: Icon(
                Icons.delete,
                color: theme.colorScheme.error,
              ),
              onPressed: () async {
                deleteCurrentItem();
              },
            ),
          ],
        ),
      ),
    );
  }
}
