import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/models/product/product.dart';
import 'package:furniturestore_mobile/models/gift_card/gift_card.dart';
import 'package:furniturestore_mobile/utils/utils.dart';
import 'package:furniturestore_mobile/widgets/master_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

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

  void _confirmRemove(dynamic item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Potvrda brisanja'),
          content: const Text('Jeste li sigurni da želite obrisati stavku?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Odustani'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _removeFromCart(item);
              },
              child: const Text(
                'Obriši',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
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

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(child: _buildCartItemDetails(item, quantity)),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmRemove(item),
                ),
              ],
            ),
          ),
        );
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name ?? "",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D3557),
          ),
        ),
        Text(
          'Cijena: ${(product.price ?? 0.0) * quantity} KM (${quantity}x ${product.price} KM)',
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF1D3557),
          ),
        ),
      ],
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
          'Iznos: ${(giftCard.amount ?? 0.0) * quantity} KM (${quantity}x ${giftCard.amount} KM)',
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF1D3557),
          ),
        ),
      ],
    );
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
            onPressed: _confirmOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF70BC69),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Potvrdi narudžbu',
              style: TextStyle(fontSize: 18),
            ),
          ),
        )
      ],
    );
  }
}
