import 'dart:convert';
import 'dart:io';

import 'package:app/widgets/CommonUtils/common_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:path_provider/path_provider.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:9876/api'));
  // final Dio _dio = Dio(BaseOptions(baseUrl: 'http://192.168.101.19:9876/api'));

  final username = 'user';
  final password = 'pass';

  Future<Response> login(String user, String pass) async {
    try {
      // Create the data object (same as the -d flag in curl)
      var data = {
        "number_employee": user,
        "password": pass,
      };
      // Make the POST request
      final response = await _dio.post(
        '/auth/login',
        data: data,
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } on DioException catch (dioError) {
      throw dioError;
    } catch (e) {
      throw Exception('Failed to load employees: $e');
    }
  }

  Future<Response> confirmLogin(
      employeeId, String new_passwrod, String confirm_password) async {
    try {
      // Create the data object (same as the -d flag in curl)
      var data = {
        "employee_id": employeeId,
        "new_password": new_passwrod,
        "confirm_password": confirm_password,
      };
      // Make the POST request
      final response = await _dio.post(
        '/auth/confirm',
        data: data,
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } on DioException catch (dioError) {
      throw dioError;
    } catch (e) {
      throw Exception('Failed to load employees: $e');
    }
  }

  Future<Response> changePassword(
      String newPassword, String confirmPassword) async {
    // Encode credentials for Basic Authentication
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var data = {
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
    };
    try {
      return await _dio.post(
        '/employees/change/password',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
            "Content-Type": "application/json",
          },
        ),
      );
    } catch (e) {
      throw Exception('Error update change password: $e');
    }
  }

  Future<Response> getEmployees() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      return await _dio.get(
        '/employees/view',
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to load employees: $e');
    }
  }

  Future<Response> getEmployeeId(String employeeId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      return await _dio.get(
        '/employees/view-by-id/$employeeId',
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to load employees: $e');
    }
  }

  Future<Response> updateEmployee(
      String manpowerId, Map<String, dynamic> data) async {
    final credentials = base64Encode(utf8.encode('$username:$password'));
    try {
      return await _dio.patch(
        '/employees/$manpowerId',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Basic $credentials',
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to load employees: $e');
    }
  }

  Future<Response> getChildrenInfoId(String employeeId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      return await _dio.get(
        '/children/infor/view-by-id/$employeeId',
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to load employees: $e');
    }
  }

  Future<Response> getEducationId(String employeeId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      return await _dio.get(
        '/education/view-by-id/$employeeId',
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to load employees: $e');
    }
  }

  Future<Response> getExperienceId(String employeeId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      return await _dio.get(
        '/experience/view-by-id/$employeeId',
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to load employees: $e');
    }
  }

  Future<Response> getLeaveRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      return await _dio.get(
        '/leave/request/view',
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to load leave request: $e');
    }
  }

  Future<Response> getLeaveOnbehalfs() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      return await _dio.get(
        '/leave/request/onbehalf',
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to load leave request: $e');
    }
  }

  Future<Response> getLeaveApproves() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      return await _dio.get(
        '/leave/request/view-by-id',
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to load leave approve: $e');
    }
  }

  Future<Response> getEmployeeLeaves() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      return await _dio.get(
        '/leave/request/employees',
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to load leave request: $e');
    }
  }

  Future<Response> createRequestLeave(
      Map<String, dynamic> data, BuildContext context) async {
    // Encode credentials for Basic Authentication
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      return await _dio.post(
        '/leave/request/create',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
            "Content-Type": "application/json",
          },
        ),
      );
    } on DioException catch (dioError) {
      final messageEroor = dioError.response?.data;
      CommonUtils.showTopSnackbar(
          context, '${messageEroor["error"]}', Colors.red);

      throw Exception('Error creating leave request: $dioError');
    }
  }

  Future<Response> createOnbehalfRequest(
      Map<String, dynamic> data, BuildContext context) async {
    // Encode credentials for Basic Authentication
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      return await _dio.post(
        '/leave/request/onbehlf',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
            "Content-Type": "application/json",
          },
        ),
      );
    } on DioException catch (dioError) {
      final messageEroor = dioError.response?.data;
      CommonUtils.showTopSnackbar(
          context, '${messageEroor["error"]}', Colors.red);

      throw Exception('Error creating leave request: $dioError');
    }
  }

  Future<Response> updateRequestLeave(
      Map<String, dynamic> data, BuildContext context) async {
    // Encode credentials for Basic Authentication
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      return await _dio.put(
        '/leave/request/update',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
            "Content-Type": "application/json",
          },
        ),
      );
    } on DioException catch (dioError) {
      final messageEroor = dioError.response?.data;
      // ignore: use_build_context_synchronously
      CommonUtils.showTopSnackbar(
          context, '${messageEroor["error"]}', Colors.red);

      throw Exception('Error creating leave request: $dioError');
    }
  }

  Future<Response> deleteRequestLeave(Map<String, dynamic> data) async {
    // Encode credentials for Basic Authentication
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      return await _dio.delete(
        '/leave/request/delete',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
            "Content-Type": "application/json",
          },
        ),
      );
    } catch (e) {
      throw Exception('Error delete leave request: $e');
    }
  }

  Future<Response> approveLeave(Map<String, dynamic> data) async {
    // Encode credentials for Basic Authentication
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      return await _dio.post(
        '/leave/request/approve',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
            "Content-Type": "application/json",
          },
        ),
      );
    } catch (e) {
      throw Exception('Error approve leave request: $e');
    }
  }

  Future<Response> rejectLeave(Map<String, dynamic> data) async {
    // Encode credentials for Basic Authentication
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      return await _dio.post(
        '/leave/request/reject',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
            "Content-Type": "application/json",
          },
        ),
      );
    } catch (e) {
      throw Exception('Error approve leave request: $e');
    }
  }

  Future<Response> getLeaveTypes() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      return await _dio.get(
        '/leave/type/view',
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to load leave type: $e');
    }
  }

  Future<Response> getTrainings() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      return await _dio.get(
        '/trainings/view',
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to load training: $e');
    }
  }

  Future<Response> getPayrolls() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      return await _dio.get(
        '/payrolls/view',
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to load payrolls: $e');
    }
  }

  Future<Response> getPayroll() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      return await _dio.get(
        '/payrolls/view-by-id',
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to load payroll: $e');
    }
  }

  Future<Response> getLeaveAllocation() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      return await _dio.get(
        '/leave/allocation/view',
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to load leave allocation: $e');
    }
  }

  Future<Response> getPublicHolidays() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      return await _dio.get(
        '/public/holidays/view',
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to load public holiday: $e');
    }
  }

  Future<Response> getSearchHolidays(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      return await _dio.get(
        '/public/holidays/search',
        queryParameters: data,
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to load public holiday: $e');
    }
  }

  Future<Response> getMotorRantel() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      return await _dio.get(
        '/motor/rentals/view-by-id',
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to load motor rantel detail: $e');
    }
  }

  Future<Response> getMotorRantelDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      return await _dio.get(
        '/motor/rentals/details/view-by-id',
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to load motor rantel detail: $e');
    }
  }

  // Future<void> downloadEmployeesCsv(BuildContext context) async {
  //   final credentials = base64Encode(utf8.encode('$username:$password'));
  //   try {
  //     final response = await _dio.get(
  //       '/employees/csv',
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Basic $credentials',
  //         },
  //         responseType: ResponseType.bytes,
  //       ),
  //     );

  //     // Get the downloads directory
  //     final directory = await getExternalStorageDirectory();
  //     final downloadsDirectory =
  //         Directory('${directory!.parent.parent.parent.parent.path}/Download');
  //     final filePath = '${downloadsDirectory.path}/employees.csv';

  //     // Save the file
  //     final file = File(filePath);
  //     await file.writeAsBytes(response.data);

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('File saved at $filePath')),
  //     );

  //     // Open the file
  //     OpenFile.open(filePath);
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to download employees CSV: $e')),
  //     );
  //   }
  // }
}
