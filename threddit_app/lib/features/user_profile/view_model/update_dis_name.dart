import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';

FutureEither<bool> updateDisplayName(String dispName, WidgetRef ref)async{
  String local = Platform.isAndroid ? '10.0.2.2' : 'localhost';

final token = await getToken();
final  url = "http://$local:8000/api/v1/users/me/changeDisplayName";
final headers = {
            
            'Authorization': 'Bearer $token',
          };

  try{
    final response = await http.patch(Uri.parse(url), headers: headers, body: { "displayName" : dispName });

    print("ALOOOOOOOO");
    print(response.statusCode);
    if(response.statusCode == 200)
    {
      ref.read(userModelProvider.notifier).update((state) => state?.copyWith(displayName: dispName));
      print("ana el function elli bet send");
      return right(true);
    }
    else
    {
      return left(Failure("Failed to update display name"));
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