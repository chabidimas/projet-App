import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DateHelper {

  String getDate(String timestamp) {
    initializeDateFormatting();
    int timeInt = int.tryParse(timestamp);
    DateTime now = DateTime.now();
    DateTime datePost = DateTime.fromMillisecondsSinceEpoch(timeInt);
    DateFormat format;

    if (now.difference(datePost).inDays > 0) {
      format = new DateFormat.yMMMd("fr_FR");
    }  else {
      format  = new DateFormat.Hm("fr_FR");
    }

    return format.format(datePost).toString();

  }

}