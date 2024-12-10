import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:furniturestore_admin/models/gift_card/gift_card.dart';
import 'package:furniturestore_admin/providers/gift_card_provider.dart';
import 'package:furniturestore_admin/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class GiftCardDetailScreen extends StatefulWidget {
  final GiftCardModel? giftCard;

  const GiftCardDetailScreen({Key? key, this.giftCard}) : super(key: key);

  @override
  _GiftCardDetailScreenState createState() => _GiftCardDetailScreenState();
}

class _GiftCardDetailScreenState extends State<GiftCardDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isExpired = false;
  DateTime? _expiryDate;
  Map<String, dynamic> _initialValue = {};
  late GiftCardProvider _giftCardProvider;

  @override
  void initState() {
    super.initState();
    _expiryDate = widget.giftCard?.expiryDate;
    if (_expiryDate != null) {
      _isExpired = _expiryDate!.isBefore(DateTime.now());
    }
    _initialValue = {
      'name': widget.giftCard?.name ?? '',
      'cardNumber': widget.giftCard?.cardNumber ?? '',
      'amount': widget.giftCard?.amount?.toString() ?? '',
      'expiryDate': _expiryDate,
      'isActivated': widget.giftCard?.isActivated ?? false
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _giftCardProvider = context.read<GiftCardProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime currentDate = DateTime.now();
    final DateTime initialDate =
        _expiryDate != null && _expiryDate!.isAfter(currentDate)
            ? _expiryDate!
            : currentDate;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.giftCard == null
            ? 'Dodaj poklon kartice'
            : 'Izmijeni poklon kartice'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_isExpired)
              Text(
                'Poklon kartica je istekla',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: FormBuilder(
                        key: _formKey,
                        initialValue: _initialValue,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Detalji o poklon kartici',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      name: 'name',
                                      label: 'Naziv',
                                      isRequired: true,
                                      enabled: !_isExpired,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: CustomTextField(
                                      name: 'cardNumber',
                                      label: 'Broj kartice',
                                      isRequired: true,
                                      enabled: !_isExpired,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      name: 'amount',
                                      label: 'Količina',
                                      keyboardType: TextInputType.number,
                                      isRequired: true,
                                      enabled: !_isExpired,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: FormBuilderSwitch(
                                      name: 'isActivated',
                                      title: const Text('Kartica aktivirana'),
                                      initialValue:
                                          widget.giftCard?.isActivated ?? false,
                                      enabled: !_isExpired,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _expiryDate == null
                                          ? 'Nije izabran datum!'
                                          : 'Datum isteka: ${_expiryDate!.toLocal().toString().split(' ')[0]}',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              if (!_isExpired)
                                SizedBox(
                                  height: 300,
                                  child: CalendarDatePicker(
                                    initialDate: initialDate,
                                    firstDate: currentDate,
                                    lastDate: DateTime(2101),
                                    onDateChanged: (DateTime newDate) {
                                      setState(() {
                                        _expiryDate = newDate;
                                      });
                                    },
                                  ),
                                ),
                              if (_isExpired)
                                SizedBox(
                                  height: 300,
                                  child: Center(
                                    child: Text(
                                      'Kalendar je onemogućen zbog isteka.',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 20),
                              Visibility(
                                visible: !_isExpired,
                                child: Center(
                                  child: ElevatedButton(
                                    onPressed: _onSubmit,
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Color(0xFFF4A258),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 16.0, horizontal: 32.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text('Sačuvaj',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          "assets/images/gifts.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState?.value;
      print('Form Data: $formData');

      var request = new Map.from(_formKey.currentState!.value);

      try {
        if (widget.giftCard == null) {
          await _giftCardProvider.insert(request);
        } else {
          await _giftCardProvider.update(widget.giftCard!.id!, request);
        }

        Navigator.pop(
            context, true); // Send back a true value to indicate success
      } on Exception catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("Error"),
            content: Text(e.toString()),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK")),
            ],
          ),
        );
      }
    } else {
      print('Validation failed');
    }
  }
}
