import 'dart:io';

import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/providers/account_provider.dart';
import 'package:furniturestore_mobile/providers/category_provider.dart';
import 'package:furniturestore_mobile/providers/city_provider.dart';
import 'package:furniturestore_mobile/providers/custom_reservation_provider.dart';
import 'package:furniturestore_mobile/providers/gift_card_provider.dart';
import 'package:furniturestore_mobile/providers/notification_provider.dart';
import 'package:furniturestore_mobile/providers/order_item_provider.dart';
import 'package:furniturestore_mobile/providers/order_provider.dart';
import 'package:furniturestore_mobile/providers/product_provider.dart';
import 'package:furniturestore_mobile/providers/product_reservation.dart';
import 'package:furniturestore_mobile/providers/promotion_provider.dart';
import 'package:furniturestore_mobile/providers/subcategory_provider.dart';
import 'package:furniturestore_mobile/providers/wish_list_provider.dart';
import 'package:furniturestore_mobile/screens/account_profile/register_screen.dart';
import 'package:furniturestore_mobile/screens/home/home_screen.dart';
import 'package:furniturestore_mobile/utils/utils.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await WishList.loadWishList();

  HttpOverrides.global = MyHttpOverrides();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AccountProvider()),
      ChangeNotifierProvider(create: (_) => ProductProvider()),
      ChangeNotifierProvider(create: (_) => PromotionProvider()),
      ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ChangeNotifierProvider(create: (_) => SubcategoryProvider()),
      ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ChangeNotifierProvider(create: (_) => OrderProvider()),
      ChangeNotifierProvider(create: (_) => OrderItemProvider()),
      ChangeNotifierProvider(create: (_) => ProductReservationProvider()),
      ChangeNotifierProvider(create: (_) => GiftCardProvider()),
      ChangeNotifierProvider(create: (_) => CustomReservationProvider()),
      ChangeNotifierProvider(create: (_) => WishListProvider()),
      ChangeNotifierProvider(create: (_) => CityProvider()),
    ],
    child: const MyMaterialApp(),
  ));
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RS II Material app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.read<AccountProvider>();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background1.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 350),
                child: Card(
                  color: Colors.white.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Image.asset(
                            "assets/images/furniture_logo.jpg",
                            height: 120,
                            width: 120,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: "Korisničko ime",
                                  prefixIcon: Icon(Icons.person),
                                ),
                                controller: _usernameController,
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: "Lozinka",
                                  prefixIcon: Icon(Icons.lock),
                                ),
                                controller: _passwordController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Molimo unesite Vašu lozinku.';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters long';
                                  }
                                  if (!RegExp(
                                          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$')
                                      .hasMatch(value)) {
                                    return 'Password must contain at least one uppercase letter, one lowercase letter, and one number';
                                  }
                                  return null;
                                },
                                obscureText: true,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    var username = _usernameController.text;
                                    var password = _passwordController.text;
                                    try {
                                      var body = {
                                        'username': username,
                                        'password': password,
                                      };
                                      var result =
                                          await accountProvider.login(body);
                                      Authorization.token =
                                          result['accessToken'].toString();
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomePageScreen()));
                                    } on Exception catch (e) {
                                      print(e);
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                title: const Text("Error"),
                                                content: Text(e.toString()),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: const Text("OK"))
                                                ],
                                              ));
                                    }
                                  }
                                },
                                child: const Text("Prijavi se"),
                              ),
                              const SizedBox(height: 10),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterPage()));
                                },
                                child: const Text(
                                  "Nemate profil? Registrujte se",
                                  style: TextStyle(
                                    color: Colors.indigo,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
