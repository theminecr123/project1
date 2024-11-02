import 'dart:convert';

import 'package:get/get.dart';
import 'package:project1/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductController extends GetxController {
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var products = <Product>[].obs;
  var allProducts = <Product>[].obs;

  int currentPage = 0;
  var selectedCategory = ''.obs;

  Future<void> fetchData({bool loadMore = false}) async {
    if (loadMore) {
      isLoadingMore(true);
    } else {
      isLoading(true);
      currentPage = 0; // Reset page if it's a fresh load
      products.clear(); // Clear existing products if not loading more
    }

    try {
      currentPage++;
      String url = 'https://dummyjson.com/products?skip=${(currentPage - 1) * 6}&limit=6';
      if (selectedCategory.value.isNotEmpty && selectedCategory.value != 'all') {
        url += '&category=${selectedCategory.value}';
      }
      
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        var newProducts = ProductModel.fromJson(result).products;
        if (loadMore) {
          products.addAll(newProducts);
        } else {
          products.assignAll(newProducts);
        }
      } else {
        print("Error fetching data!");
      }
    } catch (e) {
      print("Error while fetching data: $e");
    } finally {
      if (loadMore) {
        isLoadingMore(false);
      } else {
        isLoading(false);
      }
    }
  }



  List<Product> getSimilarProducts(String category) {
    return products.where((p) => p.category == category).toList();
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    fetchData(); // Call fetchData with the selected category
  }
}
