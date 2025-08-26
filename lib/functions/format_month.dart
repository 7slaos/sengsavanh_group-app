import 'package:intl/intl.dart';

class FormatMonth {
  FormatMonth({required this.month});
  final String? month;

  @override
  String toString() {
    var f = DateFormat('MM/yyyy');
    if (month == null || month.toString() == 'null') {
      return '';
    }
    return f.format(DateTime.parse(month!));
  }
}
