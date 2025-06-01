import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/providers/account_provider.dart';

class EditAccountScreen extends StatefulWidget {
  final dynamic userData;

  const EditAccountScreen({super.key, required this.userData});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _phoneNumber;
  bool _changePassword = false;
  String _currentPassword = '';
  String _newPassword = '';
  String _confirmNewPassword = '';

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _email = widget.userData.email;
    _phoneNumber = widget.userData.phoneNumber;
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        widget.userData.email = _email;
        widget.userData.phoneNumber = _phoneNumber;

        if (_changePassword) {
          final accountProvider = AccountProvider();
          await accountProvider.changePassword(
            _currentPassword,
            _newPassword,
            _confirmNewPassword,
          );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Podaci uspješno sačuvani.')),
        );

        Navigator.pop(context, widget.userData);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Greška: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Uredi Profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Osnovni Podaci',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: Color(0xFF1D3557),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1D3557), width: 2),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1.5,
                    ),
                  ),
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
                decoration: InputDecoration(
                  labelText: 'Telefon',
                  prefixIcon: const Icon(
                    Icons.phone_outlined,
                    color: Color(0xFF1D3557),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1D3557), width: 2),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1.5,
                    ),
                  ),
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
              const SizedBox(height: 32),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _changePassword = !_changePassword;
                  });
                },
                icon: Icon(
                  _changePassword ? Icons.close : Icons.lock_outline,
                  color: const Color(0xFF3D5A80),
                ),
                label: Text(
                  _changePassword
                      ? 'Odustani od izmjene šifre'
                      : 'Izmijeni šifru',
                  style: TextStyle(
                    color: const Color(0xFF3D5A80),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (_changePassword) ...[
                const SizedBox(height: 16),
                const Text(
                  'Promjena Šifre',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Trenutna šifra',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFF1D3557),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF1D3557),
                        width: 2,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1.5,
                      ),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (_changePassword) {
                      if (value == null || value.isEmpty) {
                        return 'Unesite trenutnu šifru.';
                      }
                    }
                    return null;
                  },
                  onSaved: (value) => _currentPassword = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _newPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Nova šifra',
                    prefixIcon: const Icon(
                      Icons.lock_reset_outlined,
                      color: Color(0xFF1D3557),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF1D3557),
                        width: 2,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1.5,
                      ),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (_changePassword) {
                      if (value == null || value.isEmpty) {
                        return 'Unesite novu šifru.';
                      }
                      if (value.length < 6) {
                        return 'Šifra mora imati najmanje 6 karaktera.';
                      }
                    }
                    return null;
                  },
                  onSaved: (value) => _newPassword = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Potvrdi novu šifru',
                    prefixIcon: const Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFF1D3557),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF1D3557),
                        width: 2,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1.5,
                      ),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (_changePassword) {
                      if (value == null || value.isEmpty) {
                        return 'Potvrdite novu šifru.';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Šifre se ne podudaraju.';
                      }
                    }
                    return null;
                  },
                  onSaved: (value) => _confirmNewPassword = value!,
                ),
              ],
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: const Color(0xFF3D5A80),
                ),
                child: const Text(
                  'Sačuvaj Promjene',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
