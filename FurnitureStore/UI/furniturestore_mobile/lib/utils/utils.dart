import 'package:furniturestore_mobile/models/decoration_item/decoration_item.dart';
import 'package:furniturestore_mobile/models/product/product.dart';
import 'package:furniturestore_mobile/models/gift_card/gift_card.dart';
import 'package:furniturestore_mobile/models/product_pictures/product_pictures.dart';
import 'package:furniturestore_mobile/providers/decoration_item_provider.dart';
import 'package:furniturestore_mobile/providers/product_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Authorization {
  static String? token;
}

class WishList {
  static List<int> productIds = [];
  static List<ProductModel> _cachedProducts = [];
  static List<int> decorationItemIds = [];
  static List<DecorationItemModel> _cachedDecorationItems = [];

  static Future<void> loadWishList() async {
    final prefs = await SharedPreferences.getInstance();
    productIds =
        prefs.getStringList('wishList_products')?.map(int.parse).toList() ?? [];
    decorationItemIds =
        prefs.getStringList('wishList_decorations')?.map(int.parse).toList() ??
            [];
  }

  static Future<void> saveWishList() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'wishList_products', productIds.map((e) => e.toString()).toList());
    await prefs.setStringList('wishList_decorations',
        decorationItemIds.map((e) => e.toString()).toList());
  }

  static Future<void> addProductToWishList(int productId) async {
    if (!productIds.contains(productId)) {
      productIds.add(productId);
      await saveWishList();
    }
  }

  static Future<void> removeProductFromWishList(int productId) async {
    productIds.remove(productId);
    _cachedProducts.removeWhere((p) => p.id == productId);
    await saveWishList();
  }

  static bool isProductInWishList(int productId) {
    return productIds.contains(productId);
  }

  static Future<List<ProductModel>> getProductsByIds(
      List<int> productIds) async {
    List<ProductModel> products = [];
    ProductProvider provider = ProductProvider();

    products = _cachedProducts.where((p) => productIds.contains(p.id)).toList();

    final missingIds =
        productIds.where((id) => !products.any((p) => p.id == id)).toList();

    for (int id in missingIds) {
      try {
        ProductModel product = await provider.getById(id);
        products.add(product);
        _cachedProducts.add(product);
      } catch (e) {
        print('Error fetching product with id $id: $e');
      }
    }

    return products;
  }

  static void cacheProduct(ProductModel product) {
    if (!_cachedProducts.any((p) => p.id == product.id)) {
      _cachedProducts.add(product);
    }
  }

  static Future<void> addDecorationItemToWishList(int decorationItemId) async {
    if (!decorationItemIds.contains(decorationItemId)) {
      decorationItemIds.add(decorationItemId);
      await saveWishList();
    }
  }

  static Future<void> removeDecorationItemFromWishList(
      int decorationItemId) async {
    decorationItemIds.remove(decorationItemId);
    _cachedDecorationItems.removeWhere((p) => p.id == decorationItemId);
    await saveWishList();
  }

  static bool isDecorationItemInWishList(int decorationItemId) {
    return decorationItemIds.contains(decorationItemId);
  }

  static void cacheDecorationItem(DecorationItemModel item) {
    if (!_cachedDecorationItems.any((p) => p.id == item.id)) {
      _cachedDecorationItems.add(item);
    }
  }

  static Future<List<DecorationItemModel>> getDecorationItemsByIds(
      List<int> ids) async {
    final provider = DecorationItemProvider();
    List<DecorationItemModel> items = [];

    for (var id in ids) {
      try {
        final item = await provider.getById(id);
        items.add(item);
      } catch (e) {
        print('Error fetching decoration item with id $id: $e');
      }
    }

    for (var item in items) {
      if (item.id != null) {
        final response = await http.get(
          Uri.parse(
              'http://10.0.2.2:7015/api/ProductPicture/GetByEntityTypeAndId/DecorativeItem/${item.id}'),
          headers: {
            'Authorization': 'Bearer ${Authorization.token}',
            'Content-Type': 'application/json',
          },
        );
        if (response.statusCode == 200) {
          final pictures = (jsonDecode(response.body) as List)
              .map((x) => ProductPicturesModel.fromJson(x))
              .toList();
          item.productPictures = pictures;
        }
      }
    }
    return items;
  }
}

class Order {
  static final List<dynamic> _orderItems = [];
  static final Map<int, int> _itemQuantities = {};
  static final List<Function> _listeners = [];

  static void addListener(Function listener) {
    _listeners.add(listener);
  }

  static void removeListener(Function listener) {
    _listeners.remove(listener);
  }

  static void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  static List<dynamic> getOrderItems() {
    return _orderItems;
  }

  static int getItemCount() {
    return _itemQuantities.values.fold(0, (sum, quantity) => sum + quantity);
  }

  static void clearOrder() {
    _orderItems.clear();
    _itemQuantities.clear();
    _notifyListeners();
  }

  static void addProductToOrder(ProductModel product) {
    if (product.id == null) return;

    if (!_orderItems
        .any((item) => item is ProductModel && item.id == product.id)) {
      _orderItems.add(product);
    }
    _itemQuantities[product.id!] = (_itemQuantities[product.id!] ?? 0) + 1;
    _notifyListeners();
  }

  static void removeProductFromOrder(ProductModel product) {
    if (product.id == null) return;

    if (_itemQuantities[product.id!] != null) {
      _itemQuantities[product.id!] = _itemQuantities[product.id!]! - 1;
      if (_itemQuantities[product.id!] == 0) {
        _itemQuantities.remove(product.id!);
        _orderItems.removeWhere(
            (item) => item is ProductModel && item.id == product.id);
      }
    }
    _notifyListeners();
  }

  static void addGiftCardToOrder(GiftCardModel giftCard) {
    if (giftCard.id == null) return;

    if (!_orderItems
        .any((item) => item is GiftCardModel && item.id == giftCard.id)) {
      _orderItems.add(giftCard);
    }
    _itemQuantities[giftCard.id!] = (_itemQuantities[giftCard.id!] ?? 0) + 1;
    _notifyListeners();
  }

  static void removeGiftCardFromOrder(GiftCardModel giftCard) {
    if (giftCard.id == null) return;

    if (_itemQuantities[giftCard.id!] != null) {
      _itemQuantities[giftCard.id!] = _itemQuantities[giftCard.id!]! - 1;
      if (_itemQuantities[giftCard.id!] == 0) {
        _itemQuantities.remove(giftCard.id!);
        _orderItems.removeWhere(
            (item) => item is GiftCardModel && item.id == giftCard.id);
      }
    }
    _notifyListeners();
  }

  static List<ProductModel> getProductItems() {
    return _orderItems.whereType<ProductModel>().cast<ProductModel>().toList();
  }

  static List<GiftCardModel> getGiftCardItems() {
    return _orderItems
        .whereType<GiftCardModel>()
        .cast<GiftCardModel>()
        .toList();
  }

  static int getItemQuantity(dynamic item) {
    if (item is ProductModel && item.id != null) {
      return _itemQuantities[item.id!] ?? 0;
    } else if (item is GiftCardModel && item.id != null) {
      return _itemQuantities[item.id!] ?? 0;
    }
    return 0;
  }

  static Map<dynamic, int> getCartItemsWithQuantities() {
    Map<dynamic, int> result = {};
    for (var item in _orderItems) {
      if (item is ProductModel && item.id != null) {
        result[item] = _itemQuantities[item.id!] ?? 0;
      } else if (item is GiftCardModel && item.id != null) {
        result[item] = _itemQuantities[item.id!] ?? 0;
      } else if (item is DecorationItemModel && item.id != null) {
        result[item] = _itemQuantities[item.id!] ?? 0;
      }
    }
    return result;
  }

  static void addDecorationItemToOrder(DecorationItemModel item) {
    if (item.id == null) return;

    if (!_orderItems.any((orderItem) =>
        orderItem is DecorationItemModel && orderItem.id == item.id)) {
      _orderItems.add(item);
    }
    _itemQuantities[item.id!] = (_itemQuantities[item.id!] ?? 0) + 1;
    _notifyListeners();
  }

  static void removeDecorationItemFromOrder(DecorationItemModel item) {
    if (item.id == null) return;

    if (_itemQuantities[item.id!] != null) {
      _itemQuantities[item.id!] = _itemQuantities[item.id!]! - 1;
      if (_itemQuantities[item.id!] == 0) {
        _itemQuantities.remove(item.id!);
        _orderItems.removeWhere((orderItem) =>
            orderItem is DecorationItemModel && orderItem.id == item.id);
      }
    }
    _notifyListeners();
  }

  static List<DecorationItemModel> getDecorationItems() {
    return _orderItems
        .whereType<DecorationItemModel>()
        .cast<DecorationItemModel>()
        .toList();
  }

  static Future<List<DecorationItemModel>>
      getDecorationItemsWithPictures() async {
    List<DecorationItemModel> items = getDecorationItems();

    for (var item in items) {
      if (item.id != null) {
        final response = await http.get(
          Uri.parse(
              'http://10.0.2.2:7015/api/ProductPicture/GetByEntityTypeAndId/DecorativeItem/${item.id}'),
          headers: {
            'Authorization': 'Bearer ${Authorization.token}',
            'Content-Type': 'application/json',
          },
        );
        if (response.statusCode == 200) {
          final pictures = (jsonDecode(response.body) as List)
              .map((x) => ProductPicturesModel.fromJson(x))
              .toList();
          item.productPictures = pictures;
        }
      }
    }
    return items;
  }
}

class ProductReservation {
  static final List<ProductModel> _reservedProducts = [];
  static final Map<int, int> _productQuantities = {};
  static final List<DecorationItemModel> _reservedDecorationItems = [];
  static final Map<int, int> _decorationItemQuantities = {};

  static List<ProductModel> getReservedProducts() {
    return _reservedProducts;
  }

  static void clearReservations() {
    _reservedProducts.clear();
    _productQuantities.clear();
    _reservedDecorationItems.clear();
    _decorationItemQuantities.clear();
  }

  static Future<void> addProductToReservation(ProductModel product) async {
    if (product.id == null) return;

    if (!_reservedProducts.any((p) => p.id == product.id)) {
      _reservedProducts.add(product);
    }
    _productQuantities[product.id!] =
        (_productQuantities[product.id!] ?? 0) + 1;
    await saveReservations();
  }

  static Future<void> removeProductFromReservation(ProductModel product) async {
    if (product.id == null) return;

    if (_productQuantities[product.id!] != null) {
      _productQuantities[product.id!] =
          (_productQuantities[product.id!] ?? 0) - 1;
      if (_productQuantities[product.id!] == 0) {
        _productQuantities.remove(product.id!);
        _reservedProducts.removeWhere((p) => p.id == product.id);
      }
    }
    await saveReservations();
  }

  static Future<void> saveReservations() async {
    final prefs = await SharedPreferences.getInstance();
    final productIds =
        _reservedProducts.map((product) => product.id.toString()).toList();
    final decorationIds =
        _reservedDecorationItems.map((item) => item.id.toString()).toList();

    await prefs.setStringList('reservedProducts', productIds);
    await prefs.setStringList('reservedDecorationItems', decorationIds);
  }

  static Future<void> loadReservations() async {
    final prefs = await SharedPreferences.getInstance();
    final productIds = prefs.getStringList('reservedProducts') ?? [];
    final decorationIds = prefs.getStringList('reservedDecorationItems') ?? [];

    _reservedProducts.clear();
    _productQuantities.clear();
    _reservedDecorationItems.clear();
    _decorationItemQuantities.clear();

    for (final id in productIds) {
      try {
        final product = await ProductProvider().getById(int.parse(id));
        _reservedProducts.add(product);
        _productQuantities[product.id ?? 0] = 1;
      } catch (e) {
        print('Error loading product with id $id: $e');
      }
    }

    for (final id in decorationIds) {
      try {
        final item = await DecorationItemProvider().getById(int.parse(id));
        _reservedDecorationItems.add(item);
        _decorationItemQuantities[item.id ?? 0] = 1;
      } catch (e) {
        print('Error loading decoration item with id $id: $e');
      }
    }
  }

  static int getProductQuantity(int productId) {
    return _productQuantities[productId] ?? 0;
  }

  static Future<void> addDecorationItemToReservation(
      DecorationItemModel item) async {
    if (item.id == null) return;

    if (!_reservedDecorationItems.any((reservedItem) =>
        reservedItem is DecorationItemModel && reservedItem.id == item.id)) {
      _reservedDecorationItems.add(item);
    }
    _decorationItemQuantities[item.id!] =
        (_decorationItemQuantities[item.id!] ?? 0) + 1;
    await saveReservations();
  }

  static Future<void> removeDecorationItemFromReservation(
      DecorationItemModel item) async {
    if (item.id == null) return;

    if (_decorationItemQuantities[item.id!] != null) {
      _decorationItemQuantities[item.id!] =
          (_decorationItemQuantities[item.id!] ?? 0) - 1;
      if (_decorationItemQuantities[item.id!] == 0) {
        _decorationItemQuantities.remove(item.id!);
        _reservedDecorationItems.removeWhere((reservedItem) =>
            reservedItem is DecorationItemModel && reservedItem.id == item.id);
      }
    }
    await saveReservations();
  }

  static List<DecorationItemModel> getReservedDecorationItems() {
    return _reservedDecorationItems;
  }

  static int getDecorationItemQuantity(int decorationItemId) {
    return _decorationItemQuantities[decorationItemId] ?? 0;
  }

  static Future<List<DecorationItemModel>>
      getReservedDecorationItemsWithPictures() async {
    List<DecorationItemModel> items = getReservedDecorationItems();

    for (var item in items) {
      if (item.id != null) {
        final response = await http.get(
          Uri.parse(
              'http://10.0.2.2:7015/api/ProductPicture/GetByEntityTypeAndId/DecorativeItem/${item.id}'),
          headers: {
            'Authorization': 'Bearer ${Authorization.token}',
            'Content-Type': 'application/json',
          },
        );
        if (response.statusCode == 200) {
          final pictures = (jsonDecode(response.body) as List)
              .map((x) => ProductPicturesModel.fromJson(x))
              .toList();
          for (var picture in pictures) {
            if (picture.id != null) {
              picture.imagePath =
                  'http://10.0.2.2:7015/api/ProductPicture/direct-image/${picture.id}';
            }
          }
          item.productPictures = pictures;
        }
      }
    }
    return items;
  }
}
