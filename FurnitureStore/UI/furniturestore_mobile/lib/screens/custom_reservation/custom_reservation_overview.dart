// Main screen with overview and navigation
import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/models/custom_furniture_reservation/custom_furniture_reservation.dart';
import 'package:furniturestore_mobile/providers/account_provider.dart';
import 'package:furniturestore_mobile/providers/custom_reservation_provider.dart';
import 'package:furniturestore_mobile/screens/custom_reservation/custom_furniture_reservation.dart';
import 'package:furniturestore_mobile/widgets/master_screen.dart';

class CustomReservationOverviewScreen extends StatefulWidget {
  const CustomReservationOverviewScreen({super.key});

  @override
  State<CustomReservationOverviewScreen> createState() =>
      _CustomReservationOverviewScreenState();
}

class _CustomReservationOverviewScreenState
    extends State<CustomReservationOverviewScreen> {
  final CustomReservationProvider _reservationProvider =
      CustomReservationProvider();
  List<CustomFurnitureReservationModel> _reservations = [];
  bool _isLoading = true;
  String? _currentUserId;
  final AccountProvider _accountProvider = AccountProvider();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day.$month.$year u $hour:$minute sati';
  }

  Future<void> _initializeData() async {
    try {
      final currentUser = _accountProvider.getCurrentUser();
      _currentUserId = currentUser.nameid;
      await _fetchReservations();
    } catch (e) {
      print("Greška pri inicijalizaciji: $e");
    }
  }

  Future<void> _fetchReservations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await _reservationProvider
          .get("", filter: {"userId": _currentUserId});
      setState(() {
        _reservations = data.result;
        _isLoading = false;
      });
    } catch (e) {
      print("Greška prilikom dohvaćanja rezervacija: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MasterScreenWidget(
        title: 'Lista rezervacija termina',
        child: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _reservations.isEmpty
                      ? const Center(
                          child: Text(
                            'Nema trenutnih zahtjeva.',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          children: [
                            const Text(
                              'Za individualne savjete, odabir materijala ili izradu po mjeri, '
                              'zakažite Vaš termin i posavjetujte se s našim timom. ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF1D3557),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Trenutni zahtjevi',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF1D3557),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ..._reservations.map((res) => Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  elevation: 3,
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.event_note,
                                      color: Color(0xFF1D3557),
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Termin za rezervaciju: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF1D3557),
                                          ),
                                        ),
                                        Text(
                                          '${res.reservationDate != null ? _formatDateTime(res.reservationDate!) : 'N/A'}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1D3557),
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Icon(
                                          res.reservationStatus == true
                                              ? Icons.check_circle
                                              : Icons.hourglass_bottom,
                                          size: 16,
                                          color: res.reservationStatus == true
                                              ? Colors.green
                                              : Colors.orange,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          res.reservationStatus == true
                                              ? 'Odobreno'
                                              : 'Na čekanju',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: res.reservationStatus == true
                                                ? Colors.green
                                                : Colors.orange,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: res.reservationStatus == true
                                        ? IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.grey),
                                            onPressed: () {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Nije moguće obrisati odobreni termin.'),
                                                  duration:
                                                      Duration(seconds: 2),
                                                ),
                                              );
                                            },
                                          )
                                        : IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () async {
                                              final confirmed =
                                                  await showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: const Text(
                                                      'Potvrda brisanja'),
                                                  content: const Text(
                                                      'Da li ste sigurni da želite obrisati ovu rezervaciju?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(false),
                                                      child:
                                                          const Text('Otkaži'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(true),
                                                      child: const Text(
                                                          'Obriši',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red)),
                                                    ),
                                                  ],
                                                ),
                                              );

                                              if (confirmed == true) {
                                                try {
                                                  await _reservationProvider
                                                      .delete(res.id!);
                                                  await _fetchReservations();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            'Rezervacija uspješno obrisana')),
                                                  );
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            'Greška prilikom brisanja: $e')),
                                                  );
                                                }
                                              }
                                            },
                                          ),
                                  ),
                                )),
                          ],
                        ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF70BC69),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const CustomFurnitureReservationScreen(),
                      ),
                    ).then((_) => _fetchReservations());
                  },
                  icon:
                      const Icon(Icons.add_circle_outline, color: Colors.white),
                  label: const Text(
                    'Podnesi zahtjev za rezervaciju',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
