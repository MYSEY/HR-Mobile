import 'package:app/models/motor_rantel.dart';
import 'package:app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/services/api_service.dart';

final motorRantelProvider =
    StateNotifierProvider<motorNotifier, motorRantelState>((ref) {
  return motorNotifier(ref);
});

class motorNotifier extends StateNotifier<motorRantelState> {
  motorNotifier(this.ref) : super(motorRantelState());
  final Ref ref;

  get context => null;

  Future<void> fetchMotorRantels() async {
    final response = await ref.read(authProvider).getMotorRantel();

    // Extract the 'data' field from the response
    final responseData = response.data;
    // Check if responseData is valid
    if (responseData != null && responseData is Map<String, dynamic>) {
      // Parse MotorRentalDetail
      MotorRentalDetail motorRentalDetail =
          MotorRentalDetail.fromJson(responseData['detail']);
      MotorRental motorRental = MotorRental.fromJson(responseData['datas']);

      state = motorRantelState(
        motorRentalDetail: motorRentalDetail,
        motorRental: motorRental,
      );
    } else {
      print("Failed to get response is invalid.");
    }
  }
}
