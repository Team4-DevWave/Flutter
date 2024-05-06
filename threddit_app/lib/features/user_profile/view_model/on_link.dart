import 'package:url_launcher/url_launcher.dart';

/// Constructs the link based on the provided list of strings.
///
/// This function takes a list of strings representing a link,
/// and constructs the appropriate URL based on the length of the list.
///
/// Parameters:
///   - link: A list of strings representing a link. It can have either 2 or 3 elements.
///
/// Returns:
///   The constructed URL as a string.
String linkAdded(List<String> link) {
  if (link.length == 3) {
    return link[2];
  } else {
    return ("https://www.${link[0]}.com/${link[1]}");
  }
}

/// Opens the provided link in the default web browser.
///
/// This function attempts to launch the provided link in the default web browser.
/// If successful, it opens the link in the browser. Otherwise, it throws an exception.
///
/// Parameters:
///   - link: A list of strings representing a link. It can have either 2 or 3 elements.
void onLink(List<String> link) async {
  final Uri url = Uri.parse(linkAdded(link));

  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
