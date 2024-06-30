import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:kueku/constants/constant.dart';
import 'package:kueku/helpers/database_helper.dart';
import 'package:kueku/screen/routes/adminscreen/home_admin_screen.dart';
import 'package:kueku/screen/routes/user/home_screen.dart';
import 'package:kueku/service/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  void checkAuth() async {
    DatabaseHelper db = DatabaseHelper();

    String? token = await db.getToken();

    if (token != null) {
      final JWT jwt = JWT.verify(token!, SecretKey(Constant.JWTSecret));
      final String userRole = jwt.payload['role'];
      if (userRole == 'admin') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminScreen()),
        );
      } else {
        // Navigate to HomeScreen or do other login logic
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } else {
      // No token found, continue with login screen
      // You can optionally show a login form or perform other initialization
    }
  }

  void login() async {
    String email = emailController.text;
    String password = passwordController.text;

    String role = await AuthService.login(email: email, password: password);

    // Check if email contains 'admin', then navigate to AdminScreen
    if (role == 'admin') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminScreen()),
      );
    } else {
      // Navigate to HomeScreen or do other login logic
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.deepPurple),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: Colors.deepPurpleAccent),
                    filled: true,
                    fillColor: Colors.purple[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: passwordController,
                  style: const TextStyle(color: Colors.deepPurple),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: Colors.deepPurpleAccent),
                    filled: true,
                    fillColor: Colors.purple[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text('Login'),
                ),
                const SizedBox(height: 10.0),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Daftar',
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
