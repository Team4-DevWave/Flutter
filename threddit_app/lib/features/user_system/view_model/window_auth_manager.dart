import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:url_launcher/url_launcher.dart';
import 'package:window_to_front/window_to_front.dart';

const String googleClientId =
    '300534889914-cdkn710c66nf9mf2ubcj838egulnovjp.apps.googleusercontent.com';
const String authClientSecret = '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';
const String redirectUrl = 'http://localhost:';
const String googleAuthApi = 'https://accounts.google.com/o/oauth2/v2/auth';
const String googleTokenApi = 'https://oauth2.googleapis.com/token';
const String emailScope = 'https://www.googleapis.com/auth/userinfo.email';

class AuthManager {
  HttpServer? redirectServer;

  Future<oauth2.Credentials> login() async {
    await redirectServer?.close();
    redirectServer = await HttpServer.bind('localhost', 0);
    final redirectURL = redirectUrl + redirectServer!.port.toString();

    var grant = oauth2.AuthorizationCodeGrant(
      googleClientId,
      Uri.parse(googleAuthApi),
      Uri.parse(googleTokenApi),
      secret: authClientSecret,
      httpClient: JsonAcceptingHttpClient(),
    );

    var authorizationUrl =
        grant.getAuthorizationUrl(Uri.parse(redirectURL), scopes: [emailScope]);
    await launchUrl(authorizationUrl);

    var responseQueryParameters = await listen();
    var client =
        await grant.handleAuthorizationResponse(responseQueryParameters);
    return client.credentials;
  }

  Future<Map<String, String>> listen() async {
    var request = await redirectServer!.first;
    var params = request.uri.queryParameters;
    await WindowToFront.activate();

    request.response.statusCode = 200;
    request.response.headers.set('content-type', 'text/plain');
    request.response.writeln('Signed in succesfully! Please close the tab');
    await request.response.close();
    await redirectServer!.close();
    redirectServer = null;
    return params;
  }
}

class JsonAcceptingHttpClient extends http.BaseClient {
  final _httpClient = http.Client();
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Accept'] = 'application/json';
    return _httpClient.send(request);
  }
}
