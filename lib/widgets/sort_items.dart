import 'package:flutter/material.dart';
import 'package:freazy/models/sort_type.dart';

class SortItems extends StatelessWidget {
  final Function(SortType type) onChangeType;
  final SortType selectedType;

  SortItems(
      {super.key, required this.onChangeType, required this.selectedType});

  final Map<SortType, String> sortTypeLabels = {
    SortType.alphabetical: 'Alfabetisch',
    SortType.toExpire: 'Houdbaarheidsdatum',
    SortType.freezer: "Vriezer",
    SortType.category: "Categorieën"
  };

  @override
  Widget build(BuildContext context) {
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
