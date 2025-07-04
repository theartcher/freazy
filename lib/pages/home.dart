import 'package:flutter/material.dart';
import 'package:freazy/models/loading_state.dart';
import 'package:go_router/go_router.dart';
import 'package:freazy/constants/constants.dart';
import 'package:freazy/models/item.dart';
import 'package:freazy/models/sort_type.dart';
import 'package:freazy/utils/databases/item_database_helper.dart';
import 'package:freazy/utils/home/search_helper.dart';
import 'package:freazy/utils/home/sorting_helper.dart';
import 'package:freazy/widgets/home/list_tile.dart';
import 'package:freazy/widgets/home/sort_items.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final ItemDatabaseHelper _dbHelper = ItemDatabaseHelper();

  SortType _selectedSorting = SortType.toExpire;
  List<Item> _originalList = [];
  List<Item> _searchedAndSortedItems = [];
  String _searchQuery = '';
  LoadingStates state = LoadingStates.isImportant;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    final allItems = await _dbHelper.fetchItems();
    _searchedAndSortedItems = allItems;

    //Return original sorting list.
    setState(() {
      _searchedAndSortedItems =
          sortByType(_selectedSorting, _searchedAndSortedItems);
      _originalList = allItems;
      state = LoadingStates.isNotLoading;
    });

    //If the user was searching, refresh the search.
    if (_searchQuery != '') {
      search(_searchQuery);
    }
  }

  //Select the sorting
  void selectSortingType(SortType sortingType) {
    setState(() {
      _selectedSorting = sortingType;
      _searchedAndSortedItems =
          sortByType(sortingType, _searchedAndSortedItems);
    });
  }

  void search(String query) {
    setState(() {
      _searchQuery = query;
      _searchedAndSortedItems = fuzzySearch(query, _originalList);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        scrolledUnderElevation: 0,
        title: Text(
          localization.homePage_header_appTitle,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await context.push(ROUTE_ITEM_ADD);

              if (result == true) {
                setState(() {
                  state = LoadingStates.isImportant;
                });
                _fetchItems();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              final result = await context.push(ROUTE_SETTINGS);

              if (result == true) {
                setState(() {
                  state = LoadingStates.isImportant;
                });
                _fetchItems();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      search(value);
                    },
                    onTapOutside: (PointerDownEvent? event) =>
                        FocusScope.of(context).unfocus(),
                    decoration: InputDecoration(
                      hintText: localization.homePage_searchBar_searching,
                      border: const UnderlineInputBorder(),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchQuery = '';
                                  _fetchItems();
                                });
                              },
                            )
                          : null,
                    ),
                  ),
                ),
              ),
              SortItems(
                onChangeType: selectSortingType,
                selectedType: _selectedSorting,
              ),
            ],
          ),
          // Full refresh load indicator. E.g. deleting, editing or adding items.
          if (state == LoadingStates.isImportant)
            Expanded(
              child: Skeletonizer(
                child: ListView.separated(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final Item item = Item(
                        id: 0,
                        title: "long title thing",
                        freezer: "freezer",
                        category: "category",
                        weight: 1,
                        weightUnit: "g",
                        freezeDate: DateTime.now(),
                        expirationDate: DateTime.now().add(
                          const Duration(days: 1),
                        ));
                    return OverviewListTile(
                      fetchItems: () => _fetchItems(),
                      item: item,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    height: 1,
                    thickness: 2,
                  ),
                ),
              ),
            ),
          // No items found and not loading.
          if (_searchedAndSortedItems.isEmpty &&
              state == LoadingStates.isNotLoading)
            Expanded(
              child: Center(
                child: Text(
                  localization.homePage_items_noItemsFound,
                ),
              ),
            ),
          if (state == LoadingStates.isNotEssential ||
              state == LoadingStates.isNotLoading)
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    state = LoadingStates.isNotEssential;
                  });

                  await _fetchItems();
                },
                child: ListView.separated(
                  itemCount: _searchedAndSortedItems.length,
                  itemBuilder: (context, index) {
                    final item = _searchedAndSortedItems[index];
                    return OverviewListTile(
                      fetchItems: () {
                        setState(() {
                          state = LoadingStates.isImportant;
                        });

                        _fetchItems();
                      },
                      item: item,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    height: 1,
                    thickness: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
