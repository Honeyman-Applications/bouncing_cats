/*
  Bradley Honeyman
  Nov 5, 2021

 */
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

/// This class allows users to upload image files on a button press
/// addFileCat is called everytime an image is ready to be added as a cat
class AddFileCat extends StatefulWidget {
  final Function(Image image) addFileCat;

  AddFileCat({
    Key? key,
    required this.addFileCat,
  }) : super(key: key);

  @override
  _AddFileCatState createState() {
    return _AddFileCatState();
  }
}

class _AddFileCatState extends State<AddFileCat> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(
        Icons.attach_file,
      ),
      onPressed: () async {
        // allow user to pick a image file(s)
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          withData: true,
          allowMultiple: true,
          type: FileType.image,
        );

        // load image(s) as cats if one or more was selected
        if (result != null) {
          result.files.forEach((element) {
            widget.addFileCat(Image.memory(element.bytes!));
          });
        }
      },
    );
  }
}
