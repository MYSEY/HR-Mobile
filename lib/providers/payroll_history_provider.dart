import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/models/payroll.dart';
import 'package:app/providers/auth_provider.dart';

final payrollHistoryProvider =
    StateNotifierProvider<PayrollNotifier, List<Payroll>>((ref) {
  return PayrollNotifier(ref);
});

class PayrollNotifier extends StateNotifier<List<Payroll>> {
  PayrollNotifier(this.ref) : super([]);

  final Ref ref;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> fetchPayrolls() async {
    final response = await ref.read(authProvider).getPayrolls();
    final responseData = response.data;
    if (responseData != null && responseData is Map<String, dynamic>) {
      final datas = responseData['datas'];
      if (datas is List) {
        state = datas.map((e) => Payroll.fromJson(e)).toList();
      } else {
        print("Error: 'datas' is not a list.");
      }
    } else {
      print("Failed to get payroll history or response is invalid.");
    }
  }
}
