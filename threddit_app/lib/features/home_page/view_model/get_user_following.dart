import 'dart:convert';
import 'package:http/http.dart';

class UserFollowingAPI{

  final String followingURL = "https://c461e240-480f-4854-a607-619e661e3370.mock.pstmn.io/following";

  ///The function returns the names of the user's communities
  Future<List<String>> getUserFollowing() async{
    Response res = await get(Uri.parse(followingURL));
    ///This should return a List<User> that includes 
    ///the User's name and avatar icon but for demonstration the API returns 
    ///the name of the user only
    if(res.statusCode == 200)
    {
      Map<String, dynamic> body = jsonDecode(res.body);
      List<String>  followingNames = List<String>.from(body["Followedusers"]);
      return followingNames;
    } 
    else{
      throw "Unable to retrieve following list";
    }
  }

}