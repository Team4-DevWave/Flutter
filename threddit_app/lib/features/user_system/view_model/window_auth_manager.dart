import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:url_launcher/url_launcher.dart';
import 'package:window_to_front/window_to_front.dart';

/// Client ID obtained from Google API Console.
const String googleClientId =
    '300534889914-cdkn710c66nf9mf2ubcj838egulnovjp.apps.googleusercontent.com';

/// Client secret obtained from Google API Console.
const String authClientSecret = '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';

/// Redirect URL for handling the authentication response.
const String redirectUrl = 'http://localhost:';

/// Google OAuth2 authentication endpoint.
const String googleAuthApi = 'https://accounts.google.com/o/oauth2/v2/auth';

/// Google OAuth2 token endpoint.
const String googleTokenApi = 'https://oauth2.googleapis.com/token';

/// Scope for accessing user's email information.
const String emailScope = 'https://www.googleapis.com/auth/userinfo.email';

///This class is controlling the google authentication for the desktop application
///it has the necessary function for the process.
class AuthManager {
  /// HTTP server for handling authentication redirect.
  HttpServer? redirectServer;

  /// Initiates the login process.
  ///
  /// Returns a future containing OAuth2 credentials upon successful login.
  Future<oauth2.Credentials> login() async {
    // Close any existing redirect server.
    await redirectServer?.close();

    // Start a new HTTP server to handle the redirect.
    redirectServer = await HttpServer.bind('localhost', 0);
    final redirectURL = redirectUrl + redirectServer!.port.toString();

    // Initialize OAuth2 grant with client ID, auth and token endpoints, and client secret.
    var grant = oauth2.AuthorizationCodeGrant(
      googleClientId,
      Uri.parse(googleAuthApi),
      Uri.parse(googleTokenApi),
      secret: authClientSecret,
      httpClient: JsonAcceptingHttpClient(),
    );

    // Generate authorization URL.
    var authorizationUrl =
        grant.getAuthorizationUrl(Uri.parse(redirectURL), scopes: [emailScope]);

    // Launch authorization URL in default browser.
    await launchUrl(authorizationUrl);

    // Listen for the authorization response and exchange authorization code for credentials.
    var responseQueryParameters = await listen();
    var client =
        await grant.handleAuthorizationResponse(responseQueryParameters);
    return client.credentials;
  }

  /// Listens for the authorization response from the OAuth2 provider.
  ///
  /// Returns a future containing the query parameters from the authorization response.
  Future<Map<String, String>> listen() async {
    // Wait for the first request to the redirect server.
    var request = await redirectServer!.first;

    // Extract query parameters from the request URI.
    var params = request.uri.queryParameters;

    // Activate the application window.
    await WindowToFront.activate();

    // Respond with success message and close the request.
    request.response.statusCode = 200;
    request.response.headers.set('content-type', 'text/plain');
    request.response.writeln('Signed in succesfully! Please close the tab');

    // Close the redirect server after handling the response.
    await request.response.close();
    await redirectServer!.close();
    redirectServer = null;
    return params;
  }
}

/// HTTP client that adds 'Accept: application/json' header to requests.
class JsonAcceptingHttpClient extends http.BaseClient {
  final _httpClient = http.Client();
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    // Add 'Accept: application/json' header to the request.
    request.headers['Accept'] = 'application/json';
    return _httpClient.send(request);
  }
}
