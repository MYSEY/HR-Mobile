import 'package:app/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/services/api_service.dart';
import 'package:app/models/public_holiday.dart';

final publicHolidayProvider =
    StateNotifierProvider<PublicHolidayNotifier, List<PublicHoliday>>((ref) {
  return PublicHolidayNotifier(ref);
});

class PublicHolidayNotifier extends StateNotifier<List<PublicHoliday>> {
  PublicHolidayNotifier(this.ref) : super([]);
  final Ref ref;

  Future<void> fetchPublicHolidays() async {
    try {
      final response = await ref.read(authProvider).getPublicHolidays();
      final responseData = response.data;

      // Check if 'datas' key exists, is non-null, and is of type List
      if (responseData != null && responseData['datas'] is List) {
        final datas = responseData['datas'];
        state = (datas as List).map((e) => PublicHoliday.fromJson(e)).toList();
      } else {
        // Handle case where 'datas' is missing, null, or not a list
        state = [];
        print(
            'Warning: "datas" field is missing, null, or not a list in the API response');
      }
    } catch (error) {
      print('Error fetching trainings: $error');
      state = [];
    }
  }

  Future<void> fetchSearchHolidays(
      {DateTime? fromDate, DateTime? toDate}) async {
    try {
      final response = await ref.read(authProvider).getSearchHolidays({
        'from_date': fromDate,
        'to_date': toDate,
      });
      final responseData = response.data;

      // Check if 'datas' key exists, is non-null, and is of type List
      if (responseData != null && responseData['datas'] is List) {
        final datas = responseData['datas'];
        state = (datas as List).map((e) => PublicHoliday.fromJson(e)).toList();
      } else {
        // Handle case where 'datas' is missing, null, or not a list
        state = [];
        print(
            'Warning: "datas" field is missing, null, or not a list in the API response');
      }
    } catch (error) {
      print('Error fetching trainings: $error');
      state = [];
    }
  }
}
