import 'dart:convert';

import 'package:get/get.dart';
import 'package:project1/models/product_model.dart';
import 'package:http/http.dart' as http;


class ProductController extends GetxController {
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var products = <Product>[].obs;
  int currentPage = 0;

  Future<void> fetchData({bool loadMore = false}) async {
    if (loadMore) isLoadingMore(true);
    else isLoading(true);

    try {
      currentPage++;
      http.Response response = await http.get(Uri.tryParse(
        'https://dummyjson.com/products?skip=${(currentPage - 1) * 6}&limit=6')!);
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
      if (loadMore) isLoadingMore(false);
      else isLoading(false);
    }
  }
}
