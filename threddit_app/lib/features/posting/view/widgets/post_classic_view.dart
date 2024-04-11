import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/community/view%20model/community_provider.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/models/post.dart';
import 'package:video_player/video_player.dart';
class PostClassic extends ConsumerStatefulWidget {
  const PostClassic(
      {super.key,
      required this.post,
      required this.uid,
      required this.onCommentPressed});
  final Post post;
  final String uid;
  final VoidCallback onCommentPressed;
  @override
  _PostClassicState createState() => _PostClassicState();
}

class _PostClassicState extends ConsumerState<PostClassic> {
late VideoPlayerController _controller;
void initState() {
    super.initState();
    if (widget.post.video != null) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.post.video!),
      )..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     final now = DateTime.now();
    final difference = now.difference(widget.post.postedTime);
    final hoursSincePost = difference.inHours;
    String communityImage='';
    if(widget.post.community!=null)
    {final communityAsyncValue = ref.watch(fetchcommunityProvider(widget.post.community!));
    communityAsyncValue.whenData((community) {
      communityImage = community.srLooks.icon!;
    });
    }
   return Container(
      decoration: BoxDecoration(color: AppColors.backgroundColor,),
      child:Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [ 
                    Row(children:widget.post.community==null? [const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: CircleAvatar(
                          radius:10,
                          backgroundImage:
                              AssetImage('assets/images/Default_Avatar.png'),
                        ),
                      ),
                      Text(
                                'u/${widget.post.userID}',
                                style: AppTextStyles.primaryTextStyle.copyWith(
                                    fontSize: 12,
                                    color: const Color.fromARGB(206, 20, 113, 190)),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(
                                Icons.circle,
                                size: 4,
                                color: Color.fromARGB(98, 255, 255, 255),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${hoursSincePost}h',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(110, 255, 255, 255),
                                ),
                              )
                      ]:[
                        Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: CircleAvatar(
                          radius: 10,
                          backgroundImage:
                              NetworkImage(
                                    communityImage),
                        ),
                      ),
                      Text(
                                'r/${widget.post.community}',
                                style: AppTextStyles.primaryTextStyle.copyWith(
                                    fontSize: 12,
                                    color: const Color.fromARGB(206, 20, 113, 190)),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(
                                Icons.circle,
                                size: 4,
                                color: Color.fromARGB(98, 255, 255, 255),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${hoursSincePost}h',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(110, 255, 255, 255),
                                ),
                              )
                
                      ]),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:8.0,vertical:5),
                        child: Text(
                        widget.post.title,
                        style: AppTextStyles.primaryTextStyle.copyWith(
                            color: const Color.fromARGB(238, 255, 255, 255),
                            fontSize: 16),
                                      ),
                      ),
                  ],
                ),
              ),
              if(widget.post.video != null || widget.post.image!=null )Column()
                  
            ],
          ),
          
        ],
      ),
   );
  }
}
