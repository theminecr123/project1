import 'dart:convert';

import 'package:get/get.dart';
import 'package:project1/models/post_model.dart';
import 'package:http/http.dart' as http;


class PostController extends GetxController{
  var isLoading = false.obs;
  PostModel? _postModel;

  fetchData() async{
    try{
      isLoading(true);
      http.Response response = await http.get(Uri.tryParse(
        'https://dummyjson.com/posts')!);
      if(response.statusCode == 200){
        var result = jsonDecode(response.body);
        _postModel = PostModel.fromJson(result);
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