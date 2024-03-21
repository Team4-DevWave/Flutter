import 'dart:convert';
import 'package:http/http.dart' as http;

void changePasswordFunction(
    {required String currentPassword, required String newPassword}) async {
  Map<String, String> body = {
    'current_password': currentPassword,
    'new_password': newPassword,
  };

  String bodyEncoded = jsonEncode(body);

  http.Response response = await http.post(
    Uri.parse("http://10.0.2.2:3001/api/change-password"),
    headers: {
      'Content-Type': 'application/json',
    },
    body: bodyEncoded,
  );

  final responseDecoded = jsonDecode(response.body);
  if(response.statusCode == 200){
    print(responseDecoded['message']);
  }
  else{
    print(responseDecoded['error']);
  }
}
