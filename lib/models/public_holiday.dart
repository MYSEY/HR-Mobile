import 'package:intl/intl.dart';

class PublicHoliday {
  final String titleKh;
  final String titleEn;
  final int? amountPercent;
  final DateTime? periodMonth;
  final DateTime from;
  final DateTime? to;

  PublicHoliday({
    required this.titleKh,
    required this.titleEn,
    this.amountPercent,
    this.periodMonth,
    required this.from,
    this.to,
  });

  // Factory method for creating an instance from JSON
  factory PublicHoliday.fromJson(Map<String, dynamic> json) {
    return PublicHoliday(
        titleKh: json['title_kh'],
        titleEn: json['title_en'],
        amountPercent: json['amount_percent'],
        periodMonth: json['period_month'] != null
            ? DateTime.parse(json['period_month'])
            : null,
        from: DateTime.parse(json['from']),
        to: json['to'] != null ? DateTime.parse(json['to']) : null);
  }

  /// Computes the formatted date range for the holiday.
  String get getDayAttribute {
    final DateFormat dayFormat = DateFormat('d'); // Day format
    final DateFormat monthFormat = DateFormat('MMM'); // Month format

    DateTime endDate = to ?? from;
    String endDay = dayFormat.format(endDate);
    String endMonth = monthFormat.format(endDate);

    int diffInDays = endDate.difference(from).inDays;
    String startDay = dayFormat.format(from);

    String holidays = '';
    int startInt = int.parse(startDay);

    if (diffInDays > 1) {
      for (int i = 0; i <= diffInDays; i++) {
        holidays += startInt + i > 9 ? '${startInt + i},' : '0${startInt + i},';
      }
      return '$endMonth $holidays';
    } else {
      return startInt > 9 ? '$endMonth $startInt' : '$endMonth 0$startInt';
    }
  }

  // Override toString for better debugging
  @override
  String toString() {
    return 'PublicHoliday(titleKh: $titleKh, titleEn: $titleEn, from: $from, to: $to)';
  }
}
