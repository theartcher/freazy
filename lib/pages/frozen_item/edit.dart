import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:freazy/models/item-autocomplete-suggestions.dart';
import 'package:go_router/go_router.dart';
import 'package:freazy/models/item.dart';
import 'package:freazy/utils/db_helper.dart';
import 'package:freazy/utils/form_focus_helper.dart';
import 'package:freazy/utils/form_validation_helper.dart';
import 'package:freazy/widgets/form_fields/form_date.dart';
import 'package:freazy/widgets/form_fields/form_weight.dart';
import 'package:freazy/widgets/form_fields/form_text_suggestions.dart';
import 'package:freazy/widgets/form_fields/form_weightUnit.dart';

class EditItemPage extends StatefulWidget {
  final Item item;

  const EditItemPage({super.key, required this.item});

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final _validationHelper = FormValidationHelper();
  final _focusHelper = FormFocusHelper();
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = DatabaseHelper();

  static const spaceBetweenItems = 8.0;

  late Future<void> _initializeFuture;
  ItemAutoCompleteSuggestions suggestions = ItemAutoCompleteSuggestions.empty();
  bool _isLoading = false;
  Item selectedItem = Item.empty();

  @override
  void initState() {
    super.initState();
    selectedItem = Item.empty();
    _initializeFuture = _initialize();
  }

  Future<void> _initialize() async {
    final existingSuggestions = await _dbHelper.fetchAutocompleteSuggestions();
    final mostCommonWeightUnit = await _dbHelper.fetchCommonWeightUnit();

    setState(() {
      suggestions = existingSuggestions;
      selectedItem.weightUnit = mostCommonWeightUnit;
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
        title: const Text("Product bewerken"),
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
                  onPressed: _onSavePressed)
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
                    autocompleteSuggestions: suggestions.titles,
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

  Future<void> _onSavePressed() async {
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
  }
}
