import 'dart:convert';

/// Decodes a Base64Url-encoded JWT segment into a UTF-8 string.
String decode(String segment) {
  String normalized = segment.replaceAll('-', '+').replaceAll('_', '/');
  switch (normalized.length % 4) {
    case 2:
      normalized += '==';
      break;
    case 3:
      normalized += '=';
      break;
    default:
      break;
  }
  try {
    return utf8.decode(base64.decode(normalized));
  } catch (_) {
    return '';
  }
}
