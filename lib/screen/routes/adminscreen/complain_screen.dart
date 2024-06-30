import 'package:flutter/material.dart';

// Dummy data representing complaints
final List<Complaint> complaints = [
  Complaint(
    id: '1',
    title: 'Product not received',
    description: 'I ordered a product but it has not been delivered yet.',
    status: 'Pending',
  ),
  Complaint(
    id: '2',
    title: 'Damaged product received',
    description: 'The product I received is damaged.',
    status: 'In Progress',
  ),
  Complaint(
    id: '3',
    title: 'Wrong item delivered',
    description: 'I received a different item than what I ordered.',
    status: 'Resolved',
  ),
];

class Complaint {
  final String id;
  final String title;
  final String description;
  final String status;

  Complaint({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
  });
}

class ComplaintsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Complaints'),
        backgroundColor: Color.fromARGB(255, 186, 143, 186),
      ),
      body: ListView.builder(
        itemCount: complaints.length,
        itemBuilder: (context, index) {
          final complaint = complaints[index];
          return ListTile(
            title: Text(complaint.title),
            subtitle: Text(complaint.description),
            trailing: Text(complaint.status),
            onTap: () {
              // Navigate to complaint details screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ComplaintDetailsScreen(complaint: complaint),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ComplaintDetailsScreen extends StatelessWidget {
  final Complaint complaint;

  ComplaintDetailsScreen({required this.complaint});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint Details'),
        backgroundColor: Color.fromARGB(255, 186, 143, 186),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Title: ${complaint.title}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Description: ${complaint.description}'),
            SizedBox(height: 10),
            Text('Status: ${complaint.status}'),
          ],
        ),
      ),               
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ComplaintsScreen(),
  ));
}
  