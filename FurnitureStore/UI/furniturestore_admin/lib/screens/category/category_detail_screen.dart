import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:furniturestore_admin/models/category/category.dart';
import 'package:furniturestore_admin/providers/category_provider.dart';
import 'package:furniturestore_admin/widgets/custom_text_field.dart';
import 'package:furniturestore_admin/widgets/master_screen.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:furniturestore_admin/utils/utils.dart';
import 'package:furniturestore_admin/utils/image_handling_mixin.dart';

class CategoryDetailScreen extends StatefulWidget {
  final CategoryModel? category;

  const CategoryDetailScreen({super.key, this.category});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen>
    with ImageHandlingMixin {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late CategoryProvider _categoryProvider;
  File? _selectedImage;
  bool _isUploadingImage = false;
  late CategoryModel? _category;

  @override
  void initState() {
    super.initState();
    _category = widget.category;
    _initialValue = {
      'name': _category?.name,
      'description': _category?.description,
    };
    _categoryProvider = context.read<CategoryProvider>();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      print("Image picked: ${pickedFile.path}");
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } else {
      print("No image selected");
    }
  }

  Future<void> _refreshCategoryData() async {
    if (_category?.id == null) return;

    try {
      print("Refreshing category data for ID: ${_category!.id}");
      final refreshedCategory = await _categoryProvider.getById(_category!.id!);
      print("Received refreshed category data:");
      print("  - Image Path: ${refreshedCategory.imagePath}");

      if (mounted) {
        // Check if the widget is still mounted
        setState(() {
          _category = refreshedCategory;
        });
      }

      // Add a debug print to verify the state update
      print("Updated category state:");
      print("  - Image Path after update: ${_category?.imagePath}");
    } catch (e) {
      print("Error refreshing category data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Building CategoryDetailScreen");
    print("isUploadingImage: $_isUploadingImage");
    print("Selected image: $_selectedImage");
    print("Category image path: ${_category?.imagePath}");
    return MasterScreenWidget(
      showBackButton: true,
      title: _category?.name ?? "Detalji o kategoriji",
      child: _buildForm(),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
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
                        'Detalji o kategoriji',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 20),
                      const CustomTextField(
                          name: 'name', label: 'Naziv', isRequired: true),
                      const CustomTextField(
                          name: 'description', label: 'Upis', maxLines: 3),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _isUploadingImage ? null : _onSubmit,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFFF4A258),
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 32.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isUploadingImage
                              ? const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text('Uploading...'),
                                  ],
                                )
                              : const Text('Sačuvaj',
                                  style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
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
                    'Slika kategorije',
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
                            )
                          : _category?.imagePath != null
                              ? Image.network(
                                  _category!.imagePath!.startsWith('http')
                                      ? _category!.imagePath!
                                      : '$baseUrl${_category!.imagePath}',
                                  fit: BoxFit.cover,
                                  headers: {
                                    'Authorization':
                                        'Bearer ${Authorization.token}'
                                  },
                                )
                              : Image.asset(
                                  "assets/images/category_detail_photo.jpg",
                                  fit: BoxFit.cover,
                                ),
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

        CategoryModel savedCategory;
        if (_category == null) {
          savedCategory = await _categoryProvider.insert(request);
        } else {
          savedCategory =
              await _categoryProvider.update(_category!.id!, request);
        }

        if (_selectedImage != null) {
          await uploadImage('Category', savedCategory.id!, _selectedImage!,
              Authorization.token!);
          await _refreshCategoryData();
          setState(() {
            _selectedImage = null;
          });
        }

        await Future.delayed(const Duration(milliseconds: 500));

        if (_category?.id != null) {
          final finalRefresh = await _categoryProvider.getById(_category!.id!);
          setState(() {
            _category = finalRefresh;
          });
        }

        if (_category?.imagePath != null) {
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
        print("Error during upload: $e");
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
