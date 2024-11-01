import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class MyOrdersPage extends StatefulWidget {
  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GetStorage _storage = GetStorage();


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Initialize storage if it's empty
    if (_storage.read('pendingOrders') == null) {
      _storage.write('pendingOrders', []);
    }
  }

List<Map<String, dynamic>> getPendingOrders() {
  var orders = _storage.read('pendingOrder');
  if (orders is! List) {
    orders = []; // Ensure it is a list
  }
  return List<Map<String, dynamic>>.from(orders);
}





  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Pending'),
            Tab(text: 'Delivered'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          OrdersList(status: 'PENDING', orders: getPendingOrders()),
          OrdersList(status: 'DELIVERED', orders: [
            {'id': 1514, 'tracking': 'IK987362341', 'quantity': 2, 'subtotal': 110, 'date': '13/05/2021'},
            {'id': 1679, 'tracking': 'IK3873218890', 'quantity': 3, 'subtotal': 450, 'date': '12/05/2021'},
            {'id': 1671, 'tracking': 'IK237368881', 'quantity': 3, 'subtotal': 400, 'date': '10/05/2021'},
          ]),
          OrdersList(status: 'CANCELLED', orders: [
            {'id': 1829, 'tracking': 'IK287368831', 'quantity': 2, 'subtotal': 210, 'date': '10/05/2021'},
            {'id': 1824, 'tracking': 'IK2882918812', 'quantity': 3, 'subtotal': 120, 'date': '10/05/2021'},
          ]),
        ],
      ),

    );
  }
}

class OrdersList extends StatelessWidget {
  final String status;
  final List<Map<String, dynamic>> orders;

  OrdersList({required this.status, required this.orders});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: EdgeInsets.all(8.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order #${order['id']}', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Tracking number: ${order['tracking']}'),
                Text('Quantity: ${order['quantity']}'),
                Text('Subtotal: \$${order['subtotal']}'),
                Text('Date: ${order['date']}'),
                SizedBox(height: 8.0),
                Text(status, style: TextStyle(color: statusColor(status), fontWeight: FontWeight.bold)),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Details'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color statusColor(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange;
      case 'DELIVERED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
