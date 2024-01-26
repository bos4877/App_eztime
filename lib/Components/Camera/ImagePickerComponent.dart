import 'dart:developer';

import 'package:image_picker/image_picker.dart';

String? imagePath;
XFile? pickedImage;
String? imagePathname;
Future gallery() async {
  final pickedFile = await ImagePickerHelper.pickImage(ImageSource.gallery);
  if (pickedFile != null) {
    pickedImage = pickedFile;
    imagePath = pickedImage!.path;
    imagePathname = pickedImage!.name;
    return imagePath;
  } else {
    return null;
  }
}

Future camera() async {
  final pickedFile = await ImagePickerHelper.pickImage(ImageSource.camera);
  if (pickedFile != null) {
    pickedImage = pickedFile;
    imagePath = pickedImage!.path;
    imagePathname = pickedImage!.name;
    log(imagePath!);
    return imagePath;
  } else {
    return null;
  }
}

// Widget showImage() {
//   // ที่อยู่ของรูปภาพ
//   String image = '${imagePath}';

//   // ตรวจสอบว่ารูปภาพมีหรือไม่
//   File imageFile = File(image);
//   if (!imageFile.existsSync()) {
//     return null;
//   }
//   // แสดงรูปภาพ
//   return Image.file(imageFile);
// }

class ImagePickerHelper {
  static Future<XFile?> pickImage(ImageSource _type) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: _type,
        maxWidth: 640,
        maxHeight: 480,
        imageQuality: 20,
        preferredCameraDevice: CameraDevice.front);

    return pickedFile;
  }
}

Future faceCamera() async {
  final pickedFile = await ImagePickerHelper.pickImage(ImageSource.camera);
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
