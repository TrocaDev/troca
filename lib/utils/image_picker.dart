// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);
  final void Function(File pickedImage) imagePickFn;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File pickedImage = File('');
  void _pickImage() async {
    //Camera Images
    final _picker = ImagePicker();
    final _pickedImage = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxHeight: 150,
      maxWidth: 150,
    );
    final _pickedImageFile = File(_pickedImage!.path);
    setState(() {
      pickedImage = _pickedImageFile;
    });
    widget.imagePickFn(_pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              pickedImage.path != '' ? FileImage(pickedImage) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text('Add Image'),
        ),
      ],
    );
  }
}
