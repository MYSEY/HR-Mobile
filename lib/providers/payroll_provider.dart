import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/models/payroll.dart';
import 'package:app/providers/auth_provider.dart';

final payrollProvider = StateNotifierProvider<PayrollNotifier, Payroll?>((ref) {
  return PayrollNotifier(ref);
});

class PayrollNotifier extends StateNotifier<Payroll?> {
  PayrollNotifier(this.ref) : super(null);
  final Ref ref;

  Future<void> fetchPayroll() async {
    try {
      final response = await ref.read(authProvider).getPayroll();
      final responseData = response.data;

      // Check if 'data' key exists and is non-null
      if (responseData != null && responseData['data'] != null) {
        final data = responseData['data'];
        state = Payroll.fromJson(data);
      } else {
        print('Warning: "data" field is missing or null in the API response');
        state = null;
      }
    } catch (error) {
      print('Error fetching payroll: $error');
      state = null;
    }
  }
}
