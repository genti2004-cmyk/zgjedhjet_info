class AppFormatters {
  const AppFormatters._();

  static String number(int value) {
    final raw = value.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < raw.length; i++) {
      final reverseIndex = raw.length - i;
      buffer.write(raw[i]);

      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write(',');
      }
    }

    return buffer.toString();
  }

  static String percent(double value) {
    return '${value.toStringAsFixed(2)}%';
  }

  static String date(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day.$month.$year';
  }

  static String dateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day.$month.$year, $hour:$minute';
  }
}