import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/auth_provider.dart';
import 'package:app/widgets/CommonUtils/common_util.dart';

class ConfirmPasswordPage extends ConsumerStatefulWidget {
  final int employeeId;
  ConfirmPasswordPage({Key? key, required this.employeeId}) : super(key: key);
  @override
  _ConfirmPasswordPageState createState() => _ConfirmPasswordPageState();
}

class _ConfirmPasswordPageState extends ConsumerState<ConfirmPasswordPage> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late int employeeId;
  String? _newPasswordError;
  String? _confirmPasswordError;
  bool _obscureText = true;
  bool _obscureTextNew = true;

  void initState() {
    super.initState();
    employeeId = widget.employeeId;
  }

  void _togglePasswordNew() {
    setState(() {
      _obscureTextNew = !_obscureTextNew;
    });
  }

  void _togglePasswordConfirm() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _confirmLogin() async {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      CommonUtils.showTopSnackbar(
          context, 'Please fill in all fields.', Colors.red);
      return;
    }

    if (newPassword != confirmPassword) {
      CommonUtils.showTopSnackbar(
          context, 'You have entered incorrect password!.', Colors.red);
      return;
    }
    // Password strength check
    final passwordRegex =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$');
    if (!passwordRegex.hasMatch(newPassword)) {
      CommonUtils.showTopSnackbar(
        context,
        'Password must be at least 8 characters and include a letter, number, and symbol.',
        Colors.red,
      );
      return;
    }
    final success = await ref.read(authNotifierProvider.notifier).confirmLogin(
          employeeId,
          newPassword,
          confirmPassword,
          context,
        );

    if (success == true) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: -10,
                    left: 20,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.greenAccent,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 20,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.pinkAccent,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 40,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.orangeAccent,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 40,
                    child: CircleAvatar(
                      radius: 6,
                      backgroundColor: Colors.blueAccent,
                    ),
                  ),
                  // Main circular background for the lock icon
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.purple.shade100,
                    child: Icon(
                      Icons.lock,
                      size: 60,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Welcome Back Text
              Text(
                'Change Password',
                style: TextStyle(
                  fontSize: 28,
                  // color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Please to set new password and confirm password!',
                style: TextStyle(
                  fontSize: 15,
                  // color: Colors.white70,
                ),
              ),
              SizedBox(height: 40),
              // Card for the form fields
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      // Phone Number Field
                      TextFormField(
                        controller: _newPasswordController,
                        decoration: InputDecoration(
                          labelText: 'New password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureTextNew
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: _togglePasswordNew,
                          ),
                          errorText:
                              _newPasswordError, // Display error message if present
                        ),
                        obscureText: _obscureTextNew,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            setState(() {
                              _newPasswordError = 'New password is required';
                            });
                            return _newPasswordError;
                          }
                          setState(() {
                            _newPasswordError =
                                null; // Reset error message if valid
                          });
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      // Password Field
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirm password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: _togglePasswordConfirm,
                          ),
                          errorText:
                              _confirmPasswordError, // Display error message if present
                        ),
                        obscureText: _obscureText,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            setState(() {
                              _confirmPasswordError =
                                  'Confirm password is required';
                            });
                            return _confirmPasswordError;
                          }
                          setState(() {
                            _confirmPasswordError =
                                null; // Reset error message if valid
                          });
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Sign in Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 233, 51, 51),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _confirmLogin();
                  }
                },
                child: Text(
                  'Sign in',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
