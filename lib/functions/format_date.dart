import 'package:intl/intl.dart';

class FormatDate {
  FormatDate({required this.date});
  final String? date;

  @override
  String toString() {
    var f = DateFormat('dd/MM/yyyy');
    if (date == null || date.toString() == 'null') {
      return '';
    }
    return f.format(DateTime.parse(date!));
  }
}
