import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/screens/product/product_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:furniturestore_mobile/models/subcategory/subcategory.dart';
import 'package:furniturestore_mobile/models/category/category.dart';
import 'package:furniturestore_mobile/providers/subcategory_provider.dart';
import 'package:furniturestore_mobile/widgets/master_screen.dart';

class SubcategoryListScreen extends StatefulWidget {
  final CategoryModel category;

  const SubcategoryListScreen({super.key, required this.category});

  @override
  State<SubcategoryListScreen> createState() => _SubcategoryListScreenState();
}

class _SubcategoryListScreenState extends State<SubcategoryListScreen> {
  late SubcategoryProvider _subcategoryProvider;
  List<SubcategoryModel>? subcategories;
  @override
  void initState() {
    super.initState();

    _subcategoryProvider = context.read<SubcategoryProvider>();

    _loadSubcategories();
  }

  Future<void> _loadSubcategories({Map<String, String>? filters}) async {
    try {
      var allSubcategories = await _subcategoryProvider.get("");
      var resultAll = allSubcategories.result;

      subcategories = resultAll
          .where((subcategory) => subcategory.categoryId == widget.category.id)
          .toList();

      setState(() {});
    } catch (e) {
      print("Error loading subcategories: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: widget.category.name ?? "Potkategorije",
      showBackButton: true,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Podkategorije za ${widget.category.name}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D3557),
                ),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: subcategories?.length ?? 0,
                itemBuilder: (context, index) {
                  return _buildSubcategoryCard(subcategories![index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubcategoryCard(SubcategoryModel subcategory) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductListScreen(
              subcategoryId: subcategory.id,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.category_outlined,
                size: 50, color: Color(0xFF1D3557)),
            const SizedBox(height: 10),
            Text(
              subcategory.name ?? 'N/A',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
