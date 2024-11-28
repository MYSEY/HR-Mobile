import 'dart:convert';

import 'package:app/screens/home_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authProvider = Provider<ApiService>((ref) => ApiService());

final authStateProvider = StateProvider<bool>((ref) => false);

final authNotifierProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  final apiService = ref.watch(authProvider);
  return AuthNotifier(apiService);
});

class AuthNotifier extends StateNotifier<bool> {
  final ApiService apiService;

  AuthNotifier(this.apiService) : super(false);

  Future<bool> login(String user, String pass, BuildContext context) async {
    try {
      final response = await apiService.login(user, pass);
      final token = response.data['accessToken'];
      final role = response.data['role'];
      final employee = response.data['user'];
      // print("role $role");
      if (token != null && token.isNotEmpty) {
        // Save credentials and token in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('employeeid', user);
        await prefs.setString('password', pass);
        await prefs.setString('token', token);

        String roleJson =
            jsonEncode(role); // Convert the role object to JSON string
        await prefs.setString('role', roleJson);
        String employeeJson = jsonEncode(employee);
        await prefs.setString('employee', employeeJson);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login successfully.'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );

        // prefs.setString('role', role);
        state = true;
        return true;
      }

      // Return false if token is null or empty
      return false;
    } on DioException catch (dioError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Wrong employee ID or password.'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      // Handle Dio-specific errors
      String errorMessage;

      // Check if the response data is a map
      if (dioError.response?.data is Map<String, dynamic>) {
        errorMessage = dioError.response?.data['detail'] ?? 'An error occurred';
      } else {
        errorMessage = 'An error occurred';
      }

      // CommonUtils.showTopSnackbar(context, errorMessage, Colors.red);
      return false;
    } catch (e) {
      // Handle any other errors
      final errorMessage = 'Failed to login: $e';
      // CommonUtils.showTopSnackbar(context, errorMessage, Colors.red);
      return false;
    }
  }

  Future<bool> changePassword(
      String newPassword, String confirmPassword, BuildContext context) async {
    try {
      final response =
          await apiService.changePassword(newPassword, confirmPassword);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle state update if necessary
        // Navigate on success
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password updated successfully.'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacementNamed(context, '/home');
        }
        return true;
      } else {
        // Show error for non-200/201 responses
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update password.'),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.red,
            ),
          );
        }
        return false;
      }
    } catch (e) {
      // Handle and display errors
      print('Error updating password: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating password: ${e.toString()}'),
          ),
        );
      }
      return false;
    }
  }
}
