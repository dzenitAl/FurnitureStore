import 'package:flutter/material.dart';

class EditAccountScreen extends StatefulWidget {
  final dynamic userData;

  const EditAccountScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _phoneNumber;

  @override
  void initState() {
    super.initState();
    _email = widget.userData.email;
    _phoneNumber = widget.userData.phoneNumber;
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      widget.userData.email = _email;
      widget.userData.phoneNumber = _phoneNumber;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Podaci uspješno sačuvani.')),
      );

      Navigator.pop(context, widget.userData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uredi Podatke'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Unesite email.';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
                    return 'Unesite ispravan email.';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _phoneNumber,
                decoration: const InputDecoration(
                  labelText: 'Telefon',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Unesite broj telefona.';
                  }
                  if (!RegExp(r'^\+?[0-9]{9,15}$').hasMatch(value)) {
                    return 'Unesite ispravan broj telefona.';
                  }
                  return null;
                },
                onSaved: (value) => _phoneNumber = value!,
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 32,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Sačuvaj Promjene',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
