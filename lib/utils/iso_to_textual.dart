const _isoToTextual = {
  'en': 'English',
  'ar': 'Arabic',
  'fr': 'French',
  'es': 'Spanish',
  'de': 'German',
  'it': 'Italian',
  'pt': 'Portuguese',
  'ru': 'Russian',
  'zh': 'Chinese',
  'ja': 'Japanese',
  'ko': 'Korean',
  'tr': 'Turkish',
  'nl': 'Dutch',
  'pl': 'Polish',
  'sv': 'Swedish',
};

/// Converts an ISO 639-1 language code to its textual name.
String isoToTextual(String isoCode) {
  return _isoToTextual[isoCode.toLowerCase()] ?? isoCode;
}
