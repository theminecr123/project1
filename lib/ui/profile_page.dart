import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/config/globals.dart';
import 'package:project1/controllers/user_controller.dart';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserController userController = Get.put(UserController());

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
                        backgroundImage: NetworkImage(user.image), // Use NetworkImage if image is from a URL
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${user.firstName}  ${user.lastName}', // Use the actual name from the user
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            user.email, // Use the actual email from the user
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.settings, color: Colors.black),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      _buildListItem(Icons.location_on, 'Address', const Color.fromARGB(255, 222, 222, 222)),
                      _buildListItem(Icons.payment, 'Payment method', const Color.fromARGB(255, 222, 222, 222)),
                      _buildListItem(Icons.card_giftcard, 'Voucher', const Color.fromARGB(255, 222, 222, 222)),
                      _buildListItem(Icons.favorite, 'My Wishlist', const Color.fromARGB(255, 222, 222, 222)),
                      _buildListItem(Icons.star, 'Rate this app', const Color.fromARGB(255, 222, 222, 222)),
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
          onTap: () {},
        ),
      ),
    );
  }
}
