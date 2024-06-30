import 'package:flutter/material.dart';
import 'package:kueku/dto/order.dart';
import 'package:kueku/service/dataservice.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();

  static Widget _buildOrderItem(
    BuildContext context,
    int orderId,
    String title,
    String details,
    VoidCallback onDelete,
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
            await DataService.deleteOrder(id: orderId);
            onDelete();
          },
        ),
      ),
    );
  }
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<Order>> _ordersFuture;

  void _reloadOrders() {
    setState(() {
      _ordersFuture = DataService.fetchOrders();
    });
  }

  @override
  void initState() {
    _ordersFuture = DataService.fetchOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Pemesanan'),
        backgroundColor: Color.fromARGB(255, 186, 143, 186),
        automaticallyImplyLeading: false, // Tambahkan baris ini
      ),
      backgroundColor: Color.fromARGB(255, 244, 216, 249),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<Order>? orders = snapshot.data;

            if(snapshot.data == null){
              return Center(child: Text('Belum ada riwayat pemesanan.'));
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders!.length, // Number of orders
              itemBuilder: (context, index) {
                var order = orders[index];
                return HistoryScreen._buildOrderItem(
                  context,
                  order.id,
                  order.kue.namaKue,
                  "Order pada ${order.createdAt}",
                  _reloadOrders
                );
              },
            );
          }
          return Center(
            child: Text(
              'Belum ada riwayat pemesanan.',
              style: TextStyle(fontSize: 18),
            ),
          );
        },
      ),
    );
  }
}
