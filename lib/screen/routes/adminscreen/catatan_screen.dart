import 'package:flutter/material.dart';
import 'package:kueku/dto/order.dart';
import 'package:kueku/service/dataservice.dart';

class CatatanScreen extends StatefulWidget {
  const CatatanScreen({Key? key}) : super(key: key);

  @override
  State<CatatanScreen> createState() => _CatatanScreenState();

  static Widget _buildOrderItem(
    BuildContext context,
    int id,
    String title,
    String details,
    VoidCallback ondelete,
  ) {
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
          onPressed: () async {
            await DataService.deleteOrder(id: id);
            ondelete();
            // Handle delete action
          },
        ),
      ),
    );
  }
}

class _CatatanScreenState extends State<CatatanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pembelian'),
        backgroundColor: const Color.fromARGB(255, 186, 143, 186),
        automaticallyImplyLeading: false,
        // Tambahkan baris ini
      ),
      backgroundColor: const Color.fromARGB(255, 244, 216, 249),
      body: FutureBuilder(
        future: DataService.fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              return const Center(
                child: Text(
                  'Belum ada riwayat pembelian.',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            List<Order>? orders = snapshot.data;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders!.length, // Number of orders
              itemBuilder: (context, index) {
                var order = orders[index];
                return CatatanScreen._buildOrderItem(
                  context,
                  order.id,
                  order.user.name,
                  'Order ${order.kue.namaKue}',
                  _reloadData
                );
              },
            );
          }
          return const Center(
            child: Text(
              'Belum ada riwayat pembelian.',
              style: TextStyle(fontSize: 18),
            ),
          );
        },
      ),
    );
  }

  _reloadData(){
    setState(() {

    });
  }
}
