import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:furniturestore_admin/models/notification/notification.dart';
import 'package:furniturestore_admin/models/account/account.dart';
import 'package:furniturestore_admin/models/search_result.dart';
import 'package:furniturestore_admin/providers/notification_provider.dart';
import 'package:furniturestore_admin/providers/account_provider.dart';
import 'package:furniturestore_admin/widgets/custom_dropdown_field.dart';
import 'package:furniturestore_admin/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class NotificationDetailScreen extends StatefulWidget {
  final NotificationModel? notification;

  const NotificationDetailScreen({Key? key, this.notification})
      : super(key: key);

  @override
  _NotificationDetailScreenState createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late NotificationProvider _notificationProvider;
  late AccountProvider _accountProvider;
  Map<String, dynamic> _initialValue = {};
  SearchResult<AccountModel>? adminResult;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _notificationProvider = context.read<NotificationProvider>();
    _accountProvider = context.read<AccountProvider>();
    _initialValue = {
      'heading': widget.notification?.heading ?? '',
      'content': widget.notification?.content ?? '',
      'adminId': widget.notification?.adminId ?? '',
    };
    _fetchAdmins();
  }

  Future<void> _fetchAdmins() async {
    try {
      adminResult = await _accountProvider.getAll(filter: {'userTypes': 1});
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching admins: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.notification == null
            ? 'New Notification'
            : 'Notification Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          "assets/images/subcategory_detail_photo.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: FormBuilder(
                        key: _formKey,
                        initialValue: _initialValue,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.notification == null
                                    ? 'Nova obavijest'
                                    : 'Detalji o obavijesti',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              SizedBox(height: 20),
                              const CustomTextField(
                                  name: 'heading',
                                  label: 'Naslov',
                                  isRequired: true),
                              const CustomTextField(
                                  name: 'content',
                                  label: 'Sadržaj',
                                  isRequired: true,
                                  maxLines: 3),
                              CustomDropdownField(
                                name: 'adminId',
                                label: 'Administrator',
                                isRequired: true,
                                formKey: _formKey,
                                items: adminResult?.result.map((admin) {
                                      return DropdownMenuItem<String>(
                                        alignment: AlignmentDirectional.center,
                                        value: admin.id,
                                        child: Text(admin.fullName ?? ''),
                                      );
                                    }).toList() ??
                                    [],
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: ElevatedButton(
                                  onPressed: _saveNotification,
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Color(0xFFF4A258),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 16.0, horizontal: 32.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                      widget.notification == null
                                          ? 'Dodaj'
                                          : 'Sačuvaj',
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _saveNotification() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState?.value;
      print('Form Data: $formData');

      var request = Map<String, dynamic>.from(formData!);

      try {
        if (widget.notification == null) {
          await _notificationProvider.insert(request);
        } else {
          await _notificationProvider.update(widget.notification!.id!, request);
        }
        Navigator.pop(context);
      } on Exception catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text("Greška"),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    } else {
      print('Validacija nije uspela');
    }
  }
}
