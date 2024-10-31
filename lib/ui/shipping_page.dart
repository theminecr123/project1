import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project1/controllers/product_controller.dart';
import 'package:project1/controllers/user_controller.dart';
import 'package:project1/ui/payment_page.dart';

class CheckoutStep1 extends StatefulWidget {
  @override
  _CheckoutStep1State createState() => _CheckoutStep1State();
}

class _CheckoutStep1State extends State<CheckoutStep1> {
  final ProductController controller = Get.put(ProductController());
  final UserController userController = Get.put(UserController());
  final box = GetStorage();

  RxBool copyAddress = false.obs; // Make copyAddress observable
  int selectedShippingMethod = 0;

  // Controllers for text fields
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Populate controllers with user data if available
    final user = userController.user.value;
    if (user != null) {
      firstNameController.text = user.firstName;
      lastNameController.text = user.lastName;
      countryController.text = user.address.country;
      streetController.text = user.address.address;
      cityController.text = user.address.city;
      stateController.text = user.address.state;
      zipCodeController.text = user.address.stateCode;
      phoneNumberController.text = user.phone;
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    firstNameController.dispose();
    lastNameController.dispose();
    countryController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  // Method to build text fields
  Widget _buildTextField(String label, TextEditingController controller, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller, // Set the controller
        decoration: InputDecoration(
          labelText: label + (isRequired ? ' *' : ''),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 177, 188, 197),
              width: 2.0,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 234, 228, 228),
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check out'),
        actions: [Icon(Icons.menu)],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column( // Wrap Column in Obx
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("STEP 1", style: TextStyle(color: Colors.grey)),
            Text("Shipping", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),

            // Form Fields using _buildTextField method
            if (userController.user.value != null) ...[
              _buildTextField('First name', firstNameController, isRequired: true),
              _buildTextField('Last name', lastNameController, isRequired: true),
              _buildTextField('Country', countryController, isRequired: true),
              _buildTextField('Street name', streetController, isRequired: true),
              _buildTextField('City', cityController, isRequired: true),
              _buildTextField('State / Province', stateController),
              _buildTextField('Zip-code', zipCodeController, isRequired: true),
              _buildTextField('Phone number', phoneNumberController, isRequired: true),
            ],
            
            SizedBox(height: 16),

            // Shipping Method Section
            Text("Shipping method", style: TextStyle(fontWeight: FontWeight.bold)),
            
            ListTile(
              leading: Radio(
                value: 0,
                groupValue: selectedShippingMethod,
                onChanged: (value) {
                  setState(() {
                    selectedShippingMethod = value!;
                    box.write('shipCost', 0);

                  });
                },
              ),
              title: Text("Free - Delivery to home"),
              subtitle: Text("Delivery from 5 to 7 business days"),
            ),
            ListTile(
              leading: Radio(
                value: 1,
                groupValue: selectedShippingMethod,
                onChanged: (value) {
                  setState(() {
                    selectedShippingMethod = value!;
                    box.write('shipCost', 9.99);
                  });
                },
              ),
              title: Text("\$9.99 - Delivery to home"),
              subtitle: Text("Delivery from 3 to 5 business days"),
            ),
            ListTile(
              leading: Radio(
                value: 2,
                groupValue: selectedShippingMethod,
                onChanged: (value) {
                  setState(() {
                    selectedShippingMethod = value!;
                    box.write('shipCost', 19.99);

                  });
                },
              ),
              title: Text("\$19.99 - Fast Delivery"),
              subtitle: Text("Delivery from 1 to 2 business days"),
            ),
            SizedBox(height: 16),

            // Coupon Code Section
            Text("Coupon Code", style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Have a code? Type it here...",
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("Validate"),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Billing Address Checkbox
            CheckboxListTile(
              title: Text("Copy address data from shipping"),
              value: copyAddress.value, // Use observable value
              onChanged: (value) {
                copyAddress.value = value!; // Update observable value
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),

            SizedBox(height: 16),

            // Continue to Payment Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => CheckoutStep2()); // Navigate to Payment page
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text("Continue to payment", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
