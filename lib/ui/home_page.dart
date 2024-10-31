import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:project1/controllers/product_controller.dart';
import 'package:project1/models/product_model.dart';
import 'package:project1/ui/detailproduct_page.dart';
import 'package:project1/controllers/cart_controller.dart';

class HomePage extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());
  final ScrollController _scrollController = ScrollController();
  final CartController cartController = Get.put(CartController());

  HomePage() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
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
                  Text("Gemstore",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                    _buildCategoryButton("All","assets/images/all.svg", true),
                    _buildCategoryButton("Beauty","assets/images/beauty.svg", false),
                    _buildCategoryButton("Fragrances","assets/images/fragrances.svg", false),
                    _buildCategoryButton("Furniture","assets/images/furniture.svg", false),
                    _buildCategoryButton("Groceries","assets/images/groceries.svg", false),

  

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
                  Text("Featured Products",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(onPressed: () {}, child: Text("Show all")),
                ],
              ),
              SizedBox(height: 12),

              // Product Grid with Lazy Loading
              // Product Grid with Lazy Loading
              Expanded(
                child: Obx(() {
                  if (productController.isLoading.value &&
                      productController.products.isEmpty) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: Colors.grey,
                    ));
                  } else if (productController.products.isEmpty) {
                    return Center(child: Text("No products found"));
                  } else {
                    return Stack(
                      children: [
                        // Product Grid
                        GridView.builder(
                          controller: _scrollController,
                          itemCount: productController.products.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.7,
                          ),
                          itemBuilder: (context, index) {
                            final product = productController.products[index];
                            return _buildProductCard(product);
                          },
                        ),
                        // Loading Indicator
                        if (productController.isLoadingMore.value)
                          Positioned(
                            bottom:
                                16.0, // Adjust as needed for spacing from the bottom
                            left: 0,
                            right: 0,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                      ],
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
      
    );
  }

  // Helper method to create category buttons
  Widget _buildCategoryButton(String category, String svgIconPath, bool isSelected) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18.0),
    child: Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Background circle
            Icon(
              Icons.circle,
              color: isSelected ? Colors.grey[400] : Colors.black.withOpacity(0),
              size: 30,
            ),
            // SVG icon overlaid on the circle
            SvgPicture.asset(
              svgIconPath,
              width: 20, 
              height: 20, 
              
            ),
          ],
        ),
        // Category text
        Text(
          category,
          style: TextStyle(color: isSelected ? Colors.black : Colors.grey),
        ),
      ],
    ),
  );
}



  // Helper method to create product cards
  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProductDetailPage(product: product));
      },
      child: Container(
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
                  Text(product.title,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text("\$${product.price.toStringAsFixed(2)}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}