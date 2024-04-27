import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrlFunction(Uri urll) async {
  if (!await launchUrl(urll)) {
    throw Exception('Could not launch $urll');
  }
}
