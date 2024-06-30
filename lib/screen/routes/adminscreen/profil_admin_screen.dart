import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kueku/dto/profile.dart';
import 'package:kueku/helpers/database_helper.dart';
import 'package:kueku/screen/routes/adminscreen/login_admin_screen.dart';
import 'package:kueku/screen/routes/login_screen.dart';
import 'package:kueku/service/auth_service.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({Key? key}) : super(key: key);

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  late Future<Profile> _profileFuture;
  FlutterSecureStorage _secureStorage =  FlutterSecureStorage();
  @override
  void initState() {
    var token =   _secureStorage.read(key: 'jwt_token');
    if(token == null){
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          )
      );
    };
    _profileFuture = AuthService.getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 230, 251),
      appBar: AppBar(
        title: Text('Admin Profile'),
        backgroundColor: Color.fromARGB(255, 186, 143, 186),
        automaticallyImplyLeading: false, // This removes the back button
      ),
      body: FutureBuilder(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            Profile profile = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CircleAvatar(
                    radius: 50,
                    // Display admin's profile picture
                    backgroundImage: AssetImage('assets/images/kue1.jpg'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    profile!.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    profile!.email,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 0, 200, 255),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to edit profile screen
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(),
                        ),
                      );
                    },
                    child: Text('Edit Profile'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async{
                      await AuthService.logout();
                      // Log out functionality
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    child: Text('Log Out'),
                  ),
                ],
              ),
            );
          }),
    );
  }

  _logout() async {
    await AuthService.logout();
  }
}

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Center(
        child: Text('Edit Profile Screen'),
      ),
    );
  }
}

