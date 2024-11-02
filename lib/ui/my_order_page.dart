import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project1/ui/detail_order_page.dart';
import 'package:intl/intl.dart';

class MyOrdersPage extends StatefulWidget {
  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage>
    with SingleTickerProviderStateMixin {
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
          indicator: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          tabs: [
            Tab(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text('Pending'),
            )),
            Tab(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text('Delivered'),
            )),
            Tab(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text('Cancelled'),
            )),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          OrdersList(status: 'PENDING', orders: getPendingOrders()),
          OrdersList(status: 'DELIVERED', orders: [
            {
              'id': 1514,
              'tracking': 'IK987362341',
              'quantity': 2,
              'subtotal': 110,
              'date': ''
            },
            {
              'id': 1679,
              'tracking': 'IK3873218890',
              'quantity': 3,
              'subtotal': 450,
              'date': ''
            },
            {
              'id': 1671,
              'tracking': 'IK237368881',
              'quantity': 3,
              'subtotal': 400,
              'date': ''
            },
          ]),
          OrdersList(status: 'CANCELLED', orders: [
            {
              'id': 1829,
              'tracking': 'IK287368831',
              'quantity': 2,
              'subtotal': 210,
              'date': ''
            },
            {
              'id': 1824,
              'tracking': 'IK2882918812',
              'quantity': 3,
              'subtotal': 120,
              'date': ''
            },
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

        // Safely parse date
        DateTime? orderDate;
        try {
          String? dateString = order['date'] as String?;
          if (dateString != null && dateString.isNotEmpty) {
            orderDate = DateTime.parse(dateString);
          }
        } catch (e) {
          orderDate = null;
        }

        // Format the date safely
        String formattedDate = orderDate != null
            ? DateFormat('dd/MM/yyyy').format(orderDate)
            : 'N/A';

        // Safely retrieve order values
        final orderId = order['id'] ?? 'N/A';
        final quantity = order['countProduct'] ?? 0;
        final subtotal = (order['total'] ?? 0.0).toStringAsFixed(2);

        return Card(
          margin: EdgeInsets.all(8.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order #$orderId',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Quantity: $quantity'),
                Text('Subtotal: \$$subtotal'),
                Text('Date: $formattedDate'),
                SizedBox(height: 8.0),
                Text(status,
                    style: TextStyle(
                        color: statusColor(status),
                        fontWeight: FontWeight.bold)),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => OrderDetailPage(order: order));
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: Colors.black,
                          width: 1.5,
                        ),
                      ),
                    ),
                    child:
                        Text('Details', style: TextStyle(color: Colors.black)),
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
