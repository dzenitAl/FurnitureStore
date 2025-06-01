import 'package:flutter/material.dart';
import 'package:furniturestore_admin/models/wish_list/wish_list.dart';
import 'package:furniturestore_admin/providers/wish_list_provider.dart';
import 'package:provider/provider.dart';

class WishListDetailScreen extends StatefulWidget {
  final WishListModel? wishList;

  const WishListDetailScreen({super.key, this.wishList});

  @override
  _WishListDetailScreenState createState() => _WishListDetailScreenState();
}

class _WishListDetailScreenState extends State<WishListDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late WishListProvider _wishListProvider;
  late TextEditingController _customerIdController;
  late TextEditingController _dateCreatedController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _wishListProvider = context.read<WishListProvider>();
  }

  @override
  void initState() {
    super.initState();
    _customerIdController = TextEditingController(
      text: widget.wishList?.customerId ?? '',
    );
    _dateCreatedController = TextEditingController(
      text: widget.wishList?.dateCreated.toString() ?? '',
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      var request = {
        'customerId': _customerIdController.text,
        'dateCreated': DateTime.parse(_dateCreatedController.text),
      };

      try {
        if (widget.wishList == null) {
          await _wishListProvider.insert(request);
        } else {
          await _wishListProvider.update(widget.wishList!.id, request);
        }
        Navigator.pop(context, true);
      } on Exception catch (e) {
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
    } else {
      print('Validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.wishList == null ? 'Dodaj ' : 'Edit Wish List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _customerIdController,
                decoration: const InputDecoration(labelText: 'Customer ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Customer ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateCreatedController,
                decoration: const InputDecoration(labelText: 'Date Created'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Date Created';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _onSubmit,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
