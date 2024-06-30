import 'package:flutter/material.dart';
import 'package:kueku/dto/cake.dart';
import 'package:kueku/dto/order.dart';
import 'package:kueku/endpoints/kue.dart';
import 'package:kueku/screen/routes/adminscreen/catatan_screen.dart';
import 'package:kueku/screen/routes/adminscreen/complain_screen.dart';
import 'package:kueku/screen/routes/adminscreen/produk_screen.dart';
import 'package:kueku/screen/routes/adminscreen/profil_admin_screen.dart';
import 'package:kueku/service/dataservice.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0; // This is the index that shows the selected tab
  List<Kue> _products = [];
  List<Order> _orders = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _fetchOrders();
  }

  _reloadData(){
    setState(() {
      _fetchProducts();
      _fetchOrders();
    });
  }
  Future<void> _fetchOrders() async {
    try{
      final orders =  await DataService.fetchOrders();
      setState(() {
        _orders =  orders;
      });
    }catch(e){
      print(e);
    }
  }

  Future<void> _fetchProducts() async {
    try {
      final products = await DataService.fetchKue();
      setState(() {
        _products = products;
      });
    } catch (e) {
      // Handle error
      print('Failed to fetch products: $e');
    }
  }

  Future<void> _navigateToAddProduct(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProductScreen()),
    );

    if (result == true) {
      _fetchProducts();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _widgetOptions(
          BuildContext context, List<Kue> products, List<Order> order) =>
      <Widget>[
        _buildDashboard(context, products, order),
        CatatanScreen(),
        AdminProfileScreen(),
      ];

  static Widget _buildDashboard(BuildContext context, List<Kue> products, List<Order> order) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Manage Products',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          const SizedBox(height: 10),
          _buildProductList(context, products),
          const SizedBox(height: 20),
          const Text(
            'View Orders',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          const SizedBox(height: 10),
          _buildOrderList(context, order),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductScreen()),
              );
            },
            child: Text('Add Product'),
          ),
        ],
      ),
    );
  }

  static Widget _buildProductList(BuildContext context, List<Kue> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return
          _buildProductItem(
          context,
          product.namaKue,
          'Description', // Add actual description if available
          Uri.parse(product.kueImage!).toString(),
          product.harga,
        );
      },
    );
  }

  static Widget _buildProductItem(BuildContext context, String title,
      String description, String imagePath, double price) {
    return Card(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildOrderList(BuildContext context, List<Order> orders) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length, // Number of orders
      itemBuilder: (context, index) {
        var order = orders[index];
        return _buildOrderItem(
          context,
          order.user.name,
          'Order ${order.kue.namaKue}}',
        );
      },
    );
  }

  static Widget _buildOrderItem(
      BuildContext context, String title, String details) {
    return Card(
      color: Colors.white,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
        subtitle: Text(
          details,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            // Handle delete action
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 230, 251),
      appBar: _selectedIndex == 0
          ? AppBar(
              title: Text('Admin Dashboard'),
              backgroundColor: Color.fromARGB(255, 186, 143, 186),

      actions: [
        GestureDetector(
          onTap: _reloadData,
          child: Icon(Icons.refresh, size: 28),
        )
      ],
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
                      'Add Product',
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToAddProduct(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Complain cust',
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ComplaintsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          : null,
      body: _widgetOptions(context, _products, _orders).elementAt(_selectedIndex),
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

void main() {
  runApp(MaterialApp(
    home: AdminScreen(),
    routes: {
      '/produk-screen': (context) => Scaffold(
            appBar: AppBar(
              title: Text('Success'),
            ),
            body: Center(
              child: Text('Product added successfully!'),
            ),
          ),
    },
  ));
}
