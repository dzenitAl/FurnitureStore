import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/models/product/product.dart';
import 'package:furniturestore_mobile/models/gift_card/gift_card.dart';
import 'package:furniturestore_mobile/models/decoration_item/decoration_item.dart';
import 'package:furniturestore_mobile/providers/account_provider.dart';
import 'package:furniturestore_mobile/providers/base_provider.dart';
import 'package:furniturestore_mobile/providers/order_provider.dart';
import 'package:furniturestore_mobile/screens/payment/payment_order.dart';
import 'package:furniturestore_mobile/screens/product/product_detail_screen.dart';
import 'package:furniturestore_mobile/utils/utils.dart';
import 'package:furniturestore_mobile/widgets/master_screen.dart';
import 'package:provider/provider.dart';
import 'package:furniturestore_mobile/widgets/cart_item_card.dart';
import 'package:furniturestore_mobile/constants/app_constants.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Map<dynamic, int> cartItems = {};
  double totalPrice = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeCartItems();
  }

  Future<void> _initializeCartItems() async {
    await _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    setState(() {
      _isLoading = true;
    });

    cartItems = Order.getCartItemsWithQuantities();

    final decorationItems = await Order.getDecorationItemsWithPictures();

    Map<dynamic, int> updatedCartItems = {};

    for (var entry in cartItems.entries) {
      if (entry.key is DecorationItemModel) {
        var itemWithPictures = decorationItems.firstWhere(
          (item) => item.id == entry.key.id,
          orElse: () => entry.key,
        );
        updatedCartItems[itemWithPictures] = entry.value;
      } else {
        updatedCartItems[entry.key] = entry.value;
      }
    }

    cartItems = updatedCartItems;
    _calculateTotalPrice();

    setState(() {
      _isLoading = false;
    });
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
        } else if (item is DecorationItemModel) {
          itemPrice = item.price ?? 0.0;
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
      } else if (item is DecorationItemModel) {
        Order.removeDecorationItemFromOrder(item);
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : cartItems.isEmpty
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

        return _buildCartItemDetails(item, quantity);
      },
    );
  }

  Widget _buildCartItemDetails(dynamic item, int quantity) {
    if (item is ProductModel) {
      return _buildProductDetails(item, quantity);
    } else if (item is GiftCardModel) {
      return _buildGiftCardDetails(item, quantity);
    } else if (item is DecorationItemModel) {
      return _buildDecorationItemDetails(item, quantity);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildProductDetails(ProductModel product, int quantity) {
    return CartItemCard(
      name: product.name ?? '',
      unitPrice: product.price ?? 0.0,
      quantity: quantity,
      imageId: product.productPictures?.isNotEmpty == true
          ? product.productPictures?.first.id
          : null,
      itemType: 'product',
      onDecrement: () {
        Order.removeProductFromOrder(product);
        _loadCartItems();
      },
      onIncrement: () {
        Order.addProductToOrder(product);
        _loadCartItems();
      },
      onRemove: () {
        final currentQuantity = Order.getItemQuantity(product);
        for (int i = 0; i < currentQuantity; i++) {
          Order.removeProductFromOrder(product);
        }
        _loadCartItems();
      },
    );
  }

  Widget _buildGiftCardDetails(GiftCardModel giftCard, int quantity) {
    return CartItemCard(
      name: giftCard.name ?? '',
      unitPrice: giftCard.amount?.toDouble() ?? 0.0,
      quantity: quantity,
      imageId: giftCard.imageId,
      imagePath: giftCard.imagePath,
      itemType: 'giftCard',
      onDecrement: () {
        Order.removeGiftCardFromOrder(giftCard);
        _loadCartItems();
      },
      onIncrement: () {
        Order.addGiftCardToOrder(giftCard);
        _loadCartItems();
      },
      onRemove: () {
        final currentQuantity = Order.getItemQuantity(giftCard);
        for (int i = 0; i < currentQuantity; i++) {
          Order.removeGiftCardFromOrder(giftCard);
        }
        _loadCartItems();
      },
    );
  }

  Widget _buildDecorationItemDetails(DecorationItemModel item, int quantity) {
    return CartItemCard(
      name: item.name ?? '',
      unitPrice: item.price ?? 0.0,
      quantity: quantity,
      imageId: item.productPictures?.isNotEmpty == true
          ? item.productPictures?.first.id
          : null,
      itemType: 'decoration',
      onDecrement: () {
        Order.removeDecorationItemFromOrder(item);
        _loadCartItems();
      },
      onIncrement: () {
        Order.addDecorationItemToOrder(item);
        _loadCartItems();
      },
      onRemove: () {
        final currentQuantity = Order.getItemQuantity(item);
        for (int i = 0; i < currentQuantity; i++) {
          Order.removeDecorationItemFromOrder(item);
        }
        _loadCartItems();
      },
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
