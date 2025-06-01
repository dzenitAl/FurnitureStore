import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:furniturestore_admin/models/account/account.dart';
import 'package:furniturestore_admin/models/product/product.dart';
import 'package:furniturestore_admin/models/promotion/promotion.dart';
import 'package:furniturestore_admin/models/search_result.dart';
import 'package:furniturestore_admin/providers/account_provider.dart';
import 'package:furniturestore_admin/providers/promotion_provider.dart';
import 'package:furniturestore_admin/providers/product_provider.dart';
import 'package:furniturestore_admin/widgets/custom_dropdown_field.dart';
import 'package:furniturestore_admin/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';

class PromotionDetailScreen extends StatefulWidget {
  final PromotionModel? promotion;

  const PromotionDetailScreen({super.key, this.promotion});

  @override
  _PromotionDetailScreenState createState() => _PromotionDetailScreenState();
}

class _PromotionDetailScreenState extends State<PromotionDetailScreen> {
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
      } else {
        _initialValue = {
          'heading': '',
          'content': '',
          'adminId': '',
          'products': [],
        };
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
                                    items: productResult?.result ?? [],
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
                                            minWidth: 500,
                                            maxWidth: 600,
                                          ),
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

  Widget _customDropdownBuilder(
      BuildContext context, List<ProductModel?> selectedItems) {
    return Wrap(
      children: selectedItems.map((product) {
        return Chip(
          label: Text(product?.name ?? ''),
          onDeleted: () {
            setState(() {
              _selectedProducts.remove(product?.id);
            });
          },
        );
      }).toList(),
    );
  }

  Widget _customPopupSelectionWidget(
      BuildContext context, ProductModel item, bool isSelected) {
    return CheckboxListTile(
      value: isSelected,
      title: Text(item.name ?? ''),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (bool? selected) {
        setState(() {
          if (selected!) {
            _selectedProducts.add(item.id);
          } else {
            _selectedProducts.remove(item.id);
          }
        });
      },
    );
  }

  void _savePromotion() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      var formValue = _formKey.currentState?.value;

      List<int?> selectedProductIds = _selectedProducts;

      print(selectedProductIds);
      var request = {
        'heading': formValue!['heading'],
        'content': formValue['content'],
        'adminId': currentUser?.nameid,
        'productIds': selectedProductIds,
      };

      try {
        if (widget.promotion == null) {
          await _promotionProvider.insert(request);
        } else {
          await _promotionProvider.update(widget.promotion!.id!, request);
        }

        Navigator.pop(context, true);
      } on Exception catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("Greška"),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } else {
      print('Validacija nije uspela');
    }
  }
}
