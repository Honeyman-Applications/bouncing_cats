import 'package:flutter/material.dart';
import 'package:bootstrap_like_modal/bootstrap_like_modal.dart';
import 'package:bootstrap_typography2/bootstrap_typography2.dart';

/// builds a modal which shows the image preview,
/// and allows the user to input a cat name and description
class SetCustomCatValues {
  late final GlobalKey<FormState> _formKey;
  late final BSModal _modal;
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  final Function(String name, String description, bool submitted) onComplete;
  final Image image;

  final String title;
  late bool _submitted;

  SetCustomCatValues({
    required BuildContext context,
    required this.onComplete,
    this.title = "Set Cat Values:",
    required this.image,
  }) {
    // init global key & controllers
    _formKey = GlobalKey<FormState>();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();

    // say the form has not been submitted
    _submitted = false;

    // create a modal
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
            image,
          ],
        ),
      ),
    );

    // add cancel and submit buttons to the actions
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
            _modal.hide();
            _submitted = true;
          }
        },
      ),
    ];

    // run on complete once the modal closes, note that _submitted will be true
    // only if the submit button was pressed
    _modal.onHide = () {
      onComplete(_nameController.text, _descriptionController.text, _submitted);
    };

    // show modal once it is created
    _modal.show(context);
  }

  /// a disposal function that should be run when you are done with this class
  void dispose() {
    _descriptionController.dispose();
    _nameController.dispose();
  }
}
