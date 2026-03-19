import 'package:intl/intl.dart';

String isoToTextual(String? isoDate, String format) {
  if (isoDate == null || isoDate.isEmpty) return '';
  
  try {
    final dateTime = DateTime.parse(isoDate);
    final formatter = DateFormat(format);
    return formatter.format(dateTime);
  } catch (e) {
    return '';
  }
}