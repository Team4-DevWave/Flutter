class Trend {
  final String? title;
  final String? subtitle;
  Trend({this.title, this.subtitle});
}

class Trends {
  final List<Trend>? trendsList;
  Trends({this.trendsList});
  factory Trends.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? trendData = json['data']['trends'];
    if (trendData != null) {
      List<Trend> trends = trendData.map((trend) {
        return Trend(subtitle: trend['subtitle'], title: trend['title']);
      }).toList();
      return Trends(trendsList: trends);
    } else {
      return Trends(trendsList: []);
    }
  }
}
