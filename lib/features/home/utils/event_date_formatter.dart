import 'package:intl/intl.dart';

class EventDateFormatter {
  static String dateFormatter(DateTime date){
    return DateFormat('d MMM yyyy').format(date);
  }
  static String startTimeFormatter(String startTime){
    final timeParts = startTime.split(":");
    return DateFormat('h:mm a').format(
      DateTime(
        2000,
        1,
        1,
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      ),
    );
  }
  static String eventDetailsDateFormatter(DateTime date){
    return DateFormat('MMMM d, yyyy').format(date);
  }
}