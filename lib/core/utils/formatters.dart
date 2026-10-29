import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final NumberFormat _currencyFormat = NumberFormat('#,##0');

  static String pkr(num amount) {
    return 'PKR ${_currencyFormat.format(amount)}';
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatDateShort(DateTime date) {
    return DateFormat('dd MMM').format(date);
  }

  static String formatDateRange(DateTime start, DateTime end) {
    if (start.month == end.month && start.year == end.year) {
      return '${DateFormat('dd').format(start)}–${DateFormat('dd MMM').format(end)}';
    }
    return '${DateFormat('dd MMM').format(start)} – ${DateFormat('dd MMM').format(end)}';
  }

  static String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }
}
