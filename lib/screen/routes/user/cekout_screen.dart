import 'package:flutter/material.dart';
import 'package:kueku/dto/cake.dart';
import 'package:kueku/screen/routes/user/home_screen.dart';
import 'package:kueku/service/dataservice.dart';


class CheckoutScreen extends StatefulWidget {
  final Kue kue;
  final String imagePath;
  final String title;
  final double price;

  const CheckoutScreen({Key? key, required this.kue, required this.imagePath, required this.title, required this.price}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    double total = _quantity * widget.price;

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                Uri.parse(widget.imagePath).toString(),
                fit: BoxFit.contain,
                height: 200,
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Price: \$${widget.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Quantity:', 
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (_quantity > 1) {
                      setState(() {
                        _quantity--;
                      });
                    }
                  },
                  icon: Icon(Icons.remove),
                ),
                Text(
                  _quantity.toString(),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _quantity++;
                    });
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Total: \$${total.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {

                DataService.createOrder(kue: widget.kue, qty:_quantity);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Order Confirmed'),
                      content: Text('Thank you! Your order has been placed.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => HomeScreen()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Complete Order'),
            ),
          ],
        ),
      ),
    );
  }
}

  