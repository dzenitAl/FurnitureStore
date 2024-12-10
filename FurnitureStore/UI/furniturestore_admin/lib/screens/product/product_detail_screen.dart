import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:furniturestore_admin/models/product/product.dart';
import 'package:furniturestore_admin/models/search_result.dart';
import 'package:furniturestore_admin/models/subcategory/subcategory.dart';
import 'package:furniturestore_admin/providers/product_provider.dart';
import 'package:furniturestore_admin/providers/subcategory_provider.dart';
import 'package:furniturestore_admin/widgets/custom_dropdown_field.dart';
import 'package:furniturestore_admin/widgets/custom_text_field.dart';
import 'package:furniturestore_admin/widgets/master_screen.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

class ProductDetailScreen extends StatefulWidget {
  final ProductModel? product;

  const ProductDetailScreen({Key? key, this.product}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late SubcategoryProvider _subcategoryProvider;
  late ProductProvider _productProvider;
  List<File> _imageFiles = [];
  SearchResult<SubcategoryModel>? subcategoryResult;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _subcategoryProvider = context.read<SubcategoryProvider>();
    _productProvider = context.read<ProductProvider>();
    _initForm();
  }

  Future<void> _initForm() async {
    subcategoryResult = await _subcategoryProvider.get();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _imageFiles =
            pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      });
    }
  }

  Future<void> _uploadImages() async {
    if (_imageFiles.isNotEmpty) {
      try {
        final uri =
            Uri.parse('https://localhost:7015/api/ProductPicture/uploadImages');

        final productId = widget.product?.id;

        if (productId == null) {
          _showSnackBar('Product ID is missing');
          return;
        }

        var request = http.MultipartRequest('POST', uri)
          ..fields['productId'] = productId.toString();

        for (var imageFile in _imageFiles) {
          request.files
              .add(await http.MultipartFile.fromPath('images', imageFile.path));
        }

        var response = await request.send();
        if (response.statusCode == 200) {
          _showSnackBar('Images uploaded successfully');
        } else {
          _showSnackBar('Failed to upload images');
        }
      } catch (e) {
        _showSnackBar('Failed to upload images: $e');
        print(e);
      }
    } else {
      _showSnackBar('No images selected to upload');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final productData = _formKey.currentState!.value;
      if (widget.product != null) {
        await _productProvider.update(widget.product!.id as int, productData);
      } else {
        await _productProvider.insert(productData);
      }
      Navigator.pop(context);
    }
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.product != null
                ? 'Informacije o proizvodu ${widget.product!.name}'
                : 'Dodaj informacije za novi proizvod',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D3557),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
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
                    padding: const EdgeInsets.all(16.0),
                    child: FormBuilder(
                      key: _formKey,
                      initialValue: {
                        'name': widget.product?.name,
                        'description': widget.product?.description ?? "",
                        'barcode': widget.product?.barcode,
                        'price': widget.product?.price?.toString(),
                        'dimensions': widget.product?.dimensions ?? "",
                        'isAvailableInStore':
                            widget.product?.isAvailableInStore ?? false,
                        'isAvailableOnline':
                            widget.product?.isAvailableOnline ?? false,
                        'subcategoryId':
                            widget.product?.subcategoryId?.toString(),
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRow([
                              const CustomTextField(
                                  name: 'name',
                                  label: 'Naziv',
                                  isRequired: true),
                              CustomTextField(
                                name: 'barcode',
                                label: 'Barkod',
                                isRequired: true,
                                validators: [
                                  FormBuilderValidators.minLength(6,
                                      errorText:
                                          'Barkod mora imati najmanje 6 znakova'),
                                  FormBuilderValidators.maxLength(15,
                                      errorText:
                                          'Barkod ne smije imati više od 15 znakova'),
                                  FormBuilderValidators.match(
                                    r'^[a-zA-Z0-9]+$',
                                    errorText:
                                        'Barkod smije sadržavati samo slova i brojeve',
                                  ),
                                ],
                              ),
                            ]),
                            const SizedBox(height: 16),
                            _buildRow([
                              CustomDropdownField(
                                name: 'subcategoryId',
                                label: 'Potkategorija',
                                isRequired: true,
                                formKey: _formKey,
                                items: subcategoryResult?.result
                                        .map((subcategory) {
                                      return DropdownMenuItem(
                                        alignment: AlignmentDirectional.center,
                                        value: subcategory.id.toString(),
                                        child: Text(subcategory.name ?? ''),
                                      );
                                    }).toList() ??
                                    [],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSwitchField('isAvailableInStore',
                                      'Dostupno u radnji'),
                                  _buildSwitchField(
                                      'isAvailableOnline', 'Dostupno online'),
                                ],
                              ),
                            ]),
                            const SizedBox(height: 16),
                            _buildRow([
                              CustomTextField(
                                name: 'price',
                                label: 'Cijena',
                                keyboardType: TextInputType.number,
                                isRequired: true,
                                validators: [
                                  FormBuilderValidators.min(0.01,
                                      errorText:
                                          'Cijena mora biti veća od nule'),
                                ],
                              ),
                              CustomTextField(
                                name: 'dimensions',
                                label: 'Dimenzije',
                                isRequired: false,
                                validators: [
                                  FormBuilderValidators.match(
                                    r'^\d+(\.\d+)?\s*x\s*\d+(\.\d+)?\s*x\s*\d+(\.\d+)?$',
                                    errorText:
                                        'Unesite dimenzije u formatu D x Š x V, npr. 200 x 100 x 50',
                                  ),
                                ],
                                keyboardType: TextInputType.text,
                                hintText:
                                    'Unesite dimenzije u formatu D x Š x V',
                              ),
                            ]),
                            const SizedBox(height: 16),
                            const CustomTextField(
                                name: 'description',
                                label: 'Opis',
                                maxLines: 3),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _imageFiles.isEmpty
                        ? Text('No images selected.')
                        : Expanded(
                            child: CarouselSlider(
                              options: CarouselOptions(
                                  viewportFraction: 1.0,
                                  enableInfiniteScroll: false,
                                  autoPlay: true,
                                  scrollDirection: Axis.horizontal),
                              items: _imageFiles.map((imageFile) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Image.file(
                                      imageFile,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _pickImages,
                      child: Text('Pick Images'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _uploadImages,
                      child: Text('Upload Images'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: _onSubmit,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(250, 50),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text('Save'),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildRow(List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children.map((widget) {
        return Expanded(child: widget);
      }).toList(),
    );
  }

  Widget _buildSwitchField(String name, String label) {
    return FormBuilderSwitch(
      name: name,
      title: Text(label),
      controlAffinity: ListTileControlAffinity.leading,
      initialValue: false,
      decoration: const InputDecoration(border: InputBorder.none),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: widget.product != null
          ? 'Informacije o proizvodu ${widget.product!.name}'
          : 'Dodaj informacije za novi proizvod',
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildForm(),
    );
  }
}
