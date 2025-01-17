import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:furniturestore_mobile/models/order/order.dart';
import 'package:furniturestore_mobile/providers/account_provider.dart';
import 'package:furniturestore_mobile/providers/order_provider.dart';
import 'package:furniturestore_mobile/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  final OrderModel? order;

  const PaymentScreen({Key? key, this.order}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CreditCardForm(
                      formKey: formKey,
                      onCreditCardModelChange: onCreditCardModelChange,
                      obscureCvv: true,
                      obscureNumber: true,
                      cardNumber: cardNumber,
                      expiryDate: expiryDate,
                      cardHolderName: cardHolderName,
                      cvvCode: cvvCode,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          bool paymentSuccess = await _makePayment();
                          if (paymentSuccess) {
                            _savePayment(context);
                          } else {
                            _showPaymentErrorDialog(context);
                          }
                        } else {
                          _showValidationErrorDialog(context);
                        }
                      },
                      child: Text('Pay Now'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  Future<bool> _makePayment() async {
    // Implement your Stripe payment logic here
    // Return true for successful payment, false for failure
    try {
      List<String> parts = expiryDate.split('/');

      var _orderProvider = context.read<OrderProvider>();
      var request = {
        'cardNumber': cardNumber,
        'month': parts[0],
        'year': parts[1],
        'cvc': cvvCode,
        'cardHolderName': cardHolderName,
        'totalPrice': widget.order?.totalPrice ?? 0,
      };
      var result = await _orderProvider.pay(request);
      return result;
    } on Exception catch (e) {
      return false;
    }
  }

  void _savePayment(BuildContext context) async {
    var orderProvider = context.read<OrderProvider>();

    try {
      var currentUser = await context.read<AccountProvider>().getCurrentUser();
      await orderProvider.save({
        'amount': widget.order?.totalPrice ?? 0,
        'notes': "Payment successful",
        'paymentDate': DateTime.now().toIso8601String(),
        'customerId': currentUser,
        'orderId': widget.order?.id ?? 0,
        'month': int.parse(expiryDate.split('/')[0]),
        'year': int.parse(expiryDate.split('/')[1]),
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Success"),
          content: Text("Payment successfully saved."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HomePageScreen())),
              child: Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Error"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  void _showPaymentErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Payment Error"),
        content: Text("There was an error processing your payment."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showValidationErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Validation Error"),
        content: Text("Please ensure all fields are filled out correctly."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
