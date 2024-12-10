import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CustomDropdownField extends StatelessWidget {
  final String name;
  final String label;
  final bool isRequired;
  final List<DropdownMenuItem<String>> items;
  final GlobalKey<FormBuilderState> formKey;

  const CustomDropdownField({
    super.key,
    required this.name,
    required this.label,
    this.isRequired = false,
    required this.items,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: FormBuilderDropdown<String>(
        name: name,
        validator: isRequired
            ? FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: 'Polje $label je obavezno'),
              ])
            : null,
        decoration: InputDecoration(
          labelText: isRequired ? '$label *' : label,
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF1D3557)),
          ),
          errorStyle: const TextStyle(color: Colors.redAccent),
          suffix: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              formKey.currentState!.fields[name]?.reset();
            },
          ),
          hintText: 'Izaberi $label',
        ),
        items: items,
      ),
    );
  }
}
