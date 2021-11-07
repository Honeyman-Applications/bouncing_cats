import 'package:flutter/material.dart';
import 'package:bootstrap_like_modal/bootstrap_like_modal.dart';
import 'package:bootstrap_typography2/bootstrap_typography2.dart';

class SetCustomCatValues {
  late final GlobalKey<FormState> _formKey;
  late final BSModal _modal;
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  final Function(String name, String description) onSubmit;

  final String title;

  SetCustomCatValues({
    required BuildContext context,
    required this.onSubmit,
    this.title = "Set Cat Values:",
  }) {
    _formKey = GlobalKey<FormState>();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _modal = BSModal(
      bsModalActionsRowOptions: BSModalActionsRowOptions(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
      title: H4(
        BSTextParams(title),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                label: P(
                  BSTextParams("Cat Name:"),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a cat's name";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                label: P(
                  BSTextParams("Cat Description:"),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a cat's description";
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
    _modal.actions = [
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Colors.red,
          ),
        ),
        child: P(
          BSTextParams("Cancel"),
        ),
        onPressed: () {
          _modal.hide();
        },
      ),
      ElevatedButton(
        child: P(
          BSTextParams("Submit"),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            onSubmit(String.fromCharCodes(_nameController.text.codeUnits),
                String.fromCharCodes(_descriptionController.text.codeUnits));
            _modal.hide();
          }
        },
      ),
    ];

    _modal.show(context);
  }

  void dispose() {
    _descriptionController.dispose();
    _nameController.dispose();
  }
}
