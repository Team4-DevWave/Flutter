import 'package:url_launcher/url_launcher.dart';

/// Launches a URL in the mobile device's web browser.
///
/// Takes a [Uri] as a parameter and attempts to open it using the `launch` function from the `url_launcher` package.
/// If the URL cannot be launched, it throws an [Exception].
///
/// Example usage:
/// ```dart
/// launchUrlFunction(Uri.parse('https://example.com'));
/// ```
Future<void> launchUrlFunction(Uri urll) async {
  if (!await launchUrl(urll)) {
    throw Exception('Could not launch $urll');
  }
}
