import 'package:furniturestore_mobile/models/product/product.dart';
import 'package:furniturestore_mobile/models/gift_card/gift_card.dart';
import 'package:furniturestore_mobile/providers/product_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authorization {
  static String? token;
}

class WishList {
  static List<int> productIds = [];

  static Future<void> loadWishList() async {
    final prefs = await SharedPreferences.getInstance();
    productIds = prefs.getStringList('wishList')?.map(int.parse).toList() ?? [];
  }

  static Future<void> saveWishList() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        'wishList', productIds.map((e) => e.toString()).toList());
  }

  static Future<void> addProductToWishList(int productId) async {
    if (!productIds.contains(productId)) {
      productIds.add(productId);
      await saveWishList();
    }
  }

  static Future<void> removeProductFromWishList(int productId) async {
    productIds.remove(productId);
    await saveWishList();
  }

  static bool isProductInWishList(int productId) {
    return productIds.contains(productId);
  }

  static Future<List<ProductModel>> getProductsByIds(
      List<int> productIds) async {
    List<ProductModel> products = [];

    ProductProvider provider = ProductProvider();

    for (int id in productIds) {
      try {
        ProductModel product = await provider.getById(id);
        products.add(product);
      } catch (e) {
        print('Error fetching product with id $id: $e');
      }
    }

    return products;
  }
}

class Order {
  static final List<dynamic> _orderItems = [];

  static List<dynamic> getOrderItems() {
    return _orderItems;
  }

  static void clearOrder() {
    _orderItems.clear();
  }

  static void addProductToOrder(ProductModel product) {
    _orderItems.add(product);
  }

  static void removeProductFromOrder(ProductModel product) {
    _orderItems.remove(product);
  }

  static List<ProductModel> getProductItems() {
    return _orderItems
        .where((item) => item is ProductModel)
        .cast<ProductModel>()
        .toList();
  }

  static void addGiftCardToOrder(GiftCardModel giftCard) {
    _orderItems.add(giftCard);
  }

  static void removeGiftCardFromOrder(GiftCardModel giftCard) {
    _orderItems.remove(giftCard);
  }

  static List<GiftCardModel> getGiftCardItems() {
    return _orderItems
        .where((item) => item is GiftCardModel)
        .cast<GiftCardModel>()
        .toList();
  }
}

class ProductReservation {
  static final List<ProductModel> _reservedProducts = [];
  static final Map<int, int> _productQuantities = {};

  static List<ProductModel> getReservedProducts() {
    return _reservedProducts;
  }

  static void clearReservations() {
    _reservedProducts.clear();
    _productQuantities.clear();
  }

  static void addProductToReservation(ProductModel product) {
    if (!_reservedProducts.contains(product)) {
      _reservedProducts.add(product);
      _productQuantities[product.id ?? 0] =
          (_productQuantities[product.id] ?? 0) + 1;
    }
  }

  static void removeProductFromReservation(ProductModel product) {
    _reservedProducts.remove(product);
    if (_productQuantities[product.id] != null) {
      _productQuantities[product.id ?? 0] =
          (_productQuantities[product.id] ?? 0) - 1;
      if (_productQuantities[product.id] == 0) {
        _productQuantities.remove(product.id);
      }
    }
  }

  static Future<void> saveReservations() async {
    final prefs = await SharedPreferences.getInstance();
    final ids =
        _reservedProducts.map((product) => product.id.toString()).toList();
    prefs.setStringList('reservedProducts', ids);
  }

  static Future<void> loadReservations() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('reservedProducts') ?? [];
    _reservedProducts.clear();
    _productQuantities.clear();
    for (final id in ids) {
      try {
        final product = await ProductProvider().getById(int.parse(id));
        _reservedProducts.add(product);
        _productQuantities[product.id ?? 0] = 1;
      } catch (e) {
        print('Error loading product with id $id: $e');
      }
    }
  }

  static int getProductQuantity(int productId) {
    return _productQuantities[productId] ?? 0;
  }
}
