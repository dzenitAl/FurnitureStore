import 'package:intl/intl.dart';

String truncateWithEllipsis(int cutoff, String text) {
  return (text.length <= cutoff) ? text : '${text.substring(0, cutoff)}...';
}

String formatNumber(dynamic number) {
  var f = NumberFormat('###,00');
  if (number == null) {
    return "";
  }
  return f.format(number);
}
