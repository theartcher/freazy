import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:freazy/constants/constants.dart';
import 'package:freazy/models/item.dart';
import 'package:freazy/models/sort_type.dart';
import 'package:freazy/utils/db_helper.dart';
import 'package:freazy/utils/search_helper.dart';
import 'package:freazy/utils/sorting_helper.dart';
import 'package:freazy/widgets/home/list_tile.dart';
import 'package:freazy/widgets/sort_items.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final title = 'Freazy';

  SortType _selectedSorting = SortType.toExpire;
  List<Item> _originalList = [];
  List<Item> _searchedAndSortedItems = [];
  String _searchQuery = '';

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

    return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          scrolledUnderElevation: 0,
          title: Text(title),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final result = await context.push(ROUTE_ITEM_ADD);

                if (result == true) {
                  _fetchItems();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => context.push(ROUTE_SETTINGS),
            ),
          ],
        ),
        body: Column(
          children: [
            Row(
              children: [
                IconButton(
                    icon: Icon(_searchQuery != '' ? Icons.close : Icons.search),
                    onPressed: () {
                      if (_searchQuery == '') return;
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                        _fetchItems();
                      });
                    }),
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
                      decoration: const InputDecoration(
                          hintText: 'Zoeken...',
                          border: UnderlineInputBorder()),
                    ),
                  ),
                ),
                SortItems(
                  onChangeType: selectSortingType,
                  selectedType: _selectedSorting,
                ),
              ],
            ),
            Expanded(
                child: _searchedAndSortedItems.isEmpty
                    ? const Center(child: Text("Geen producten gevonden."))
                    : RefreshIndicator(
                        onRefresh: _fetchItems,
                        child: ListView.separated(
                          itemCount: _searchedAndSortedItems.length,
                          itemBuilder: (context, index) {
                            final item = _searchedAndSortedItems[index];
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
                      )),
          ],
        ));
  }
}
