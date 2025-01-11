class ItemAutoCompleteSuggestions {
  final List<String> categories;
  List<String> titles;
  List<String> freezers;
  List<String> weightUnits;

  ItemAutoCompleteSuggestions(
      {required this.categories,
      required this.titles,
      required this.freezers,
      required this.weightUnits});

  ItemAutoCompleteSuggestions.empty()
      : categories = [],
        titles = [],
        freezers = [],
        weightUnits = [];
}
