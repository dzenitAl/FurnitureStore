import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CustomTextField extends StatelessWidget {
  final String name;
  final String label;
  final TextInputType keyboardType;
  final int maxLines;
  final bool isRequired;
  final bool enabled;
  final List<FormFieldValidator<String>>? validators;
  final String? hintText;

  const CustomTextField({
    super.key,
    required this.name,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.isRequired = false,
    this.enabled = true,
    this.validators,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: FormBuilderTextField(
        name: name,
        enabled: enabled,
        validator: FormBuilderValidators.compose([
          if (isRequired)
            FormBuilderValidators.required(
                errorText: 'Polje $label je obavezno'),
          ...?validators,
        ]),
        decoration: InputDecoration(
          labelText: isRequired ? '$label *' : label,
          hintText: hintText,
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF1D3557)),
          ),
          errorStyle: const TextStyle(color: Colors.redAccent),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
      ),
    );
  }
}
