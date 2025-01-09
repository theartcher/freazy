import 'package:freazy/models/item.dart';
import 'package:freazy/models/sort_type.dart';

List<Item> sortByType(SortType type, List<Item> items) {
  switch (type) {
    case SortType.alphabetical:
      items.sort((a, b) => a.title.compareTo(b.title));
      break;
    case SortType.toExpire:
      items.sort((a, b) => a.expirationDate.compareTo(b.expirationDate));
      break;
    case SortType.category:
      items.sort((a, b) => a.category.compareTo(b.category));
      break;
    case SortType.freezer:
      items.sort((a, b) => a.freezer.compareTo(b.freezer));
      break;
    default:
      throw ArgumentError('Unknown sort type: $type');
  }
  return items;
}
