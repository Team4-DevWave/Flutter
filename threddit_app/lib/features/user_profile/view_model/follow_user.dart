import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:fpdart/fpdart.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';

FutureEither<bool> followUser(String userName) async{
  String local = Platform.isAndroid ? '10.0.2.2' : 'localhost';

final token = await getToken();
final  url = "http://$local:8000/api/v1/users/me/friend/$userName";
final headers = {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          };
           try{
    final response = await http.post(Uri.parse(url), headers: headers);
    if(response.statusCode == 200)
    {
      return right(true);
    } 
    else if(response.statusCode == 400){
      return left(Failure("user already followed"));
    }
    else{
      return left(Failure("Can't find user"));
    }
  }
  catch(e){
    if (e is SocketException || e is TimeoutException || e is HttpException) {
        return left(Failure('Check your internet connection...'));
      } else {
        return left(Failure(e.toString()));
      }
  }
}


FutureEither<bool> unfollowUser(String userName) async{
  String local = Platform.isAndroid ? '10.0.2.2' : 'localhost';

final token = await getToken();
final  url = "http://$local:8000/api/v1/users/me/friend/$userName";
final headers = {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          };
           try{
    final response = await http.delete(Uri.parse(url), headers: headers);
    if(response.statusCode == 204)
    {
      return right(true);
    }
    else{
      return left(Failure("Can't unfollow user, please try again later"));
    }
  }
  catch(e){
    if (e is SocketException || e is TimeoutException || e is HttpException) {
        return left(Failure('Check your internet connection...'));
      } else {
        return left(Failure(e.toString()));
      }
  }
}