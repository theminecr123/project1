import 'dart:convert';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:project1/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductController extends GetxController {
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var products = <Product>[].obs;
  int currentPage = 0;
  var selectedCategory = ''.obs;
  Logger logger = Logger();
  var searchResults = <Product>[].obs;
  var isSearching = false.obs;

  Future<void> fetchData({String? category, bool loadMore = false}) async {
    if (loadMore) {
      isLoadingMore(true);
    } else {
      isLoading(true);
      currentPage = 0; // Reset page if it's a fresh load
      products.clear(); // Clear existing products if not loading more
    }

    try {
      currentPage++;
      String url;

      if (category != null && category.isNotEmpty && category != 'all') {
        url = 'https://dummyjson.com/products/category/$category?skip=${(currentPage - 1) * 6}&limit=6';
      } else {
        // Default URL to fetch all products
        url = 'https://dummyjson.com/products?skip=${(currentPage - 1) * 6}&limit=6';
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
    selectedCategory.refresh();
    fetchData(category: category);
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      isSearching(false);
      searchResults.clear();
    } else {
      isSearching(false);
      searchResults.value = products.where((product) {
        return product.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }
}
