import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/main.dart';
import 'package:furniturestore_mobile/providers/account_provider.dart';
import 'package:furniturestore_mobile/screens/account_profile/profile_edit_screen.dart';
import 'package:furniturestore_mobile/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:furniturestore_mobile/models/account/account.dart';
import 'package:furniturestore_mobile/widgets/master_screen.dart';

class AccountProfileScreen extends StatefulWidget {
  const AccountProfileScreen({super.key});

  @override
  _AccountProfileScreenState createState() => _AccountProfileScreenState();
}

class _AccountProfileScreenState extends State<AccountProfileScreen> {
  final AccountProvider _accountProvider = AccountProvider();
  String? _currentUserId;
  AccountModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserId();
  }

  Future<void> _loadCurrentUserId() async {
    try {
      final currentUser = _accountProvider.getCurrentUser();
      print("USER:: ${currentUser.nameid}");
      setState(() {
        _currentUserId = currentUser.nameid;
        _loadUserDetails(_currentUserId!);
      });
    } catch (e) {
      print("Error fetching current user: $e");
    }
  }

  Future<void> _loadUserDetails(String userId) async {
    try {
      final userDetails = await _accountProvider.getUserById(userId);
      setState(() {
        _currentUser = userDetails;
      });
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Profil korisnika',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileBox(context),
            const SizedBox(height: 24),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileBox(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4EF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informacije',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D3557),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.person, 'Ime', _currentUser?.firstName ?? 'N/A'),
          _buildInfoRow(
              Icons.person, 'Prezime', _currentUser?.lastName ?? 'N/A'),
          _buildInfoRow(Icons.email, 'Email', _currentUser?.email ?? 'N/A'),
          _buildInfoRow(
              Icons.phone, 'Telefon', _currentUser?.phoneNumber ?? 'N/A'),
          _buildInfoRow(
            Icons.cake,
            'Datum rođenja',
            _currentUser?.birthDate != null
                ? DateFormat.yMMMd().format(_currentUser!.birthDate!)
                : 'N/A',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF1D3557)),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D3557),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditAccountScreen(userData: _currentUser),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF517CA8),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 5,
                shadowColor: Colors.grey.withOpacity(0.4),
              ),
              child: const Text(
                'Uredi podatke',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                Authorization.token = null;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3D5A80),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 5,
                shadowColor: Colors.grey.withOpacity(0.4),
              ),
              child: const Text(
                'Odjavi se',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
