import 'package:easy_localization/easy_localization.dart';

String timeparse(String _time) {
  String timeString = _time;
  DateTime time = DateTime.parse(timeString);
  String formattedtime = DateFormat('Hms').format(time);
  return formattedtime;
}

String dateparse(String _date) {
  String dateString = _date;
  DateTime date = DateTime.parse(dateString);
  String formattedDate = DateFormat('yyyy-MM-dd').format(date);

  return formattedDate;
}

String iso8601String(String _datetime) {
  DateTime datetime = DateTime.parse(_datetime);
  String convertiso8601String = datetime.toUtc().toIso8601String();
  convertiso8601String = convertiso8601String.split('.').first + '.000Z';
  return convertiso8601String;
}
