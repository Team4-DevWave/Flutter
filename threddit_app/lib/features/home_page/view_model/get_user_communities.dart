import 'dart:convert';
import 'package:http/http.dart';

class UserCommunitiesAPI{

  final String communitiesURL = "https://c461e240-480f-4854-a607-619e661e3370.mock.pstmn.io/communities";

  ///The function returns the names of the user's communities
  Future<List<String>> getUserCommunities() async{
    Response res = await get(Uri.parse(communitiesURL));
    ///This should return a List<Community> that includes 
    ///the community name and icon but for demonstration the API returns 
    ///the name of the community only
    if(res.statusCode == 200)
    {
    Map<String, dynamic> body = jsonDecode(res.body);
      List<String>  communitiesNames = List<String>.from(body['userCommunities']);
      return communitiesNames;
    } 
    else{
      throw "Unable to retrieve communities";
    }
  }

  Future<List<String>> searchResults(String searchString) async{
    Response res = await get(Uri.parse(communitiesURL));
    ///This returns the search results that match the searchString
    if(res.statusCode == 200)
    {
      Map<String, dynamic> body = jsonDecode(res.body);
      List<String> communities = List<String>.from(body['userCommunities']);
      return communities.where((element)=> element.toLowerCase().contains(searchString.toLowerCase())).toList();
    }
    else
    {
      throw "No communities found";
    }
  }

}