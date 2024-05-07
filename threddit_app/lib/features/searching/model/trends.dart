/// Data class that holds the Trend's data to display.
class Trend {
  final String? title;
  final String? subtitle;
  Trend({this.title, this.subtitle});
  factory Trend.fromJson(Map<String, dynamic> json) {
    return Trend(
      title: json['title'],
      subtitle: json['subtitle'],
    );
  }
}
