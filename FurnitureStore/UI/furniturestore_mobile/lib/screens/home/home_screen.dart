import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/models/promotion/promotion.dart';
import 'package:furniturestore_mobile/providers/promotion_provider.dart';
import 'package:furniturestore_mobile/screens/product/product_list_screen.dart';
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
                  children: categories != null
                      ? categories!
                          .map((category) => _buildCategoryCard(
                              category.name ?? '', Icons.category))
                          .toList()
                      : [
                          _buildCategoryCard(
                              "Učitavanje...", Icons.hourglass_empty),
                        ],
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

              // const Text(
              //   "Popularni proizvodi",
              //   style: TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // const SizedBox(height: 10),
              // GridView.builder(
              //   shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //     crossAxisCount: 2,
              //     crossAxisSpacing: 10,
              //     mainAxisSpacing: 10,
              //     childAspectRatio: 0.75,
              //   ),
              //   itemCount: 4,
              //   itemBuilder: (context, index) {
              //     return _buildPopularProductCard(
              //         "Product $index", "\$${100 + index * 50}");
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
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
            Icon(icon, size: 40, color: const Color(0xFF1D3557)),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ],
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

  Widget _buildPopularProductCard(String title, String price) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[300],
              width: double.infinity,
              child: const Icon(Icons.image, size: 50, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              price,
              style: const TextStyle(fontSize: 14, color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}
