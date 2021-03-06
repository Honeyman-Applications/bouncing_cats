/*
  Bradley Honeyman
  Nov 5, 2021

 */
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:bouncing_cats/set_custom_cat_values.dart';

/// This class allows users to upload image files on a button press
/// addFileCat is called everytime an image is ready to be added as a cat
class AddFileCat extends StatefulWidget {
  final Function(
    Image image, {
    required String name,
    required String description,
  }) addFileCat;

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
  late List<SetCustomCatValues> _setCustomCatValues;

  @override
  void initState() {
    super.initState();
    _setCustomCatValues = <SetCustomCatValues>[];
  }

  @override
  void dispose() {
    _setCustomCatValues.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  void _loadCats(
    BuildContext context,
    List<PlatformFile> files,
    int currentIndex,
  ) {
    if (currentIndex >= 0) {
      _setCustomCatValues.add(
        SetCustomCatValues(
          context: context,
          image: Image.memory(files[currentIndex].bytes!),
          onComplete: (name, description, submitted) {
            if (submitted) {
              widget.addFileCat(
                Image.memory(files[currentIndex].bytes!),
                name: name,
                description: description,
              );
            }
            _loadCats(context, files, --currentIndex);
          },
        ),
      );
    }
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
          _loadCats(context, result.files, result.files.length - 1);
        }
      },
    );
  }
}
