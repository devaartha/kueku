import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kueku/dto/profile.dart';
import 'package:kueku/screen/routes/login_screen.dart';
import 'package:kueku/service/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'Adi Pramana'; // Ganti dengan nama user
  String userEmail = 'AdiPramana13@gmail.com'; // Ganti dengan email user
  String userImage =
      'assets/images/profile_picture.png'; // Ganti dengan path foto profil user
FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  @override
  void initState() {
    var token =  _secureStorage.read(key: 'jwt_token');
    if(token == null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 230, 251),
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: Color.fromARGB(255, 186, 143, 186),
        automaticallyImplyLeading: false, // This removes the back button
      ),
      body: FutureBuilder(
        future: AuthService.getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if(snapshot.data == null){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            }
            Profile? profile = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CircleAvatar(
                    radius: 50,
                    // Display user's profile picture
                    backgroundImage: AssetImage(userImage),
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
                          builder: (context) => EditProfileScreen(
                            userName: userName,
                            userEmail: userEmail,
                            userImage: userImage,
                            onProfileUpdated: (name, email, image) {
                              setState(() {
                                userName = name;
                                userEmail = email;
                                userImage = image;
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: Text('Edit Profile'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      await AuthService.logout();
                      // Log out functionality
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Text('Log Out'),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: Text('Waiting...'),
          );
        },
      ),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userImage;
  final Function(String, String, String) onProfileUpdated;

  const EditProfileScreen({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.userImage,
    required this.onProfileUpdated,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late String _imagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _emailController = TextEditingController(text: widget.userEmail);
    _imagePath = widget.userImage;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    widget.onProfileUpdated(
      _nameController.text,
      _emailController.text,
      _imagePath,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
