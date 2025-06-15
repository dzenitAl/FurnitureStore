import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/models/promotion/promotion.dart';
import 'package:furniturestore_mobile/models/search_result.dart';
import 'package:furniturestore_mobile/providers/account_provider.dart';
import 'package:furniturestore_mobile/providers/promotion_provider.dart';
import 'package:furniturestore_mobile/screens/product/product_list_screen.dart';
import 'package:furniturestore_mobile/widgets/master_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:furniturestore_mobile/utils/utils.dart';

class PromotionListScreen extends StatefulWidget {
  const PromotionListScreen({super.key});

  @override
  State<PromotionListScreen> createState() => _PromotionListScreenState();
}

class _PromotionListScreenState extends State<PromotionListScreen> {
  late PromotionProvider _promotionProvider;
  late AccountProvider _accountProvider;
  SearchResult<PromotionModel>? result;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _promotionProvider = context.read<PromotionProvider>();
    _accountProvider = context.read<AccountProvider>();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      var promotionData = await _promotionProvider.get("");
      setState(() {
        result = promotionData;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Lista akcija",
      child: result == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              itemCount: result?.result.length ?? 0,
              itemBuilder: (context, index) {
                var promotion = result!.result[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: GestureDetector(
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
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    promotion.heading ?? 'No Title',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1D3557),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    promotion.content ?? 'No Content',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  if (promotion.startDate != null &&
                                      promotion.endDate != null) ...[
                                    const SizedBox(height: 8),
                                    promotion.endDate!.isBefore(DateTime.now())
                                        ? const Row(
                                            children: [
                                              Icon(Icons.cancel,
                                                  color: Colors.redAccent,
                                                  size: 20),
                                              SizedBox(width: 6),
                                              Text(
                                                'Akcija više ne važi',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.redAccent,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(Icons.date_range,
                                                      size: 16,
                                                      color: Colors.grey),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    'Akcija traje od ${DateFormat('dd.MM.yyyy').format(promotion.startDate!)} do ${DateFormat('dd.MM.yyyy').format(promotion.endDate!)}',
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(Icons.timelapse,
                                                      size: 16,
                                                      color: Colors.blueAccent),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    'Preostalo dana: ${promotion.endDate!.difference(DateTime.now()).inDays}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.blueAccent,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                  ]
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: promotion.imagePath != null &&
                                      promotion.imagePath!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        promotion.imagePath!.startsWith('http')
                                            ? promotion.imagePath!
                                            : 'http://10.0.2.2:7015${promotion.imagePath}',
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                        headers: {
                                          'Authorization':
                                              'Bearer ${Authorization.token}'
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            height: 120,
                                            width: 120,
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 116, 143, 187),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.local_offer,
                                              size: 40,
                                              color: Colors.white,
                                            ),
                                          );
                                        },
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return SizedBox(
                                            height: 120,
                                            width: 120,
                                            child: Center(
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
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Container(
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 116, 143, 187),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.local_offer,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
