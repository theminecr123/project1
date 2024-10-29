import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/controllers/product_controller.dart';

class HomePage extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());
  final ScrollController _scrollController = ScrollController();

  HomePage() {
    // Listen for scroll events to load more products when reaching the end
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
        if (!productController.isLoadingMore.value) {
          productController.fetchData(loadMore: true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Fetch initial data
    productController.fetchData();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.menu, size: 28),
                  Text("Gemstore", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Icon(Icons.notifications_outlined, size: 28),
                ],
              ),
              SizedBox(height: 16),

              // Category Selection
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCategoryButton("Women", true),
                    _buildCategoryButton("Men", false),
                    _buildCategoryButton("Accessories", false),
                    _buildCategoryButton("Beauty", false),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Featured Banner
              Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage('assets/images/banner.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Autumn Collection 2022",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Featured Products Section Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Featured Products", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(onPressed: () {}, child: Text("Show all")),
                ],
              ),
              SizedBox(height: 12),

              // Product Grid with Lazy Loading
              Expanded(
                child: Obx(() {
                  if (productController.isLoading.value && productController.products.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  } else if (productController.products.isEmpty) {
                    return Center(child: Text("No products found"));
                  } else {
                    return GridView.builder(
                      controller: _scrollController,
                      itemCount: productController.products.length + (productController.isLoadingMore.value ? 1 : 0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        if (index < productController.products.length) {
                          final product = productController.products[index];
                          return _buildProductCard(product);
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
        ],
      ),
    );
  }

  // Helper method to create category buttons
  Widget _buildCategoryButton(String category, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Icon(Icons.circle, color: isSelected ? Colors.black : Colors.grey, size: 28),
          Text(
            category,
            style: TextStyle(color: isSelected ? Colors.black : Colors.grey),
          ),
        ],
      ),
    );
  }

  // Helper method to create product cards
  Widget _buildProductCard(product) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                product.thumbnail,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text("\$${product.price.toStringAsFixed(2)}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
