import 'package:url_launcher/url_launcher.dart';

String linkAdded(List<String> link) {
  if (link.length == 3) {
    return link[2];
  } else {
    return ("https://www.${link[0]}.com/${link[1]}");
  }
}

void onLink(List<String> link) async {
  final Uri url = Uri.parse(linkAdded(link));

  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
