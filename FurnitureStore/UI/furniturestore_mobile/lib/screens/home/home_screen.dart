import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/models/promotion/promotion.dart';
import 'package:furniturestore_mobile/providers/promotion_provider.dart';
import 'package:furniturestore_mobile/screens/product/product_list_screen.dart';
import 'package:furniturestore_mobile/screens/subcategory/subcategory_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:furniturestore_mobile/providers/category_provider.dart';
import 'package:furniturestore_mobile/models/category/category.dart';
import 'package:furniturestore_mobile/widgets/master_screen.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  late CategoryProvider _categoryProvider;
  List<CategoryModel>? categories;
  late PromotionProvider _promotionProvider;
  List<PromotionModel>? promotions;

  @override
  void initState() {
    super.initState();
    _categoryProvider = context.read<CategoryProvider>();
    _promotionProvider = context.read<PromotionProvider>();

    _loadData();
  }

  Future<void> _loadData() async {
    try {
      var categoriesData = await _categoryProvider.get('');
      var promotionsData = await _promotionProvider.get('');
      setState(() {
        categories = categoriesData.result;
        promotions = promotionsData.result;
      });
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "",
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Kategorije",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: (categories == null || categories!.isEmpty)
                      ? [
                          const Center(
                              child: Text('Nema dostupnih kategorija')),
                        ]
                      : categories!
                          .map((category) => _buildCategoryCard(category))
                          .toList(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Promocije",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: promotions != null
                      ? promotions!
                          .map((promotion) =>
                              _buildPromotionCard(promotion, context))
                          .toList()
                      : [
                          _buildPromotionCard(
                              PromotionModel(heading: "Loading..."), context),
                        ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(CategoryModel category) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SubcategoryListScreen(
                category: category,
              ),
            ),
          );
        },
        child: Container(
          width: 120,
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
              const Icon(Icons.category, size: 40, color: Color(0xFF1D3557)),
              const SizedBox(height: 10),
              Text(
                category.name ?? '',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromotionCard(PromotionModel promotion, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProductListScreen(
                promotionProducts: promotion.products,
              ),
            ),
          );
        },
        child: Container(
          width: 120,
          decoration: BoxDecoration(
            color: const Color(0xFFE4F0D0),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.local_offer, size: 40, color: Color(0xFF70BC69)),
              const SizedBox(height: 10),
              Text(
                promotion.heading ?? 'Promocija',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D3557),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
