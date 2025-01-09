import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:freazy/models/item.dart';

List<Item> fuzzySearch(String query, List<Item> items) {
  if (query.isEmpty) {
    return items;
  }

  final titles = items.map((item) => item.title).toList();
  final results = extractAll(query: query, choices: titles);

  final matchedItems =
      results.where((result) => result.score > 60).map((result) {
    final index = titles.indexOf(result.choice);
    return items[index];
  }).toList();

  return matchedItems;
}
