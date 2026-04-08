import 'package:arcdse/features/appointments/appointments_store.dart';
import 'package:arcdse/utils/constants.dart';
import 'package:arcdse/utils/uuid.dart';
import 'package:arcdse/services/login.dart';
import 'package:image_picker/image_picker.dart';

/// Returns the remote URL for an image stored in PocketBase.
String getImgUrl(String recordId, String filename) {
  if (login.pb == null || login.url.isEmpty) return '';
  return '${login.url}/api/files/$dataCollectionName/$recordId/$filename';
}

/// Returns the remote URL with an optional thumbnail size suffix.
String getImgThumbUrl(String recordId, String filename, {String thumb = '200x200'}) {
  final base = getImgUrl(recordId, filename);
  if (base.isEmpty) return '';
  return '$base?thumb=$thumb';
}

/// Uploads a new image for an appointment and returns the stored filename.
Future<String> handleNewImage({
  required String rowID,
  String? sourcePath,
  XFile? sourceFile,
}) async {
  final filename = '${uuid()}.jpg';
  await appointments.uploadImg(
    rowID: rowID,
    filename: filename,
    path: sourcePath,
    file: sourceFile,
  );
  return filename;
}

/// Uploads a new image from a remote URL for an appointment and returns the stored filename.
Future<String> handleNewImageFromUrl({
  required String rowID,
  required String url,
}) async {
  final filename = '${uuid()}.jpg';
  await appointments.uploadImg(
    rowID: rowID,
    filename: filename,
    path: url,
  );
  return filename;
}

/// Deletes an image from an appointment record.
Future<void> deleteImg(String rowId, String imgName) async {
  await appointments.deleteImg(rowId, imgName);
}
