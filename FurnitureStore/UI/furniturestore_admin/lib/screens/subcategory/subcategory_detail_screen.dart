import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:furniturestore_admin/models/category/category.dart';
import 'package:furniturestore_admin/models/search_result.dart';
import 'package:furniturestore_admin/models/subcategory/subcategory.dart';
import 'package:furniturestore_admin/providers/category_provider.dart';
import 'package:furniturestore_admin/providers/subcategory_provider.dart';
import 'package:furniturestore_admin/widgets/custom_dropdown_field.dart';
import 'package:furniturestore_admin/widgets/custom_text_field.dart';
import 'package:furniturestore_admin/widgets/master_screen.dart';
import 'package:provider/provider.dart';

class SubcategoryDetailScreen extends StatefulWidget {
  final SubcategoryModel? subcategory;

  const SubcategoryDetailScreen({super.key, this.subcategory});

  @override
  State<SubcategoryDetailScreen> createState() =>
      _SubcategoryDetailScreenState();
}

class _SubcategoryDetailScreenState extends State<SubcategoryDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late SubcategoryProvider _subcategoryProvider;
  late CategoryProvider _categoryProvider;

  SearchResult<CategoryModel>? categoryResult;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _initialValue = {
      'name': widget.subcategory?.name,
      'categoryId': widget.subcategory?.categoryId?.toString(),
    };
    _subcategoryProvider = context.read<SubcategoryProvider>();
    _categoryProvider = context.read<CategoryProvider>();

    initForm();
  }

  Future initForm() async {
    categoryResult = await _categoryProvider.get();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: widget.subcategory?.name ?? "Detalji o potkategoriji",
      showBackButton: true,
      child: isLoading ? Container() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  "assets/images/subcategory_detail_photo.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: FormBuilder(
                key: _formKey,
                initialValue: _initialValue,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detalji o potkategoriji',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 20),
                      const CustomTextField(
                          name: 'name', label: 'Naziv', isRequired: true),
                      CustomDropdownField(
                        name: 'categoryId',
                        label: 'Kategorija',
                        isRequired: true,
                        formKey: _formKey,
                        items: categoryResult?.result.map((category) {
                              return DropdownMenuItem(
                                alignment: AlignmentDirectional.center,
                                value: category.id.toString(),
                                child: Text(category.name ?? ''),
                              );
                            }).toList() ??
                            [],
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _onSubmit,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFFF4A258),
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 32.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Sačuvaj',
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState?.value;
      print('Form Data: $formData');

      var request = Map.from(_formKey.currentState!.value);
      request['categoryId'] = int.parse(request['categoryId']);

      try {
        if (widget.subcategory == null) {
          await _subcategoryProvider.insert(request);
        } else {
          await _subcategoryProvider.update(widget.subcategory!.id!, request);
        }

        Navigator.of(context).pop(true);
      } on Exception catch (e) {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text("Greška"),
                  content: Text(e.toString()),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("OK"))
                  ],
                ));
      }
    } else {
      print('Validacija nije uspela');
    }
  }
}
