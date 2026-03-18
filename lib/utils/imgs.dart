import 'package:arcdse/utils/constants.dart';
import 'package:arcdse/services/login.dart';

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
