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
      final currentUser = await _accountProvider.getCurrentUser();
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
        color: const Color(0xFFffefcd),
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
          const SizedBox(height: 10),
          Text('Ime: ${_currentUser?.firstName ?? 'N/A'}',
              style: const TextStyle(fontSize: 18)),
          Text('Prezime: ${_currentUser?.lastName ?? 'N/A'}',
              style: const TextStyle(fontSize: 18)),
          Text('Email: ${_currentUser?.email}',
              style: const TextStyle(fontSize: 18)),
          Text('Telefon: ${_currentUser?.phoneNumber}',
              style: const TextStyle(fontSize: 18)),
          Text(
            'Datum rođenja: ${_currentUser?.birthDate != null ? DateFormat.yMMMd().format(_currentUser!.birthDate!) : 'N/A'}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 24),
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
                backgroundColor: const Color.fromARGB(255, 75, 105, 146),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
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
                backgroundColor: const Color(0xFF1D3557),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
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
