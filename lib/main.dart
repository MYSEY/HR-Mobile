import 'package:app/screens/login_page.dart';
import 'package:app/screens/motor_rentals/motor_rental.dart';
import 'package:app/screens/motor_rentals/payment_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/screens/employee_list_page.dart';
import 'package:app/screens/home_page.dart';
import 'package:app/screens/setting/setting.dart';
import 'package:app/screens/leaves/leave_list.dart';
import 'package:app/screens/trainings/training_page.dart';
import 'package:app/screens/salaries/salaries_page.dart';
import 'package:app/screens/public_holidays/public_holiday_page.dart';
import 'package:app/screens/salaries/salary_history.dart';
import 'package:app/screens/leaves/form_create_leave.dart';
import 'package:app/screens/leaves/form_edit_leave.dart';
import 'package:app/screens/employee_edit_page.dart';
import 'package:app/models/employee.dart';
import 'package:app/models/leave_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:app/screens/setting/change_password.dart';
import 'package:app/screens/setting/edit_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Perform authentication check at the start
  final isAuth = await _checkAuthentication();

  runApp(ProviderScope(
    child: MyApp(initialRoute: isAuth ? '/home' : '/login'),
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: initialRoute, // Set based on authentication check
      navigatorObservers: [AuthNavigatorObserver()], // Add the observer here
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/setting': (context) => SettingsPage(),
        '/change/password': (context) => ChangePasswordPage(),
        '/edit/profile': (context) => EditProfilePage(),
        '/public/holiday': (context) => PublicHolidaysPage(),
        '/leaves/list': (context) => LeaveRequestPage(),
        '/leaves/create': (context) => FormRequestLeavePage(),
        '/leaves/edit': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as String;
          return EditRequestLeavePage(id: args);
        },
        '/employees': (context) => EmployeeListPage(),
        // '/employee/edit': (context) {
        //   final employee =
        //       ModalRoute.of(context)!.settings.arguments as Employee;
        //   return EmployeeEditPage(employee: employee);
        // },
        '/trainings': (context) => TrainingListPage(),
        '/salaries': (context) => PayrollListPage(),
        '/salaries/history': (context) => SalaryHistoryPage(),

        '/motor/list': (context) => motorListPage(),
        '/motor/histories': (context) => MTHistoryPage(),
      },
    );
  }
}

/// Authentication check logic
Future<bool> _checkAuthentication() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('authToken');

  if (token == null) {
    return false; // No token, not authenticated
  }

  // If using JWT, decode and check expiration
  if (JwtDecoder.isExpired(token)) {
    return false; // Token expired
  }

  return true; // Token is valid
}

/// Custom NavigatorObserver to check token expiration
class AuthNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    // Check if the token is expired when navigating to a new route
    _checkTokenExpirationAndRedirect(
        route.settings.name, route.navigator?.context);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    // Check if the token is expired when popping back
    _checkTokenExpirationAndRedirect(
        previousRoute?.settings.name, route.navigator?.context);
  }

  // Method to check token expiration and redirect
  Future<void> _checkTokenExpirationAndRedirect(
      String? routeName, BuildContext? context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || JwtDecoder.isExpired(token)) {
      // If token is expired or not found, navigate to login
      if (routeName != '/login' && context != null) {
        // Only redirect if it's not already on the login screen
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/login');
        });
      }
    }
  }
}
