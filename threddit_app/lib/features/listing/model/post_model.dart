class Post {
  final String username;
  final String time;
  final String header;
  final String container;
  final String imageLink;
  final int numberOfComments;
  final int votes;

  Post({
    required this.username,
    required this.time,
    required this.header,
    required this.container,
    required this.imageLink,
    required this.numberOfComments,
    required this.votes,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      username: json['username'],
      time: json['time'],
      header: json['header'],
      container: json['container'],
      imageLink: json['imageLink'],
      numberOfComments: json['numberOfComments'],
      votes: json['votes'],
    );
  }
}

class PostApiResponse {
  final int status;
  final List<Post> data;

  PostApiResponse({
    required this.status,
    required this.data,
  });

  factory PostApiResponse.fromJson(Map<String, dynamic> json) {
    return PostApiResponse(
      status: json['status'],
      data: (json['data'] as List).map((i) => Post.fromJson(i)).toList(),
    );
  }
}
