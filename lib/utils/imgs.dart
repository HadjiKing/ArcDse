import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class ImgHelper {
  static Future<XFile?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.gallery);
  }
  
  static Future<List<XFile>> pickMultipleImages() async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickMultiImage();
  }
  
  static Future<Uint8List?> getImageBytes(XFile file) async {
    return await file.readAsBytes();
  }
}