import 'dart:developer';

import 'package:image_picker/image_picker.dart';

String? imagePath;
XFile? pickedImage;
String? imagePathname;
Future gallery() async {
  final pickedFile = await ImagePickerHelper.pickImage(ImageSource.gallery,20);
  if (pickedFile != null) {
    pickedImage = pickedFile;
    imagePath = pickedImage!.path;
    imagePathname = pickedImage!.name;
    return pickedImage;
  } else {
    return null;
  }
}

Future camera() async {
  final pickedFile = await ImagePickerHelper.pickImage(ImageSource.camera,20);
  if (pickedFile != null) {
    pickedImage = pickedFile;
    imagePath = pickedImage!.path;
    imagePathname = pickedImage!.name;
    log(imagePath!);
    return pickedImage;
  } else {
    return null;
  }
}



class ImagePickerHelper {
  static Future<XFile?> pickImage(ImageSource _type,int imageQuality) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: _type,
        maxWidth: 640,
        maxHeight: 480,
        imageQuality: imageQuality,
        preferredCameraDevice: CameraDevice.front);

    return pickedFile;
  }
}

Future<XFile?> faceCamera() async {
  final pickedFile = await ImagePickerHelper.pickImage(ImageSource.camera,80);
  if (pickedFile != null) {
    pickedImage = pickedFile;
    imagePath = pickedImage!.path;
    imagePathname = pickedImage!.name;
    log('faceCamera: ${imagePath!}');
    return pickedImage;
  } else {
    return null;
  }
}
