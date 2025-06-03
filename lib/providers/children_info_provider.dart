import 'package:app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/services/api_service.dart';
import 'package:app/models/employee.dart';

final childreenInforProvider =
    StateNotifierProvider<childrenInforNotifier, List<ChildrenInfo>>((ref) {
  return childrenInforNotifier(ref);
});

class childrenInforNotifier extends StateNotifier<List<ChildrenInfo>> {
  childrenInforNotifier(this.ref) : super([]);
  final Ref ref;

  Future<ChildrenInfo?> fetchChildrenId(int id) async {
    try {
      final response =
          await ref.read(authProvider).getChildrenInfoId(id.toString());
      final responseData = response.data;
      if (responseData != null && responseData['datas'] is List) {
        final datas = responseData['datas'];
        state = (datas as List).map((e) => ChildrenInfo.fromJson(e)).toList();
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
