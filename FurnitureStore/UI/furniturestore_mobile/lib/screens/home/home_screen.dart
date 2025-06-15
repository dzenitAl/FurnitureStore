import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/models/promotion/promotion.dart';
import 'package:furniturestore_mobile/providers/promotion_provider.dart';
import 'package:furniturestore_mobile/screens/product/product_list_screen.dart';
import 'package:furniturestore_mobile/screens/subcategory/subcategory_list_screen.dart';
import 'package:furniturestore_mobile/utils/common_methods.dart';
import 'package:provider/provider.dart';
import 'package:furniturestore_mobile/providers/category_provider.dart';
import 'package:furniturestore_mobile/models/category/category.dart';
import 'package:furniturestore_mobile/widgets/master_screen.dart';
import 'package:furniturestore_mobile/utils/utils.dart';

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
          margin: EdgeInsets.all(2),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                spreadRadius: 0.6,
                blurRadius: 0.3,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: category.imagePath != null &&
                        category.imagePath!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          category.imagePath!.startsWith('http')
                              ? category.imagePath!
                              : 'http://10.0.2.2:7015${category.imagePath}',
                          height: 80,
                          width: 106,
                          fit: BoxFit.cover,
                          headers: {
                            'Authorization': 'Bearer ${Authorization.token}'
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(
                              height: 80,
                              width: 110,
                              child: Icon(Icons.category,
                                  size: 40, color: Color(0xFF1D3557)),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              height: 80,
                              width: 110,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : const SizedBox(
                        height: 80,
                        width: 110,
                        child: Icon(Icons.category,
                            size: 40, color: Color(0xFF1D3557)),
                      ),
              ),
              const SizedBox(height: 6),
              Text(
                category.name ?? '',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D3557),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromotionCard(PromotionModel promotion, BuildContext context) {
    final imageUrl =
        promotion.imagePath != null && promotion.imagePath!.isNotEmpty
            ? (promotion.imagePath!.startsWith('http')
                ? promotion.imagePath!
                : 'http://10.0.2.2:7015${promotion.imagePath}')
            : null;

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
          width: 184,
          margin: EdgeInsets.all(2),
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                spreadRadius: 0.6,
                blurRadius: 0.3,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          height: 80,
                          width: 170,
                          fit: BoxFit.cover,
                          headers: {
                            'Authorization': 'Bearer ${Authorization.token}'
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(
                              height: 80,
                              width: 170,
                              child: Icon(Icons.local_offer,
                                  size: 40,
                                  color: Color.fromARGB(255, 110, 180, 218)),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              height: 80,
                              width: 170,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Container(
                        height: 80,
                        width: 170,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 116, 143, 187),
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 0.6,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.local_offer,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
              ),
              const SizedBox(height: 6),
              Text(
                promotion.heading ?? 'Promocija',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
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
