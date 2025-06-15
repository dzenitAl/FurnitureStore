import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/models/gift_card/gift_card.dart';
import 'package:furniturestore_mobile/providers/gift_card_provider.dart';
import 'package:furniturestore_mobile/utils/utils.dart';
import 'package:furniturestore_mobile/widgets/master_screen.dart';
import 'package:provider/provider.dart';

class GiftCardListScreen extends StatefulWidget {
  const GiftCardListScreen({super.key});
  @override
  _GiftCardListScreenState createState() => _GiftCardListScreenState();
}

class _GiftCardListScreenState extends State<GiftCardListScreen> {
  List<GiftCardModel>? giftCards;
  late GiftCardProvider _giftCardProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _giftCardProvider = context.read<GiftCardProvider>();
    _loadGiftCards();
  }

  Future<void> _loadGiftCards() async {
    var data = await _giftCardProvider.get("");
    setState(() {
      giftCards = data.result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Gift Cards',
      showBackButton: true,
      child: giftCards == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: giftCards!.length,
              itemBuilder: (context, index) {
                final giftCard = giftCards![index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.only(right: 10),
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
                                    giftCard.name ?? '',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1D3557),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Iznos: ${giftCard.amount ?? 0} KM',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF1D3557),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      Order.addGiftCardToOrder(giftCard);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${giftCard.name} dodano u korpu.',
                                          ),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color(0xFF70BC69),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      elevation: 5,
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.shopping_cart, size: 20),
                                        SizedBox(width: 8),
                                        Text('Dodaj u korpu'),
                                      ],
                                    ),
                                  ),
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
                              child: giftCard.imagePath != null &&
                                      giftCard.imagePath!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        giftCard.imagePath!.startsWith('http')
                                            ? giftCard.imagePath!
                                            : 'http://10.0.2.2:7015${giftCard.imagePath}',
                                        height: 126,
                                        width: 80,
                                        fit: BoxFit.cover,
                                        headers: {
                                          'Authorization':
                                              'Bearer ${Authorization.token}'
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            height: 150,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 116, 143, 187),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.card_giftcard,
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
                                            height: 150,
                                            width: 80,
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
                                      height: 150,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 116, 143, 187),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.card_giftcard,
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
