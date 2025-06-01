import 'package:flutter/material.dart';

class DeleteModal extends StatelessWidget {
  final String title;
  final String content;
  final Future<void> Function() onDelete;

  const DeleteModal({
    super.key,
    required this.title,
    required this.content,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: () async {
        bool? confirmDelete = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: <Widget>[
                TextButton(
                  child: const Text('Odustani'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Obriši'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        );

        if (confirmDelete == true) {
          try {
            await onDelete();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Uspješno obrisano.")),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Greška prilikom brisanja.")),
            );
          }
        }
      },
    );
  }
}
