import 'package:flutter/material.dart';
import 'package:freazy/models/sort_type.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SortItems extends StatelessWidget {
  final Function(SortType type) onChangeType;
  final SortType selectedType;

  SortItems(
      {super.key, required this.onChangeType, required this.selectedType});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    final Map<SortType, String> sortTypeLabels = {
      SortType.alphabetical:
          localization.homePage_searchBar_sortCategoryAlphabetically,
      SortType.toExpire: localization.homePage_searchBar_sortToExpireFirst,
      SortType.freezer:
          localization.homePage_searchBar_sortFreezerAlphabetically,
      SortType.category:
          localization.homePage_searchBar_sortCategoryAlphabetically
    };

    final List<PopupMenuEntry<SortType>> popupMenuItems = SortType.values
        .map((type) => PopupMenuItem<SortType>(
              value: type,
              child: Text(sortTypeLabels[type]!),
            ))
        .toList();

    return PopupMenuButton<SortType>(
      icon: const Icon(Icons.sort),
      onSelected: (SortType value) {
        onChangeType(value);
      },
      itemBuilder: (BuildContext context) {
        return popupMenuItems;
      },
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}
