import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/auth_provider.dart';

// final authProvider = Provider((ref) => AuthProvider());

class LoginPage extends ConsumerStatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey =
      GlobalKey<FormState>(); // Add a GlobalKey for form validation

  String? _usernameError;
  String? _passwordError;
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _login() async {
    final success = await ref
        .read(authNotifierProvider.notifier)
        .login(_usernameController.text, _passwordController.text, context);
    if (success == true) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue,
      // backgroundColor: Colors.red,
      backgroundColor: Color(0xFF006D77),
      body: Center(
        child: Form(
          key: _formKey,
          // padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Stack for the icon and background circles
              Stack(
                alignment: Alignment.center,
                children: [
                  // Outer colorful dots
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
                'Welcome',
                style: TextStyle(
                  fontSize: 28,
                  // color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Hello there, sign in to continue',
                style: TextStyle(
                  fontSize: 16,
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
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Employee ID',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          errorText:
                              _usernameError, // Display error message if present
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            setState(() {
                              _usernameError = 'Employee id is required';
                            });
                            return _usernameError;
                          }
                          setState(() {
                            _usernameError =
                                null; // Reset error message if valid
                          });
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                          errorText:
                              _passwordError, // Display error message if present
                        ),
                        obscureText: _obscureText,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            setState(() {
                              _passwordError = 'Password is required';
                            });
                            return _passwordError;
                          }
                          setState(() {
                            _passwordError =
                                null; // Reset error message if valid
                          });
                          return null;
                        },
                      ),
                      // SizedBox(height: 10),
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: TextButton(
                      //     onPressed: () {},
                      //     child: Text('Forgot your password?'),
                      //   ),
                      // ),
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
                    _login();
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
