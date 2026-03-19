import 'dart:convert';

String decode(String base64String) {
  // Handle URL-safe base64 strings (used in JWT)
  String normalizedBase64 = base64String
      .replaceAll('-', '+')
      .replaceAll('_', '/');
  
  // Add padding if needed
  switch (normalizedBase64.length % 4) {
    case 0:
      break;
    case 2:
      normalizedBase64 += '==';
      break;
    case 3:
      normalizedBase64 += '=';
      break;
    default:
      throw Exception('Invalid base64 string');
  }
  
  return utf8.decode(base64.decode(normalizedBase64));
}