import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kueku/screen/routes/adminscreen/produk_screen.dart';
import 'package:kueku/screen/routes/user/home_screen.dart';
import 'package:kueku/screen/routes/login_screen.dart';


void main() {
  runApp(MyApp());
}

bool get isDesktopOrWeb {
  return ![
    TargetPlatform.android,
    TargetPlatform.iOS,
  ].contains(defaultTargetPlatform);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Resep App',
      theme: ThemeData(
        primarySwatch: Colors.purple, // Mengubah warna tema menjadi ungu
      ),
      initialRoute: '/login', // Set rute awal ke halaman login
      routes: {
        '/login': (context) => const LoginScreen(), // Menambahkan rute ke halaman login
        '/home': (context) =>  HomeScreen(), // Menambahkan rute ke halaman home
        '/produk-screen' : (context) => AddProductScreen(),
      },
    );
  }
}
