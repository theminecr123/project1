import 'dart:convert';

import 'package:get/get.dart';
import 'package:project1/models/cart_model.dart';
import 'package:http/http.dart' as http;


class CartController extends GetxController{
  var isLoading = false.obs;
  CartModel? _cartModel;

  fetchData() async{
    try{
      isLoading(true);
      http.Response response = await http.get(Uri.tryParse(
        'https://dummyjson.com/carts')!);
      if(response.statusCode == 200){
        var result = jsonDecode(response.body);
        _cartModel = CartModel.fromJson(result);
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