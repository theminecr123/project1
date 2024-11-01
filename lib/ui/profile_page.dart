import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project1/auth/login_page.dart';
import 'package:project1/config/globals.dart';
import 'package:project1/controllers/user_controller.dart';
import 'package:project1/ui/edit_profile_page.dart';
import 'package:project1/ui/my_order_page.dart';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserController userController = Get.put(UserController());
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    userController.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final user = userController.user.value;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            globalTabController.jumpToTab(0);
          },
        ),
      ),
      body: user == null
          ? Center(child: CircularProgressIndicator(
            color: Colors.grey,
          )) // Show loading spinner while fetching data
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(user.image),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${user.firstName}  ${user.lastName}',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            user.email, 
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.settings, color: Colors.black),
                        onPressed: () {
                          Get.to(()=>ProfileSettingPage());
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      _buildListItem(Icons.shopping_bag_rounded, 'My Order', const Color.fromARGB(255, 222, 222, 222)),
                      _buildListItem(Icons.location_on, 'Address', const Color.fromARGB(255, 222, 222, 222)),
                      _buildListItem(Icons.payment, 'Payment method', const Color.fromARGB(255, 222, 222, 222)),
                      _buildListItem(Icons.card_giftcard, 'Voucher', const Color.fromARGB(255, 222, 222, 222)),
                      _buildListItem(Icons.favorite, 'My Wishlist', const Color.fromARGB(255, 222, 222, 222)),
                      _buildListItem(Icons.logout, 'Log out', Color.fromARGB(255, 233, 109, 97)),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

 Widget _buildListItem(IconData icon, String text, Color btnColor) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: btnColor,
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(text),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
        onTap: () {
          switch (text) {
            case 'Address':
              // Get.to(AddressPage());
              break;
            case 'Payment method':
              // Get.to(PaymentMethodPage());
              break;
            case 'Voucher':
              break;
            case 'My Wishlist':
              break;
            case 'My Order':
              Get.to(()=>MyOrdersPage());
              break;
            case 'Log out':
                box.remove('userToken');
                Get.offAll(() => LoginPage());
              break;
          }
        },
      ),
    ),
  );
}
}
