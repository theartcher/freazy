import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:freazy/models/item.dart';
import 'package:freazy/utils/db_helper.dart';
import 'package:freazy/utils/form_focus_helper.dart';
import 'package:freazy/utils/form_validation_helper.dart';
import 'package:freazy/widgets/form_fields/form_date.dart';
import 'package:freazy/widgets/form_fields/form_weight.dart';
import 'package:freazy/widgets/form_fields/form_text_suggestions.dart';
import 'package:freazy/widgets/form_fields/form_weightUnit.dart';

class ItemDetailsPage extends StatefulWidget {
  final Item? item;

  const ItemDetailsPage({super.key, this.item});

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  final _validationHelper = FormValidationHelper();
  final _focusHelper = FormFocusHelper();
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = DatabaseHelper();

  static const spaceBetweenItems = 8.0;

  late Future<void> _initializeFuture;
  List<String> _existingCategories = [];
  List<String> _existingTitles = [];
  List<String> _existingFreezers = [];
  List<String> _existingWeightUnits = [];
  bool _isLoading = false;

  Item selectedItem = Item(null, '', 0, 'g', DateTime.now(),
      DateTime.now().add(const Duration(days: 14)), '', '');

  @override
  void initState() {
    super.initState();

    // Initialize fields with existing item data if editing
    if (widget.item != null) {
      selectedItem.title = widget.item!.title;
      selectedItem.weight = widget.item!.weight;
      selectedItem.weightUnit = widget.item!.weightUnit;
      selectedItem.freezeDate = widget.item!.freezeDate;
      selectedItem.expirationDate = widget.item!.expirationDate;
      selectedItem.category = widget.item!.category;
      selectedItem.freezer = widget.item!.freezer;
    }

    _initializeFuture = _initializeData();
  }

  Future<void> _initializeData() async {
    //Fetch all existing objects for suggestions in autocomplete fields.
    final titles = await _dbHelper.fetchExistingTitles();
    final freezers = await _dbHelper.fetchExistingFreezers();
    final categories = await _dbHelper.fetchExistingCategories();
    final existingWeightUnits = await _dbHelper.fetchExistingWeightUnits();
    final mostCommonWeightUnit = await _dbHelper.fetchCommonWeightUnit();

    setState(() {
      _existingTitles = titles;
      _existingFreezers = freezers;
      _existingCategories = categories;
      _existingWeightUnits = existingWeightUnits;
      selectedItem.weightUnit = mostCommonWeightUnit;
    });
  }

  void _updateProperty<T>(T value, void Function(T) updater) {
    setState(() {
      updater(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
            widget.item == null ? "Wat wil je invriezen?" : "Product bewerken"),
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
                  focusNode: _focusHelper.sendFormFocusNode,
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });

                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      selectedItem.id = widget.item?.id;

                      if (widget.item == null) {
                        await _dbHelper.insertItem(selectedItem);
                      } else {
                        await _dbHelper.updateItem(selectedItem);
                      }

                      context.pop(true);
                    } else {
                      setState(() {
                        _isLoading = false;
                      });

                      _formKey.currentState!.reset();
                    }
                  },
                ),
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
                  InputWithSuggestions(
                    focusNode: _focusHelper.titleFocusNode,
                    shiftFocus: () => _focusHelper.nextFocus(
                        _focusHelper.titleFocusNode,
                        _focusHelper.weightFocusNode,
                        context),
                    autocompleteSuggestions: _existingTitles,
                    selectItem: (value) => _updateProperty(
                        value, (val) => selectedItem.title = val),
                    selectedItem: selectedItem.title,
                    validateForm: (value) =>
                        _validationHelper.validateTitle(value),
                    setFocusNode: _focusHelper.setTitleFocusNode,
                    label: 'Product',
                    icon: Icons.title,
                    autoFocus: true,
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
                      WeightInput(
                        focusNode: _focusHelper.weightFocusNode,
                        selectWeight: (value) => _updateProperty(
                            value, (val) => selectedItem.weight = val),
                        shiftFocus: () => _focusHelper.nextFocus(
                            _focusHelper.weightFocusNode,
                            _focusHelper.weightUnitFocusNode,
                            context),
                        selectedWeight: selectedItem.weight,
                      ),
                      WeightUnitSelector(
                        autocompleteSuggestions: _existingWeightUnits,
                        selectItem: (value) => _updateProperty(
                            value, (val) => selectedItem.weightUnit = val),
                        selectedItem: selectedItem.weightUnit,
                        validateForm: (value) =>
                            _validationHelper.validateWeightUnit(value),
                        setFocusNode: _focusHelper.setWeightUnitFocusNode,
                        shiftFocus: () => _focusHelper.nextFocus(
                            _focusHelper.weightUnitFocusNode,
                            _focusHelper.freezerFocusNode,
                            context),
                      )
                    ],
                  ),
                  const SizedBox(height: spaceBetweenItems),
                  InputWithSuggestions(
                    focusNode: _focusHelper.freezerFocusNode,
                    autocompleteSuggestions: _existingFreezers,
                    selectItem: (value) => _updateProperty(
                        value, (val) => selectedItem.freezer = val),
                    selectedItem: selectedItem.freezer,
                    setFocusNode: _focusHelper.setFreezerFocusNode,
                    shiftFocus: () => _focusHelper.nextFocus(
                        _focusHelper.freezerFocusNode,
                        _focusHelper.categoryFocusNode,
                        context),
                    validateForm: (value) =>
                        _validationHelper.validateFreezer(value),
                    label: 'Vriezer',
                    icon: Icons.kitchen,
                  ),
                  const SizedBox(height: spaceBetweenItems),
                  InputWithSuggestions(
                    focusNode: _focusHelper.categoryFocusNode,
                    autocompleteSuggestions: _existingCategories,
                    selectItem: (value) => _updateProperty(
                        value, (val) => selectedItem.category = val),
                    selectedItem: selectedItem.category,
                    setFocusNode: _focusHelper.setCategoryFocusNode,
                    shiftFocus: () => _focusHelper.nextFocus(
                        _focusHelper.categoryFocusNode,
                        _focusHelper.freezeDateFocusNode,
                        context),
                    validateForm: (value) =>
                        _validationHelper.validateCategory(value),
                    label: 'Categorie',
                    icon: Icons.category,
                  ),
                  const SizedBox(height: spaceBetweenItems),
                  DateInput(
                    focusNode: _focusHelper.freezeDateFocusNode,
                    selectDate: (value) => _updateProperty(
                        value, (val) => selectedItem.freezeDate = val),
                    shiftFocus: () => _focusHelper.nextFocus(
                        _focusHelper.freezeDateFocusNode,
                        _focusHelper.expirationDateFocusNode,
                        context),
                    validateForm: (value) =>
                        _validationHelper.validateFreezeDate(value),
                    firstDate: DateTime(DateTime.now().year),
                    lastDate: DateTime.now(),
                    label: 'Invriesdatum',
                    icon: Icons.ac_unit,
                    initialDate: selectedItem.freezeDate,
                  ),
                  const SizedBox(height: spaceBetweenItems),
                  DateInput(
                    focusNode: _focusHelper.expirationDateFocusNode,
                    selectDate: (value) => _updateProperty(
                        value, (val) => selectedItem.expirationDate = val),
                    shiftFocus: () => _focusHelper.nextFocus(
                        _focusHelper.expirationDateFocusNode,
                        _focusHelper.sendFormFocusNode,
                        context),
                    validateForm: (value) =>
                        _validationHelper.validateExpirationDate(value),
                    firstDate: DateUtils.dateOnly(DateTime.now()),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    label: 'Houdbaarheidsdatum',
                    icon: Icons.running_with_errors,
                    initialDate: selectedItem.expirationDate,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
