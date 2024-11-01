import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/controllers/cart_controller.dart';
import 'package:project1/controllers/product_controller.dart';
import 'package:project1/models/product_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project1/ui/cart_page.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());
  final CartController cartController = Get.put(CartController());

  final Product product;

  ProductDetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    // Fetch similar products
    List<Product> similarProducts =
        controller.getSimilarProducts(product.category);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {},
          ),
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Get.to(()=>CartPage());
                },
              ),
              Positioned(
                right: 4,
                top: 4,
                child: Obx(() {
                  return cartController.totalProductCount.value > 0
                      ? Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${cartController.totalProductCount}',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        )
                      : SizedBox.shrink();
                }),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  product.thumbnail,
                  height: 200,
                  width: 200,
                ),
              ),
              SizedBox(height: 16),
              Text(
                product.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '\$${product.price}',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(height: 16),
              Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                product.description,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Reviews',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    product.rating.toString(),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.star, color: Colors.yellow),
                ],
              ),
              SizedBox(height: 16),
              // Display list of reviews
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: product.reviews?.length ?? 0,
                itemBuilder: (context, index) {
                  final review = product.reviews![index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage("assets/images/user.png"),
                    ),
                    title: Text(review.reviewerName),
                    subtitle: Text(review.comment),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        5,
                        (starIndex) => Icon(
                          starIndex < review.rating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.yellow,
                          size: 20,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              Text(
                'Similar Products',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: similarProducts.length,
                  itemBuilder: (context, index) {
                    final similarProduct = similarProducts[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(() =>
                                  ProductDetailPage(product: similarProduct));
                            },
                            child: Image.network(
                              similarProduct.thumbnail,
                              height: 60,
                              width: 60,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('\$${similarProduct.price}'),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      }),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), 
          topRight: Radius.circular(30), 
        ),
        border: Border(
          top: BorderSide(
              color: Colors.white, width: 2),
        ),
      ),
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Map<String, dynamic> newItem = {
                  'id': product.id,
                  'title': product.title,
                  'price': product.price,
                  'thumbnail':
                      product.thumbnail,
                  'quantity': 1,
                };
                cartController.addItemToCart(newItem);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Add to Cart',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
