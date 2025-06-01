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
  bool _dateError = false;
  bool _timeError = false;

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
      Navigator.pop(context);

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
      initialTime: const TimeOfDay(hour: 8, minute: 0),
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
      title: 'Zahtjev za rezervaciju termina',
      showBackButton: true,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Napomena o rezervaciji',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF1D3557),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _noteController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Unesite specifične zahtjeve ili detalje',
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Color(0xFF70BC69), width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo unesite napomenu';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Datum rezervacije',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF1D3557),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      color: Color(0xFF70BC69)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
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
                                      child: Text(
                                        _reservationDate == null
                                            ? 'Odaberite datum'
                                            : DateFormat.yMMMd('bs')
                                                .format(_reservationDate!),
                                        style: TextStyle(
                                          color: _dateError
                                              ? Colors.red
                                              : (_reservationDate == null
                                                  ? Colors.grey
                                                  : const Color(0xFF1D3557)),
                                          fontSize: 16,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Vrijeme rezervacije',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF1D3557),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.access_time,
                                      color: Color(0xFF70BC69)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: _selectTime,
                                      child: Text(
                                        _reservationTime == null
                                            ? 'Odaberite vrijeme'
                                            : _reservationTime!.format(context),
                                        style: TextStyle(
                                          color: _timeError
                                              ? Colors.red
                                              : (_reservationTime == null
                                                  ? Colors.grey
                                                  : const Color(0xFF1D3557)),
                                          fontSize: 16,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _dateError = _reservationDate == null;
                    _timeError = _reservationTime == null;
                  });

                  if (_formKey.currentState!.validate()) {
                    if (_reservationDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Molimo odaberite datum rezervacije.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    if (_reservationTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Molimo odaberite vrijeme rezervacije.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    _submitReservation();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF70BC69),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
                  'Potvrdi kreiranje novog zahtjeva',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
