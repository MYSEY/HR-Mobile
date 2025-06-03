import 'package:app/screens/login_page.dart';
import 'package:app/screens/confirm_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
// *** block home page ***
import 'package:app/screens/home_page.dart';
// *** block settings ***
import 'package:app/screens/setting/setting.dart';
import 'package:app/screens/setting/change_password.dart';
import 'package:app/screens/setting/edit_profile.dart';
// block employees ***
import 'package:app/screens/employees/employee_list.dart';
import 'package:app/screens/employees/employee_detail.dart';
import 'package:app/screens/employees/children_information.dart';
import 'package:app/screens/employees/education_employee.dart';
import 'package:app/screens/employees/experience_employee.dart';

// block leave admins ***
import 'package:app/screens/leaves/leave_admins/leave_admin_list.dart';
// block leave requests ***
import 'package:app/models/leave_request.dart';
import 'package:app/screens/leaves/leave_employees/leave_list.dart';
import 'package:app/screens/leaves/leave_employees/form_create_leave.dart';
import 'package:app/screens/leaves/leave_employees/form_edit_leave.dart';

// block leave on behalfs ***
import 'package:app/screens/leaves/leave_onbehalfs/leave_onbehalf.dart';
import 'package:app/screens/leaves/leave_onbehalfs/form_create_leave.dart';
import 'package:app/screens/leaves/leave_onbehalfs/form_edit_leave.dart';

// motor rentals ***
import 'package:app/screens/motor_rentals/motor_rental.dart';
import 'package:app/screens/motor_rentals/payment_history.dart';
// motor C&B ***
import 'package:app/screens/salaries/salaries_page.dart';
import 'package:app/screens/salaries/salary_history.dart';
// motor trainings ***
import 'package:app/screens/trainings/training_page.dart';
// motor public holidays ***
import 'package:app/screens/public_holidays/public_holiday_page.dart';

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
        '/confirm': (context) {
          final employeeId =
              ModalRoute.of(context)?.settings.arguments as int? ?? 0;
          return ConfirmPasswordPage(employeeId: employeeId);
        },
        '/home': (context) => HomePage(),
        '/setting': (context) => SettingsPage(),
        '/change/password': (context) => ChangePasswordPage(),
        '/edit/profile': (context) => EditProfilePage(),
        '/leaves/admin': (context) => LeaveAdmintPage(),
        '/leaves/list': (context) => LeaveRequestPage(),
        '/leaves/create': (context) => FormRequestLeavePage(),
        '/leaves/edit': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments as LeaveRequest;
          return EditRequestLeavePage(leaveRequest: args);
        },
        '/leaves/onbehalf': (context) => LeaveOnbehalfPage(),
        '/leaves/onbehalf/create': (context) => FormOnbehalfLeavePage(),
        '/leaves/onbehalf/edit': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments as LeaveRequest;
          return EditOnbehalfLeavePage(leaveRequest: args);
        },
        '/employees': (context) => EmployeePage(),
        // '/employees/detail': (context) => EmployeeDetailPage(),

        '/employees/detail': (context) {
          final employeeId =
              ModalRoute.of(context)?.settings.arguments as int? ?? 0;
          return EmployeeDetailPage(employeeId: employeeId);
        },
        '/children/infor': (context) {
          final employeeId =
              ModalRoute.of(context)?.settings.arguments as int? ?? 0;
          return ChildrenInforPage(employeeId: employeeId);
        },
        '/education': (context) {
          final employeeId =
              ModalRoute.of(context)?.settings.arguments as int? ?? 0;
          return EducationPage(employeeId: employeeId);
        },
        '/experience': (context) {
          final employeeId =
              ModalRoute.of(context)?.settings.arguments as int? ?? 0;
          return ExperiencePage(employeeId: employeeId);
        },
        '/trainings': (context) => TrainingListPage(),
        '/salaries': (context) => PayrollListPage(),
        '/salaries/history': (context) => SalaryHistoryPage(),
        '/motor/list': (context) => motorListPage(),
        '/motor/histories': (context) => MTHistoryPage(),
        '/public/holiday': (context) => PublicHolidaysPage(),
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
