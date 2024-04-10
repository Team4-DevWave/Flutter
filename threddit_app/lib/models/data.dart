
import 'package:threddit_clone/models/post.dart';

final List<Post> posts = [
    Post(
      title: "Sample Post 1",
      postBody: "This is a sample post body.",
      link: "https://example.com/post1",
      NSFW: false,
      spoiler: false,
      imageUrl: "https://example.com/image1.jpg",
      community: "Sample Community",
      videoUrl: "https://example.com/video1.mp4",
      upvotes: ["user1", "user2"],
      downvotes: ["user3"],
      commentsID: ["comment1", "comment2"],
      mentioned: ["user4", "user5"],
      userID: "user123",
      postedTime: DateTime.now(),
      id: "post1_id",
      numViews: 100,
      locked: false,
      approved: true,
    ),
    Post(
      title: "Sample Post 2",
      postBody: "This is another sample post body.",
      NSFW: false,
      spoiler: true,
      community: "Another Community",
      upvotes: ["user6"],
      downvotes: ["user7", "user8"],
      commentsID: [],
      mentioned: ["user9"],
      userID: "user456",
      postedTime: DateTime.now().subtract(Duration(days: 1)),
      id: "post2_id",
      numViews: 50,
      locked: true,
      approved: false,
    ),
  ];



List<String> reportReasons = [
  'Breaks community rules',
  'Harassment',
  'Threatning Violence',
  'Hate',
  'Minor abuse or sexualization',
  'Sharing personal information',
  'Non-consensual intmate media',
  'Prohibited transaction',
  'Impersonation',
  'Copyright violation',
  'Trademark violation',
  'Self-harm or suicide',
  'Spam'
];
