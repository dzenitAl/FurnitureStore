import 'package:flutter/material.dart';
import 'package:furniturestore_admin/models/account/account.dart';
import 'package:furniturestore_admin/models/enums/month.dart';
import 'package:furniturestore_admin/models/report/report.dart';
import 'package:furniturestore_admin/models/search_result.dart';
import 'package:furniturestore_admin/providers/account_provider.dart';
import 'package:furniturestore_admin/providers/report_provider.dart';
import 'package:furniturestore_admin/screens/report/report_list_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/enums/reportType.dart';

class ReportDetailScreen extends StatefulWidget {
  ReportModel? report;

  ReportDetailScreen({super.key, required this.report});

  @override
  _ReportDetailScreenState createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _contentController;
  late String _selectedMonth;
  late String _selectedYear;
  late ReportType _selectedReportType;
  late ReportProvider _reportProvider;
  late AccountProvider _accountProvider;
  SearchResult<AccountModel>? accountResult;
  bool isLoading = true;
  String? _selectedCustomerId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reportProvider = context.read<ReportProvider>();
    _accountProvider = context.read<AccountProvider>();
    _fetchAccounts();
  }

  Future<void> _fetchAccounts() async {
    try {
      accountResult = await _accountProvider.getAll(filter: {'userTypes': 2});
      if (accountResult?.result.isNotEmpty ?? false) {
        setState(() {
          _selectedCustomerId = accountResult!.result.isNotEmpty
              ? accountResult!.result.first.id
              : null;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching accounts: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _contentController =
        TextEditingController(text: widget.report?.content ?? '');
    _selectedMonth = _getMonthName(widget.report?.month ?? 1);
    _selectedYear = widget.report?.year?.toString() ?? "2024";
    _selectedReportType =
        widget.report != null && widget.report!.reportType != null
            ? ReportType.values[widget.report!.reportType!]
            : ReportType.Godisnji;

    if (widget.report == null) {
      widget.report = ReportModel(
        content: '',
        generationDate: DateTime.now(),
        month: DateTime.now().month,
        year: DateTime.now().year,
        reportType: ReportType.Godisnji.index,
      );
    }
  }

  String _getReportTypeName(ReportType type) {
    switch (type) {
      case ReportType.Mjesecni:
        return "Mjesečni";
      case ReportType.Godisnji:
        return "Godišnji";
      default:
        return "Godišnji";
    }
  }

  String _getMonthName(int monthNumber) {
    if (monthNumber < 1 || monthNumber > 12) return '';
    return Month.values[monthNumber - 1].toString().split('.').last;
  }

  List<String> _getYearList() {
    final currentYear = DateTime.now().year;
    return List.generate(10, (index) => (currentYear - index).toString());
  }

  List<DropdownMenuItem<ReportType>> _getReportTypeDropdownItems() {
    return ReportType.values.map((type) {
      return DropdownMenuItem<ReportType>(
        value: type,
        child: Text(_getReportTypeName(type)),
      );
    }).toList();
  }

  Widget _buildDropdownField(String name, String label, String? selectedValue,
      ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        items: accountResult?.result.map((account) {
              return DropdownMenuItem<String>(
                alignment: AlignmentDirectional.center,
                value: account.id,
                child: Text(account.fullName ?? ''),
              );
            }).toList() ??
            [],
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffix: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                onChanged(null);
              });
            },
          ),
          hintText: 'Odaberite $label',
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Polje je obavezno' : null,
      ),
    );
  }

  void _saveReport() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.report == null
            ? 'Dodaj novi izvestaj'
            : 'Informacije o izvestaju'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.report != null) ...[
                Text(
                  'Datum Generisanja: ${DateFormat('d.M.yyyy HH:mm:ss').format(widget.report!.generationDate ?? DateTime.now())}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                    labelText: 'Sadržaj', border: OutlineInputBorder()),
                maxLines: 4,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Polje je obavezno' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedMonth,
                      items: Month.values
                          .map((month) => DropdownMenuItem(
                                value: month.toString().split('.').last,
                                child: Text(month.toString().split('.').last),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMonth = value!;
                        });
                      },
                      decoration: const InputDecoration(
                          labelText: 'Mesec', border: OutlineInputBorder()),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Polje je obavezno'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedYear,
                      items: _getYearList()
                          .map((year) => DropdownMenuItem(
                                value: year,
                                child: Text(year),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedYear = value!;
                        });
                      },
                      decoration: const InputDecoration(
                          labelText: 'Godina', border: OutlineInputBorder()),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Polje je obavezno'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ReportType>(
                value: _selectedReportType,
                items: _getReportTypeDropdownItems(),
                onChanged: (value) {
                  setState(() {
                    _selectedReportType = value!;
                  });
                },
                decoration: const InputDecoration(
                    labelText: 'Tip Izveštaja', border: OutlineInputBorder()),
                validator: (value) =>
                    value == null ? 'Polje je obavezno' : null,
              ),
              const SizedBox(height: 16),
              _buildDropdownField('customerId', 'Korisnik', _selectedCustomerId,
                  (value) {
                setState(() {
                  _selectedCustomerId = value;
                });
              }),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveReport,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFFF4A258),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Sačuvaj', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
