import 'dart:convert';
import 'package:http/http.dart';

class LeftDrawerAPI{

  final String drawerURL = "https://c320a7f6-e041-4f5e-871e-0081b6fb07c2.mock.pstmn.io/leftdrawer";

  Future<Map<String, List<String>>> getDrawerData() async{
    Response res = await get(Uri.parse(drawerURL));
    ///when the community class is complete
    ///This will change from List<String> to List<Community> 
    ///and the community attributes will be set with .map
    ///but now for demonstration, communities are fetched as a List<Strings> containing just their names
    if(res.statusCode == 200)
    {
      Map<String, dynamic> body = jsonDecode(res.body);
      List<String> comm = List<String>.from(body['communities']);
      List<String> foll = List<String>.from(body['following']);
      
      return{'communities': comm, 'following': foll};
    } 
    else{
      throw "Unable to retrieve communities";
    }
  }

}