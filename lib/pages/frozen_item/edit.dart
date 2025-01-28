import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:freazy/models/item-autocomplete-suggestions.dart';
import 'package:freazy/stores/item-store.dart';
import 'package:freazy/utils/forms/form_focus_helper.dart';
import 'package:freazy/widgets/frozen_item_fields/category.dart';
import 'package:freazy/widgets/frozen_item_fields/expiration-date.dart';
import 'package:freazy/widgets/frozen_item_fields/freeze-date.dart';
import 'package:freazy/widgets/frozen_item_fields/freezer.dart';
import 'package:freazy/widgets/frozen_item_fields/title.dart';
import 'package:freazy/widgets/frozen_item_fields/weight-unit.dart';
import 'package:freazy/widgets/frozen_item_fields/weight.dart';
import 'package:go_router/go_router.dart';
import 'package:freazy/models/item.dart';
import 'package:freazy/utils/databases/item_database_helper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditItemPage extends StatefulWidget {
  final Item item;

  const EditItemPage({super.key, required this.item});

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _focusHelper = FormFocusHelper();
  final _dbHelper = ItemDatabaseHelper();

  late FrozenItemStore store;
  static const spaceBetweenItems = 8.0;
  late Future<void> _initializeFuture;

  ItemAutoCompleteSuggestions suggestions = ItemAutoCompleteSuggestions.empty();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeFuture = _initialize();
  }

  Future<void> _initialize() async {
    final existingSuggestions = await _dbHelper.fetchAutocompleteSuggestions();

    store.setItem(widget.item);

    setState(() {
      suggestions = existingSuggestions;
    });
  }

  void exitWithoutSaving() {
    store.clearItem();
    context.pop();
  }

  Future<void> exitWithSaving() async {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Item selectedItem = store.getItem();
      selectedItem.id = widget.item.id;
      await _dbHelper.updateItem(selectedItem);

      store.clearItem();
      // ignore: use_build_context_synchronously
      context.pop(true);
    } else {
      setState(() {
        _isLoading = false;
      });

      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    store = Provider.of<FrozenItemStore>(context);
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => exitWithoutSaving(),
        ),
        title: Text(localization.itemConfig_edit_headerTitle),
        actions: [
          _isLoading
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.onPrimary,
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () => exitWithSaving(),
                )
        ],
      ),
      body: FutureBuilder<void>(
        future: _initializeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: SpinKitCircle(
              color: theme.primaryColor,
              size: 96,
            ));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  ItemTitle(
                    suggestions: suggestions,
                    focusHelper: _focusHelper,
                  ),
                  const SizedBox(height: spaceBetweenItems),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Icon(
                          Icons.scale,
                          size: 24,
                        ),
                      ),
                      ItemWeight(
                        focusHelper: _focusHelper,
                      ),
                      ItemWeightUnit(
                        suggestions: suggestions,
                        focusHelper: _focusHelper,
                      )
                    ],
                  ),
                  const SizedBox(height: spaceBetweenItems),
                  ItemFreezer(
                    suggestions: suggestions,
                    focusHelper: _focusHelper,
                  ),
                  const SizedBox(height: spaceBetweenItems),
                  ItemCategory(
                    suggestions: suggestions,
                    focusHelper: _focusHelper,
                  ),
                  const SizedBox(height: spaceBetweenItems),
                  ItemFreezeDate(focusHelper: _focusHelper),
                  const SizedBox(height: spaceBetweenItems),
                  ItemExpirationDate(focusHelper: _focusHelper)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
