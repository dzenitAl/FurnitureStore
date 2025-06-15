import 'package:flutter/material.dart';
import 'package:furniturestore_admin/models/account/account.dart';
import 'package:furniturestore_admin/providers/account_provider.dart';
import 'package:furniturestore_admin/widgets/master_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late AccountProvider _userProvider;
  List<AccountModel> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<AccountProvider>();
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      var data = await _userProvider.getAll();
      setState(() {
        users = data.result.where((user) => user.userType == 2).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Error"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd.MM.yyyy').format(date);
  }

  String getGenderText(int? gender) {
    switch (gender) {
      case 1:
        return 'Muško';
      case 2:
        return 'Žensko';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Lista korisnika",
      child: Container(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Ime')),
                      DataColumn(label: Text('Prezime')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Telefon')),
                      DataColumn(label: Text('Spol')),
                      DataColumn(label: Text('Datum rođenja')),
                    ],
                    rows: users.map((user) {
                      return DataRow(
                        cells: [
                          DataCell(Text(user.firstName ?? '')),
                          DataCell(Text(user.lastName ?? '')),
                          DataCell(Text(user.email ?? '')),
                          DataCell(Text(user.phoneNumber ?? '')),
                          DataCell(Text(getGenderText(user.gender))),
                          DataCell(Text(formatDate(user.birthDate))),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
      ),
    );
  }
}
