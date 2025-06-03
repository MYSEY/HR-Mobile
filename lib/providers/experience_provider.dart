import 'package:app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/services/api_service.dart';
import 'package:app/models/employee.dart';

final experienceProvider =
    StateNotifierProvider<experienceNotifier, List<Experience>>((ref) {
  return experienceNotifier(ref);
});

class experienceNotifier extends StateNotifier<List<Experience>> {
  experienceNotifier(this.ref) : super([]);
  final Ref ref;

  Future<Experience?> fetchExperiece(int id) async {
    try {
      final response =
          await ref.read(authProvider).getExperienceId(id.toString());
      final responseData = response.data;
      if (responseData != null && responseData['datas'] is List) {
        final datas = responseData['datas'];
        state = (datas as List).map((e) => Experience.fromJson(e)).toList();
      } else {
        state = [];
        print(
            'Warning: "datas" field is missing, null, or not a list in the API response');
      }
    } catch (e, stackTrace) {
      debugPrint("Error fetching employee: $e");
      debugPrint("StackTrace: $stackTrace");
      return null;
    }
  }
}
