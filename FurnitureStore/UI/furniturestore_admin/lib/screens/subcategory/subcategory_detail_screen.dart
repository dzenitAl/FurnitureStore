import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:furniturestore_admin/models/category/category.dart';
import 'package:furniturestore_admin/models/search_result.dart';
import 'package:furniturestore_admin/models/subcategory/subcategory.dart';
import 'package:furniturestore_admin/providers/category_provider.dart';
import 'package:furniturestore_admin/providers/subcategory_provider.dart';
import 'package:furniturestore_admin/utils/utils.dart';
import 'package:furniturestore_admin/widgets/custom_dropdown_field.dart';
import 'package:furniturestore_admin/widgets/custom_text_field.dart';
import 'package:furniturestore_admin/widgets/master_screen.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:furniturestore_admin/utils/image_handling_mixin.dart';

class SubcategoryDetailScreen extends StatefulWidget {
  final SubcategoryModel? subcategory;

  const SubcategoryDetailScreen({super.key, this.subcategory});

  @override
  State<SubcategoryDetailScreen> createState() =>
      _SubcategoryDetailScreenState();
}

class _SubcategoryDetailScreenState extends State<SubcategoryDetailScreen>
    with ImageHandlingMixin {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late SubcategoryProvider _subcategoryProvider;
  late CategoryProvider _categoryProvider;
  File? _selectedImage;
  bool _isUploadingImage = false;
  final String baseUrl = 'http://localhost:7015';

  SearchResult<CategoryModel>? categoryResult;
  bool isLoading = true;
  SubcategoryModel? _subcategory;

  @override
  void initState() {
    super.initState();
    _subcategory = widget.subcategory;
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _refreshSubcategoryData() async {
    if (_subcategory?.id != null) {
      final refreshedData =
          await _subcategoryProvider.getById(_subcategory!.id!);
      setState(() {
        _subcategory = refreshedData;
      });
    }
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
            child: Container(
              padding: const EdgeInsets.all(8.0),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Slika potkategorije',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D3557),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _selectedImage != null
                          ? Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildErrorPlaceholder(
                                    'Error loading selected image');
                              },
                            )
                          : _subcategory?.imagePath != null
                              ? Image.network(
                                  _subcategory!.imagePath!.startsWith('http')
                                      ? _subcategory!.imagePath!
                                      : '$baseUrl${_subcategory!.imagePath}',
                                  fit: BoxFit.cover,
                                  headers: {
                                    'Authorization':
                                        'Bearer ${Authorization.token}'
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildErrorPlaceholder(
                                        'Unable to load image from server');
                                  },
                                )
                              : _buildErrorPlaceholder('No image selected'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.add_photo_alternate),
                    label: const Text('Izaberi sliku'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D3557),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ],
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

  Widget _buildErrorPlaceholder(String message) {
    return Container(
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey[600],
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() {
        _isUploadingImage = true;
      });

      try {
        final formData = _formKey.currentState?.value;
        var request = Map.from(_formKey.currentState!.value);
        request['categoryId'] = int.parse(request['categoryId']);

        SubcategoryModel savedSubcategory;
        if (widget.subcategory == null) {
          savedSubcategory = await _subcategoryProvider.insert(request);
        } else {
          savedSubcategory = await _subcategoryProvider.update(
              widget.subcategory!.id!, request);
        }

        if (_selectedImage != null) {
          await uploadImage('Subcategory', savedSubcategory.id!,
              _selectedImage!, Authorization.token!);
          await _refreshSubcategoryData();
          setState(() {
            _selectedImage = null;
          });
        }

        await Future.delayed(const Duration(milliseconds: 500));

        if (_subcategory?.id != null) {
          final finalRefresh =
              await _subcategoryProvider.getById(_subcategory!.id!);
          setState(() {
            _subcategory = finalRefresh;
          });
        }

        if (_subcategory?.imagePath != null) {
          Navigator.pop(context, true);
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text("Warning"),
              content: const Text(
                  "Image upload completed but the path was not received. Please try refreshing the page."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
      } on Exception catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("Error"),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } finally {
        setState(() {
          _isUploadingImage = false;
        });
      }
    }
  }
}
