import 'dart:convert';

import 'package:get/get.dart';
import 'package:project1/models/product_model.dart';
import 'package:http/http.dart' as http;


class ProductController extends GetxController{
  var isLoading = false.obs;
  ProductModel? _productModel;

  fetchData() async{
    try{
      isLoading(true);
      http.Response response = await http.get(Uri.tryParse(
        'https://dummyjson.com/products')!);
      if(response.statusCode == 200){
        var result = jsonDecode(response.body);
        _productModel = ProductModel.fromJson(result);
      }else{
        print("error fetching data!");
      }

    }catch(e){
      print("error while fetching Data: $e");
    }finally{
      isLoading(false);
    }
  }
}