import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:furniturestore_admin/models/gift_card/gift_card.dart';
import 'package:furniturestore_admin/providers/gift_card_provider.dart';
import 'package:furniturestore_admin/utils/utils.dart';
import 'package:furniturestore_admin/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:furniturestore_admin/utils/image_handling_mixin.dart';
import 'package:image_picker/image_picker.dart';

class GiftCardDetailScreen extends StatefulWidget {
  final GiftCardModel? giftCard;

  const GiftCardDetailScreen({super.key, this.giftCard});

  @override
  _GiftCardDetailScreenState createState() => _GiftCardDetailScreenState();
}

class _GiftCardDetailScreenState extends State<GiftCardDetailScreen>
    with ImageHandlingMixin {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isExpired = false;
  DateTime? _expiryDate;
  Map<String, dynamic> _initialValue = {};
  late GiftCardProvider _giftCardProvider;
  GiftCardModel? _giftCard;
  File? _selectedImage;
  bool _isUploadingImage = false;

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
    _giftCard = widget.giftCard;
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
              const Text(
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
                                          ? 'Datum nije izabran!'
                                          : 'Datum isteka: ${_expiryDate!.toLocal().toString().split(' ')[0]}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: _expiryDate == null
                                                ? Colors.red
                                                : Colors.black,
                                          ),
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
                                const SizedBox(
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
                                    onPressed:
                                        _expiryDate != null ? _onSubmit : null,
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color(0xFFF4A258),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0, horizontal: 32.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Sačuvaj',
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Slika poklon kartice',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D3557),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: _selectedImage != null
                                  ? Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return _buildErrorPlaceholder(
                                            'Error loading selected image');
                                      },
                                    )
                                  : _giftCard?.imagePath != null
                                      ? Image.network(
                                          _giftCard!.imagePath!
                                                  .startsWith('http')
                                              ? _giftCard!.imagePath!
                                              : '$baseUrl${_giftCard!.imagePath}',
                                          fit: BoxFit.cover,
                                          headers: {
                                            'Authorization':
                                                'Bearer ${Authorization.token}'
                                          },
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
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
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return _buildErrorPlaceholder(
                                                'Error loading image');
                                          },
                                        )
                                      : _buildErrorPlaceholder('Nema slike'),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _isUploadingImage ? null : _pickImage,
                            icon: const Icon(Icons.image),
                            label: const Text("Odaberi sliku"),
                          ),
                        ],
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

  Widget _buildErrorPlaceholder(String message) {
    return Container(
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey[600],
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() {
        _isUploadingImage = true;
      });

      try {
        final formData = _formKey.currentState?.value;
        var request = Map.from(_formKey.currentState!.value);

        if (_expiryDate != null) {
          request['expiryDate'] = _expiryDate!.toIso8601String();
        }

        GiftCardModel savedGiftCard;
        if (_giftCard == null) {
          savedGiftCard = await _giftCardProvider.insert(request);
          _giftCard = savedGiftCard;
        } else {
          savedGiftCard =
              await _giftCardProvider.update(_giftCard!.id!, request);
          _giftCard = savedGiftCard;
        }

        if (_selectedImage != null) {
          await uploadImage('GiftCard', savedGiftCard.id!, _selectedImage!,
              Authorization.token!);

          final updatedGiftCard =
              await _giftCardProvider.getById(savedGiftCard.id!);
          setState(() {
            _giftCard = updatedGiftCard;
            _selectedImage = null;
          });
        }

        Navigator.pop(context, true);
      } catch (e) {
        print("Error saving gift card: $e");
        if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text("Error"),
              content: Text("Error saving gift card: $e"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
      } finally {
        setState(() {
          _isUploadingImage = false;
        });
      }
    } else {
      print('Validation failed');
    }
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      print("Image picked: ${pickedFile.path}");
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } else {
      print("No image selected");
    }
  }

  String _formatDateForDisplay(DateTime? date) {
    if (date == null) return 'No date selected';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
