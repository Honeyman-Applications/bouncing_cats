import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bouncing_cats/cat.dart';
import 'dart:io';
import 'package:universal_platform/universal_platform.dart';

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
        try {
          final XFile? image = await _picker.pickImage(
            source: ImageSource.camera,
          );
          if (!UniversalPlatform.isWeb) {
            widget.addCat(
              await Image.file(
                File(image!.path),
              ),
            );
          } else {
            widget.addCat(
              await Image.network(
                image!.path,
              ),
            );
          }
        } catch (err) {}
      },
    );
  }
}
