import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:furniturestore_admin/models/account/account.dart';
import 'package:furniturestore_admin/models/product/product.dart';
import 'package:furniturestore_admin/models/promotion/promotion.dart';
import 'package:furniturestore_admin/models/search_result.dart';
import 'package:furniturestore_admin/providers/account_provider.dart';
import 'package:furniturestore_admin/providers/promotion_provider.dart';
import 'package:furniturestore_admin/providers/product_provider.dart';
import 'package:furniturestore_admin/utils/utils.dart';
import 'package:furniturestore_admin/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:furniturestore_admin/utils/image_handling_mixin.dart';

const String baseUrl = 'http://localhost:7015';

class PromotionDetailScreen extends StatefulWidget {
  final PromotionModel? promotion;

  const PromotionDetailScreen({super.key, this.promotion});

  @override
  _PromotionDetailScreenState createState() => _PromotionDetailScreenState();
}

class _PromotionDetailScreenState extends State<PromotionDetailScreen>
    with ImageHandlingMixin {
  final _formKey = GlobalKey<FormBuilderState>();
  late PromotionProvider _promotionProvider;
  late AccountProvider _accountProvider;
  late ProductProvider _productProvider;
  Map<String, dynamic> _initialValue = {};
  SearchResult<AccountModel>? adminResult;
  SearchResult<ProductModel>? productResult;
  bool isLoading = true;
  List<int?> _selectedProducts = [];
  dynamic currentUser;
  File? _selectedImage;
  bool _isUploadingImage = false;
  PromotionModel? _promotion;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _promotionProvider = context.read<PromotionProvider>();
    _accountProvider = context.read<AccountProvider>();
    _productProvider = context.read<ProductProvider>();

    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      adminResult = await _accountProvider.getAll(filter: {'userTypes': 1});
      productResult = await _productProvider.get();
      currentUser = _accountProvider.getCurrentUser();

      if (widget.promotion != null) {
        _selectedProducts =
            widget.promotion!.products?.map((p) => p.id).toList() ?? [];
        _initialValue = {
          'heading': widget.promotion?.heading ?? '',
          'content': widget.promotion?.content ?? '',
          'adminId': widget.promotion?.adminId ?? '',
          'products': _selectedProducts,
        };
        _promotion = widget.promotion;
      } else {
        _initialValue = {
          'heading': '',
          'content': '',
          'adminId': '',
          'products': [],
        };
        _promotion = null;
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.promotion == null ? 'New Promotion' : 'Promotion Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : LayoutBuilder(builder: (context, constraints) {
                bool isSmallScreen = constraints.maxWidth < 1000;

                return Row(
                  children: [
                    Expanded(
                      flex: isSmallScreen ? 3 : 6,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Slika promocije',
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
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return _buildErrorPlaceholder(
                                              'Error loading selected image');
                                        },
                                      )
                                    : _promotion?.imagePath != null
                                        ? Image.network(
                                            _promotion!.imagePath!
                                                    .startsWith('http')
                                                ? _promotion!.imagePath!
                                                : '$baseUrl${_promotion!.imagePath}',
                                            fit: BoxFit.cover,
                                            headers: {
                                              'Authorization':
                                                  'Bearer ${Authorization.token}'
                                            },
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
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
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return _buildErrorPlaceholder(
                                                  'Error loading image');
                                            },
                                          )
                                        : _buildErrorPlaceholder('Nema slike'),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _isUploadingImage ? null : _pickImage,
                              icon: const Icon(Icons.image),
                              label: const Text("Odaberi sliku"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: isSmallScreen ? 7 : 4,
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
                                  widget.promotion == null
                                      ? 'Nova promocija'
                                      : 'Detalji o promociji',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 20),
                                const CustomTextField(
                                    name: 'heading',
                                    label: 'Naslov',
                                    isRequired: true),
                                const CustomTextField(
                                    name: 'content',
                                    label: 'Sadržaj',
                                    isRequired: true,
                                    maxLines: 3),
                                const SizedBox(height: 20),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Text(
                                    'Dodaj proizvode za ovu promociju',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: DropdownSearch<
                                      ProductModel>.multiSelection(
                                    items: (filter, scrollController) =>
                                        productResult?.result ?? [],
                                    selectedItems: _selectedProducts.map((id) {
                                      return productResult!.result.firstWhere(
                                          (product) => product.id == id);
                                    }).toList(),
                                    itemAsString: (ProductModel? product) =>
                                        product?.name ?? '',
                                    onChanged: (List<ProductModel>? products) {
                                      setState(() {
                                        _selectedProducts = products
                                                ?.map((p) => p.id)
                                                .toList() ??
                                            [];
                                      });
                                    },
                                    dropdownBuilder: (context, selectedItems) {
                                      return SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: ConstrainedBox(
                                          constraints: const BoxConstraints(
                                              minWidth: 500, maxWidth: 600),
                                          child: Wrap(
                                            children:
                                                selectedItems.map((product) {
                                              return Chip(
                                                label: Text(product.name ?? ''),
                                                onDeleted: () {
                                                  setState(() {
                                                    _selectedProducts
                                                        .remove(product.id);
                                                  });
                                                },
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      );
                                    },
                                    compareFn:
                                        (ProductModel? a, ProductModel? b) =>
                                            a?.id == b?.id,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: _savePromotion,
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color(0xFFF4A258),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0, horizontal: 32.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                        widget.promotion == null
                                            ? 'Dodaj'
                                            : 'Sačuvaj',
                                        style: const TextStyle(fontSize: 16)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
      ),
    );
  }

  void _savePromotion() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() {
        _isUploadingImage = true;
      });

      try {
        var formValue = _formKey.currentState?.value;
        List<int?> selectedProductIds = _selectedProducts;

        var request = {
          'heading': formValue!['heading'],
          'content': formValue['content'],
          'adminId': currentUser?.nameid,
          'productIds': selectedProductIds,
        };

        PromotionModel savedPromotion;
        if (widget.promotion == null) {
          savedPromotion = await _promotionProvider.insert(request);
        } else {
          savedPromotion =
              await _promotionProvider.update(widget.promotion!.id!, request);
        }

        if (_selectedImage != null) {
          await uploadImage('Promotion', savedPromotion.id!, _selectedImage!,
              Authorization.token!);

          final updatedPromotion =
              await _promotionProvider.getById(savedPromotion.id!);
          setState(() {
            _promotion = updatedPromotion;
            _selectedImage = null;
          });
        }

        Navigator.pop(context, true);
      } catch (e) {
        print("Error saving promotion: $e");
        if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text("Error"),
              content: Text("Error saving promotion: $e"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
      } finally {
        setState(() {
          _isUploadingImage = false;
        });
      }
    } else {
      print('Validation failed');
    }
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

  void _pickImage() async {
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
}
