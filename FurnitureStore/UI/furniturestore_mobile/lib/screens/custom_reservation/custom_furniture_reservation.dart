import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/models/custom_furniture_reservation/custom_furniture_reservation.dart';
import 'package:furniturestore_mobile/providers/account_provider.dart';
import 'package:furniturestore_mobile/providers/custom_reservation_provider.dart';
import 'package:furniturestore_mobile/widgets/master_screen.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class CustomFurnitureReservationScreen extends StatefulWidget {
  const CustomFurnitureReservationScreen({super.key});

  @override
  _CustomFurnitureReservationScreenState createState() =>
      _CustomFurnitureReservationScreenState();
}

class _CustomFurnitureReservationScreenState
    extends State<CustomFurnitureReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _noteController = TextEditingController();
  DateTime? _reservationDate;
  TimeOfDay? _reservationTime;
  final AccountProvider _accountProvider = AccountProvider();
  final CustomReservationProvider _reservationProvider =
      CustomReservationProvider();

  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('bs');
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final currentUser = _accountProvider.getCurrentUser();
      print("CURRENT USER:: ${currentUser.nameid}");
      setState(() {
        _currentUserId = currentUser.nameid;
      });
    } catch (e) {
      print("Greška pri dohvaćanju korisnika: $e");
    }
  }

  Future<void> _submitReservation() async {
    if (_formKey.currentState!.validate()) {
      if (_reservationDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Molimo odaberite datum rezervacije.')),
        );
        return;
      }

      if (_reservationTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Molimo odaberite vrijeme rezervacije.')),
        );
        return;
      }

      final selectedDateTime = DateTime(
        _reservationDate!.year,
        _reservationDate!.month,
        _reservationDate!.day,
        _reservationTime!.hour,
        _reservationTime!.minute,
      );

      final reservation = CustomFurnitureReservationModel(
        note: _noteController.text,
        reservationDate: selectedDateTime,
        createdDate: DateTime.now(),
        reservationStatus: false,
        userId: _currentUserId ?? "Unknown",
      );

      print("REZERVACIJA CUSTOM ==> ${reservation.toJson()}");
      await _reservationProvider.insert(reservation);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Zahtjev za rezervaciju je uspješno poslan!')),
      );

      _noteController.clear();
      setState(() {
        _reservationDate = null;
        _reservationTime = null;
      });
    }
  }

  Future<void> _selectTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 8, minute: 0),
    );

    if (pickedTime != null && (pickedTime.hour >= 8 && pickedTime.hour <= 20)) {
      setState(() {
        _reservationTime = pickedTime;
      });
    } else if (pickedTime != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Vrijeme rezervacije mora biti između 8:00 i 20:00.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Zahtjev za rezervaciju namještaja po mjeri',
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Napomena o rezervaciji',
                  style: TextStyle(fontSize: 18, color: Color(0xFF1D3557)),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _noteController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Unesite specifične zahtjeve ili detalje',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Molimo unesite napomenu';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Datum rezervacije',
                  style: TextStyle(fontSize: 18, color: Color(0xFF1D3557)),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _reservationDate = pickedDate;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      _reservationDate == null
                          ? 'Odaberite datum'
                          : DateFormat.yMMMd('bs').format(_reservationDate!),
                      style: TextStyle(
                        color: _reservationDate == null
                            ? Colors.grey
                            : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Vrijeme rezervacije',
                  style: TextStyle(fontSize: 18, color: Color(0xFF1D3557)),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _selectTime,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      _reservationTime == null
                          ? 'Odaberite vrijeme'
                          : _reservationTime!.format(context),
                      style: TextStyle(
                        color: _reservationTime == null
                            ? Colors.grey
                            : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitReservation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF70BC69),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Podnesi zahtjev za rezervaciju',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
