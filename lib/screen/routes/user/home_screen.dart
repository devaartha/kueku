import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kueku/dto/cake.dart';
import 'package:kueku/screen/routes/aboutUs_screen.dart';
import 'package:kueku/screen/routes/login_screen.dart';
import 'package:kueku/screen/routes/user/cekout_screen.dart';
import 'package:kueku/screen/routes/user/customer_service.dart';
import 'package:kueku/screen/routes/user/history_screen.dart';
import 'package:kueku/screen/routes/user/profil_screen.dart';
import 'package:kueku/screen/widgets/category.dart';
import 'package:kueku/service/dataservice.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    _checkAuth();
    super.initState();
  }

  _checkAuth() async {
    var token = await _secureStorage.read(key: 'jwt_token');
    if (token == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  static List<Widget> _widgetOptions = <Widget>[
    HomeContent(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 230, 251),
      appBar: _selectedIndex == 0
          ? AppBar(
              title: Text('User Dashboard'),
              backgroundColor: Color.fromARGB(255, 186, 143, 186),
            )
          : null,
      drawer: _selectedIndex == 0
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Text(
                      'Kue Ku',
                      style: TextStyle(color: Colors.black),
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 244, 216, 249),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Tentang Kami',
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AboutUsScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Customer Service',
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerServiceScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          : null,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DataService.fetchKue(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Daftar Kue',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 10),
                _buildCategoryList(context, snapshot.data),
              ],
            ),
          );
        }
        return Center(
          child: Text('Waiting...'),
        );
      },
    );
  }

  Widget _buildCategoryList(BuildContext context, cakes) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: cakes.length,
      itemBuilder: (context, index) {
        final cake = cakes[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckoutScreen(
                  kue: cake, // Navigasi ke CheckoutScreen saat kue dipilih
                  title: cake.namaKue,
                  imagePath: cake.kueImage ?? '',
                  price: cake.harga,
                ),
              ),
            );
          },
          child: Category(
            kue: cake,
            name: cake.namaKue,
            description: 'Stok: ${cake.stok}',
            price: cake.harga,
            imagePath: cake.kueImage ?? '',
          ),
        );
      },
    );
  }
}
