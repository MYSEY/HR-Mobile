import 'package:app/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/services/api_service.dart';
import 'package:app/models/motor_rantel_detail.dart';

final motorRantelDetailProvider =
    StateNotifierProvider<MotorRantelNotifier, List<MotorRentalDetail>>((ref) {
  return MotorRantelNotifier(ref);
});

class MotorRantelNotifier extends StateNotifier<List<MotorRentalDetail>> {
  MotorRantelNotifier(this.ref) : super([]);
  final Ref ref;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> fetchMotorRantelDetails() async {
    try {
      // Call the API using the AuthProvider
      final response = await ref.read(authProvider).getMotorRantelDetails();

      final responseData = response.data;
      if (responseData != null && responseData is Map<String, dynamic>) {
        final datas = responseData['datas'];
        print("datas $datas");
        if (datas is List) {
          state = datas.map((e) => MotorRentalDetail.fromJson(e)).toList();
        } else {
          print("Error: 'datas' is not a list.");
        }
      } else {
        print("Failed to get payment history or response is invalid.");
      }
    } catch (e, stackTrace) {
      print("An error occurred while fetching motor rental details: $e");
      print(stackTrace);
    }
  }
}
