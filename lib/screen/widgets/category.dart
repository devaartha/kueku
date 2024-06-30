import 'package:flutter/material.dart';
import 'package:kueku/dto/cake.dart';
import 'package:kueku/screen/routes/user/cekout_screen.dart';

class Category extends StatelessWidget {
  final Kue kue;
  final String name;
  final String description;
  final double price;
  final String imagePath;

  const Category({
    required this.kue,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke CheckoutScreen saat kategori dipilih
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckoutScreen(
              kue: kue,
              title: name,
              imagePath: imagePath,
              price: price,
            ),
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.network(
                Uri.parse(imagePath).toString(),
                fit: BoxFit.contain,
                height: 120,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\$$price',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color.fromARGB(255, 5, 5, 5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
     ),
);
}
}
