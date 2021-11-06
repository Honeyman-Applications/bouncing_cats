import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bouncing_cats/cat.dart';
import 'dart:io';
import 'package:universal_platform/universal_platform.dart';

/// Allows users to take a picture using their device's camera
/// Then that picture is loaded as a cat
/// addCat is a function that is passed in the constructor, which is
/// called when the picture from the user is ready to be loaded as a cat
class AddCustomCat extends StatefulWidget {
  final Function(Image image) addCat;

  AddCustomCat({
    Key? key,
    required this.addCat,
  }) : super(key: key);

  @override
  _AddCustomCatState createState() {
    return _AddCustomCatState();
  }
}

class _AddCustomCatState extends State<AddCustomCat> {
  late final ImagePicker _picker;

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(
        Icons.camera_alt,
      ),
      onPressed: () async {
        // have user take or cancel taking picture
        final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
        );

        // if not web, load the picture from a local file
        if (!UniversalPlatform.isWeb) {
          widget.addCat(
            await Image.file(
              File(image!.path),
            ),
          );

          // if web load picture from a network path
        } else {
          widget.addCat(
            await Image.network(
              image!.path,
            ),
          );
        }
      },
    );
  }
}
