import 'package:intl/intl.dart';

class Converter {
  static dateFromJson(String value) {
    DateTime? dateTime = DateTime.now();
    if (value != null || value.isNotEmpty) {
      dateTime = DateTime.parse(value);
    }
    return dateTime;
  }

  static dateFormat({value}) {
    String formattedDate = DateFormat.yMd().add_jm().format(value);
    return formattedDate;
  }

  static digitFormat(int value) {
    return value.toString().length == 1 ? '0$value' : value.toString();
  }
}
