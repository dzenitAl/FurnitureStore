import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/models/product/product.dart';
import 'package:furniturestore_mobile/models/gift_card/gift_card.dart';
import 'package:furniturestore_mobile/providers/account_provider.dart';
import 'package:furniturestore_mobile/providers/base_provider.dart';
import 'package:furniturestore_mobile/providers/order_provider.dart';
import 'package:furniturestore_mobile/screens/payment/payment_order.dart';
import 'package:furniturestore_mobile/screens/product/product_detail_screen.dart';
import 'package:furniturestore_mobile/utils/utils.dart';
import 'package:furniturestore_mobile/widgets/master_screen.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Map<dynamic, int> cartItems = {};
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  void _loadCartItems() {
    final items = Order.getOrderItems();

    cartItems.clear();
    for (var item in items) {
      cartItems.update(item, (quantity) => quantity + 1, ifAbsent: () => 1);
    }

    _calculateTotalPrice();
    setState(() {});
  }

  void _calculateTotalPrice() {
    totalPrice = cartItems.entries.fold(
      0.0,
      (sum, entry) {
        final item = entry.key;
        final quantity = entry.value;
        double itemPrice;

        if (item is ProductModel) {
          itemPrice = item.price ?? 0.0;
        } else if (item is GiftCardModel) {
          itemPrice = (item.amount ?? 0.0).toDouble();
        } else {
          itemPrice = 0.0;
        }

        return sum + (itemPrice * quantity);
      },
    );
  }

  void _removeFromCart(dynamic item) {
    if (cartItems[item] != null) {
      if (cartItems[item]! > 1) {
        cartItems[item] = cartItems[item]! - 1;
      } else {
        cartItems.remove(item);
      }

      if (item is ProductModel) {
        Order.removeProductFromOrder(item);
      } else if (item is GiftCardModel) {
        Order.removeGiftCardFromOrder(item);
      }

      _calculateTotalPrice();
      setState(() {});
    }
  }

  Future<void> _confirmOrder() async {
    if (cartItems.isEmpty) {
      _showSnackBar('Korpa je prazna. Dodajte proizvode pre potvrde!');
      return;
    }

    setState(() {
      Order.clearOrder();
      cartItems.clear();
      _calculateTotalPrice();
    });

    _showSnackBar('Narudžba uspešno potvrđena!');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Vaša korpa',
      showBackButton: true,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: cartItems.isEmpty
            ? _buildEmptyCart()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCartList()),
                  _buildCartSummary(),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Vaša korpa je prazna',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList() {
    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems.keys.elementAt(index);
        final quantity = cartItems[item]!;

        return Expanded(child: _buildCartItemDetails(item, quantity));
      },
    );
  }

  Widget _buildCartItemDetails(dynamic item, int quantity) {
    if (item is ProductModel) {
      return _buildProductDetails(item, quantity);
    } else if (item is GiftCardModel) {
      return _buildGiftCardDetails(item, quantity);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildProductDetails(ProductModel product, int quantity) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFFE0E0E0),
                    image: DecorationImage(
                      image: (product.productPictures != null &&
                              product.productPictures!.isNotEmpty)
                          ? NetworkImage(
                              'http://10.0.2.2:7015/api/ProductPicture/direct-image/${product.productPictures!.first.id}')
                          : const AssetImage('assets/images/furniture_logo.jpg')
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D3557),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Jedinična cijena: ${product.price?.toStringAsFixed(2) ?? "0.00"} BAM',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1D3557),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (quantity > 1) {
                                  cartItems[product] = quantity - 1;
                                } else {
                                  cartItems.remove(product);
                                }
                                _calculateTotalPrice();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(Icons.remove, size: 20),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '$quantity',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          InkWell(
                            onTap: () {
                              setState(() {
                                cartItems[product] = quantity + 1;
                                _calculateTotalPrice();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(Icons.add, size: 20),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Ukupno: ${(product.price ?? 0.0) * quantity} BAM',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF70BC69),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Potvrda brisanja'),
                    content: const Text(
                        'Da li ste sigurni da želite ukloniti ovaj proizvod iz korpe?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Odustani',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            cartItems.remove(product);
                            _calculateTotalPrice();
                          });
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: const Text('Ukloni'),
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGiftCardDetails(GiftCardModel giftCard, int quantity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          giftCard.name ?? "",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D3557),
          ),
        ),
        Text(
          'Iznos: ${(giftCard.amount ?? 0.0) * quantity} KM ${quantity}x ${giftCard.amount} KM',
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF1D3557),
          ),
        ),
      ],
    );
  }

  Future<void> confirmOrder() async {
    if (cartItems.isEmpty) {
      _showSnackBar("Korpa je prazna. Dodajte proizvode pre potvrde!");
      return;
    }
    var currentUser = context.read<AccountProvider>().getCurrentUser();

    final orderRequest = {
      "orderDate": DateTime.now().toIso8601String(),
      // "delivery": Delivery.HomeDelivery,
      "totalPrice": totalPrice,
      "customerId": currentUser.nameid
    };

    try {
      final order = await OrderProvider().insert(orderRequest);

      Order.clearOrder();
      cartItems.clear();
      _calculateTotalPrice();

      _showSnackBar("Narudžba uspešno potvrđena!");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(order: order),
        ),
      );
    } catch (e) {
      _showSnackBar("Greška prilikom kreiranja narudžbe: $e");
    }
  }

  Widget _buildCartSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(thickness: 2),
        Text(
          'Ukupno: ${totalPrice.toStringAsFixed(2)} KM',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D3557),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 200,
          child: ElevatedButton(
            onPressed: confirmOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF70BC69),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Potvrdi narudžbu"),
          ),
        ),
      ],
    );
  }
}
