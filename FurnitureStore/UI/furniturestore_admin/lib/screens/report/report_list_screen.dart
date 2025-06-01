import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:furniturestore_admin/components/DeleteModal.dart';
import 'package:furniturestore_admin/models/enums/month.dart';
import 'package:furniturestore_admin/models/report/report.dart';
import 'package:furniturestore_admin/models/search_result.dart';
import 'package:furniturestore_admin/providers/report_provider.dart';
import 'package:furniturestore_admin/providers/account_provider.dart';
import 'package:furniturestore_admin/screens/report/report_detail_screen.dart';
import 'package:furniturestore_admin/widgets/master_screen.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

import '../../models/enums/reportType.dart';

class ReportListScreen extends StatefulWidget {
  const ReportListScreen({super.key});

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  late ReportProvider _reportProvider;
  late AccountProvider _accountProvider;
  SearchResult<ReportModel>? result;
  Map<String, Map<String, String>> adminMap = {};
  Map<String, Map<String, String>> customerMap = {};
  final TextEditingController _monthFilterController = TextEditingController();
  final TextEditingController _yearFilterController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reportProvider = context.read<ReportProvider>();
    _accountProvider = context.read<AccountProvider>();
    _loadData();
  }

  Future<void> _loadData({Map<String, String>? filters}) async {
    try {
      var reportData = await _reportProvider.get(filter: filters);
      var adminData = await _accountProvider.getAll();
      var customerData = await _accountProvider.getAll();

      adminMap = {
        for (var user in adminData.result)
          if (user.id != null)
            user.id!: {
              'fullName': user.fullName ?? '',
              'email': user.email ?? '',
              'phoneNumber': user.phoneNumber ?? ''
            }
      };

      customerMap = {
        for (var user in customerData.result)
          if (user.id != null)
            user.id!: {
              'fullName': user.fullName ?? '',
              'email': user.email ?? '',
              'phoneNumber': user.phoneNumber ?? ''
            }
      };

      setState(() {
        result = reportData;

        if (filters != null) {
          if (filters['year'] != null && filters['year']!.isNotEmpty) {
            result!.result = result!.result
                .where((report) =>
                    report.year.toString() == filters['year']!.toLowerCase())
                .toList();
          }
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  void _applyFilters() {
    _loadData(filters: {
      'month': _monthFilterController.text,
      'year': _yearFilterController.text,
    });
  }

  String _getReportTypeName(int? type) {
    if (type == null) return "Nepoznato";
    switch (ReportType.values[type]) {
      case ReportType.Mjesecni:
        return "Mesečni";
      case ReportType.Godisnji:
        return "Godišnji";
      default:
        return "Nepoznato";
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    return DateFormat('d.M.yyyy HH:mm:ss').format(dateTime);
  }

  String _getMonthName(int? monthNumber) {
    if (monthNumber == null || monthNumber < 1 || monthNumber > 13) return '';
    return Month.values[monthNumber - 1].toString().split('.').last;
  }

  Future<void> _generatePDF(ReportModel report) async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Izveštaj',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold, font: ttf)),
              pw.SizedBox(height: 10),
              pw.Text(
                  'Datum Generisanja: ${DateFormat('d.M.yyyy HH:mm:ss').format(report.generationDate ?? DateTime.now())}',
                  style: pw.TextStyle(font: ttf)),
              pw.SizedBox(height: 10),
              pw.Text('Sadržaj: ${report.content}',
                  style: pw.TextStyle(font: ttf)),
              pw.SizedBox(height: 10),
              pw.Text('Mesec: ${_getMonthName(report.month)}',
                  style: pw.TextStyle(font: ttf)),
              pw.Text('Godina: ${report.year}', style: pw.TextStyle(font: ttf)),
              pw.Text('Tip Izveštaja: ${_getReportTypeName(report.reportType)}',
                  style: pw.TextStyle(font: ttf)),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/izvestaj_${report.id}.pdf");
    await file.writeAsBytes(await pdf.save());

    await Printing.sharePdf(
        bytes: await pdf.save(), filename: 'izvestaj_${report.id}.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleWidget:
          const Text("Lista izveštaja", style: TextStyle(fontSize: 24)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Lista izveštaja",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D3557),
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _monthFilterController,
                    decoration: const InputDecoration(
                      labelText: 'Filtriraj po mesecu',
                      labelStyle: TextStyle(color: Color(0xFF1D3557)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF1D3557)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF1D3557)),
                      ),
                    ),
                    style: const TextStyle(color: Color(0xFF1D3557)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _yearFilterController,
                    decoration: const InputDecoration(
                      labelText: 'Filtriraj po godini',
                      labelStyle: TextStyle(color: Color(0xFF1D3557)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF1D3557)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF1D3557)),
                      ),
                    ),
                    style: const TextStyle(color: Color(0xFF1D3557)),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFFF4A258),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text("Pretraga"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ReportDetailScreen(
                          report: null,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF1D3557),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text("Dodaj novi izveštaj"),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Datum Generisanja',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D3557),
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Mesec',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D3557),
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Godina',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D3557),
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Sadržaj',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D3557),
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Tip izveštaja',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D3557),
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Klijent',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D3557),
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                      DataColumn(label: Text("")),
                      DataColumn(label: Text("PDF")),
                    ],
                    rows: result?.result.map((ReportModel report) {
                          var customerInfo =
                              customerMap[report.customerId] ?? {};

                          return DataRow(
                            cells: [
                              DataCell(Text(
                                _formatDateTime(report.generationDate),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2C5C7F),
                                  fontFamily: 'Roboto',
                                ),
                              )),
                              DataCell(Text(
                                _getMonthName(report.month),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2C5C7F),
                                  fontFamily: 'Roboto',
                                ),
                              )),
                              DataCell(Text(
                                report.year.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2C5C7F),
                                  fontFamily: 'Roboto',
                                ),
                              )),
                              DataCell(Text(
                                report.content ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2C5C7F),
                                  fontFamily: 'Roboto',
                                ),
                              )),
                              DataCell(Text(
                                _getReportTypeName(report.reportType),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2C5C7F),
                                  fontFamily: 'Roboto',
                                ),
                              )),
                              DataCell(Text(
                                customerInfo['fullName'] ?? 'Nepoznato',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2C5C7F),
                                  fontFamily: 'Roboto',
                                ),
                              )),
                              DataCell(
                                DeleteModal(
                                  title: 'Potvrda brisanja',
                                  content:
                                      'Da li ste sigurni da želite obrisati ovaj izvještaj?',
                                  onDelete: () async {
                                    await _reportProvider.delete(report.id!);
                                    _loadData();
                                  },
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.picture_as_pdf,
                                      color: Color(0xFF1D3557)),
                                  onPressed: () {
                                    _generatePDF(report);
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList() ??
                        [],
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
