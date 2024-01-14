import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> pickImageFromCamera() async {
  ImagePicker imagePicker = ImagePicker();
  final image = await imagePicker.pickImage(source: ImageSource.camera);
  if (image != null) {
    return File(image.path);
  } else {
    return null;
  }
}

Future<List<File>?> pickImagesFromGallery() async {
  ImagePicker imagePicker = ImagePicker();
  final images = await imagePicker.pickMultiImage();
  if (images.isNotEmpty) {
    return images.map((e) => File(e.path)).toList();
  } else {
    return null;
  }
}
