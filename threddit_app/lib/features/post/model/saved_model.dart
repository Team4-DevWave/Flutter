class SavePostModel {
  final List<String>? postid;

  SavePostModel({this.postid});

  factory SavePostModel.fromJson(Map<String, dynamic> json) {
    final savedData = json['data'] as Map<String, dynamic>?;
    if (savedData == null) {
      return SavePostModel();
    }
    return SavePostModel(
      postid: (savedData['posts']['_id'] as List<dynamic>?)
          ?.map((postid) => postid as String)
          .toList(),
    );
  }
}
