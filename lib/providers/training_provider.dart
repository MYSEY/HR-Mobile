import 'package:app/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/services/api_service.dart';
import 'package:app/models/training.dart';

final trainingProvider =
    StateNotifierProvider<EmployeeNotifier, List<Training>>((ref) {
  return EmployeeNotifier(ref);
});

class EmployeeNotifier extends StateNotifier<List<Training>> {
  EmployeeNotifier(this.ref) : super([]);
  final Ref ref;

  Future<void> fetchTrainings() async {
    try {
      final response = await ref.read(authProvider).getTrainings();
      final responseData = response.data;

      // Check if 'datas' key exists, is non-null, and is of type List
      if (responseData != null && responseData['datas'] is List) {
        final datas = responseData['datas'];
        state = (datas as List).map((e) => Training.fromJson(e)).toList();
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
