import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/posting/view_model/post_provider.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:video_player/video_player.dart';

class SharedPostCard extends ConsumerStatefulWidget {
  const SharedPostCard(
      {super.key,
      required this.post,
      required this.uid,
     });
  final Post post;
  final String uid;
  @override
  _SharedPostCardState createState() => _SharedPostCardState();
}

class _SharedPostCardState extends ConsumerState<SharedPostCard> {
  late VideoPlayerController _controller;
  @override
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
  Widget build(BuildContext) {
    void toggleNsfw() {
      widget.post.nsfw = !widget.post.nsfw;
      setstate() {
      }
       ref.read(toggleNSFW(widget.post.id));
      Navigator.pop(context);
      
    }

    void toggleSPOILER() async {
      widget.post.spoiler = !widget.post.spoiler;
      setstate() {
      }
      ref.read(toggleSpoiler(widget.post.id));
      Navigator.pop(context);
      
    }
    void upVotePost(WidgetRef ref) async {}

    void downVotePost(WidgetRef ref) async {}
    final now = DateTime.now();
    final difference = now.difference(widget.post.postedTime);
    final hoursSincePost = difference.inHours;
    final differenceParent =now.difference(widget.post.parentPost!.postedTime);
    final hoursSinceParentPost = differenceParent.inHours;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundImage:
                        AssetImage('assets/images/Default_Avatar.png'),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.post.subredditID != null)
                      Text('r/${widget.post.subredditID?.name}',
                          style: AppTextStyles.primaryTextStyle.copyWith(
                              fontSize: 12,
                              color: const Color.fromARGB(98, 255, 255, 255),
                              fontWeight: FontWeight.bold)),
                              
                    Row(
                      children: [
                        Text(
                          'u/${widget.post.userID!.id}',
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
                      ],
                    ),
                  ],
                ),
              ],
            ),
            if(widget.post.nsfw || widget.post.spoiler)
            Padding(
              padding: const EdgeInsets.only(top:10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                if(widget.post.nsfw) const Text("NSFW",style:TextStyle(backgroundColor: Colors.pink, color: Colors.white)),
                const SizedBox(width: 10,),
                if(widget.post.spoiler) const Text("SPOILER",style:TextStyle(backgroundColor: Colors.purple, color: Colors.white)),
              ],),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 13.0),
              child: Text(
                widget.post.title,
                style: AppTextStyles.primaryTextStyle.copyWith(
                    color: const Color.fromARGB(238, 255, 255, 255),
                    fontSize: 18),
              ),
            ),
            if(widget.post.parentPost != null)
            GestureDetector(
              onTap: (){Navigator.pushNamed(
          context,
          RouteClass.postScreen,
          arguments: {
            'currentpost': widget.post.parentPost!,
            'uid': widget.uid,
          },
        );},
              child: Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), 
                      border: Border.all(
                        color: const Color.fromARGB(108, 255, 255, 255), // Specify the border color
                        width: 0.4, 
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if(widget.post.subredditID!=null)
                      Text(
                          'r/${widget.post.parentPost!.subredditID?.name}',
                          style: const TextStyle(color: Color.fromARGB(82, 255, 255, 255,),fontSize: 12),
                        ),
                         if(widget.post.subredditID!=null)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal:8.w),
                          child: const Icon(Icons.circle,size:5,color:Color.fromARGB(82, 255, 255, 255,)),
                        ),
                      Text(
                          'u/${widget.post.parentPost!.userID?.username}',
                          style: const TextStyle(color:Color.fromARGB(82, 255, 255, 255,),fontSize: 12),
                        ),
                      
                      SizedBox(
                        width: 7.w,
                      ),
                      Text(
                       '${hoursSinceParentPost}h',
                        style: const TextStyle(color:Color.fromARGB(82, 255, 255, 255,),fontSize: 12),
                      ),
                    ],
                  )),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.parentPost!.title,
                      style: AppTextStyles.boldTextStyle,
                    ),
                  ],
                ),
              ),
                         if (widget.post.parentPost!.image != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.network(widget.post.image!),
                ),
              if (widget.post.parentPost!.video != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _controller.value.isInitialized
                      ? GestureDetector(
                          onTap: () {
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                            } else {
                              _controller.play();
                            }
                            setState(() {});
                          },
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: Stack(alignment: Alignment.center, children: [
                              VideoPlayer(_controller),
                              Positioned(
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _controller.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              )
                            ]),
                          ),
                        )
                      : const CircularProgressIndicator(),
                ),
              SizedBox(
                height: 5.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "${widget.post.parentPost!.votes!.upvotes- widget.post.parentPost!.votes!.downvotes} points",
                        style: const TextStyle(color:Color.fromARGB(82, 255, 255, 255,),fontSize: 12),
                      ),
                       Padding(
                          padding: EdgeInsets.symmetric(horizontal:8.w),
                          child: const Icon(Icons.circle,size:5, color:Color.fromARGB(82, 255, 255, 255,) ,),
                        ),
                      Text("${widget.post.parentPost!.commentsCount} comments",
                          style: const TextStyle(color:Color.fromARGB(82, 255, 255, 255,),fontSize: 12)),
                    ],
                  ),
                ],
              ),
                        ],
                      ),
                    ),
                  ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    upVotePost(ref);
                  },
                  icon: const Icon(
                    Icons.arrow_upward_outlined,
                    size: 30,
                  ),
                  color: Colors.white,
                ),
                Text(
                  '${widget.post.votes!.upvotes - widget.post.votes!.downvotes == 0 ? "vote" : widget.post.votes!.upvotes - widget.post.votes!.downvotes}',
                  style: AppTextStyles.primaryTextStyle
                      .copyWith(color: AppColors.whiteColor),
                ),
                IconButton(
                  onPressed: () {
                    downVotePost(ref);
                  },
                  icon: const Icon(
                    Icons.arrow_downward_outlined,
                    size: 30,
                  ),
                  color: Colors.white,
                ),
                
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: widget.uid == widget.post.userID!.id
                        ? [
                            IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      backgroundColor:
                                          AppColors.backgroundColor,
                                      builder: (context) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            ListTile(
                                              title: Text(
                                                widget.post.spoiler
                                                    ? 'UnMark Spoiler'
                                                    : 'Mark Spoiler',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              leading: const Icon(
                                                  Icons.warning_rounded),
                                              onTap: () {
                                                toggleSPOILER();
                                              },
                                            ),
                                            ListTile(
                                              title: const Text(
                                                'Lock Comments',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              leading: const Icon(Icons.lock),
                                              onTap: () {},
                                            ),
                                            ListTile(
                                              title: Text(
                                                widget.post.nsfw
                                                    ? 'UnMark NSFW'
                                                    : 'Mark NSFW',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              leading: const Icon(Icons.copy),
                                              onTap: () {
                                                toggleNsfw();
                                              },
                                            ),
                                            ListTile(
                                              title: const Text(
                                                'Distinguish as moderator',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              leading: const Icon(
                                                Icons.star_outline_outlined,
                                              ),
                                              onTap: () {},
                                            ),
                                            ListTile(
                                              title: const Text(
                                                'Remove post',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              leading: const Icon(
                                                Icons.delete,
                                              ),
                                              onTap: () {},
                                            ),
                                            ListTile(
                                              title: const Text(
                                                'Remove as spam',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              leading: const Icon(
                                                  Icons.folder_delete_outlined),
                                              onTap: () {},
                                            ),
                                            ListTile(
                                              title: const Text(
                                                'Approve',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              leading: const Icon(
                                                  Icons.verified_user_rounded),
                                              onTap: () {},
                                            )
                                          ],
                                        );
                                      });
                                },
                                icon: const Icon(Icons.add_moderator_sharp)),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.insights,
                                color: Colors.purple,
                              ),
                            )
                          ]
                        : [
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.ios_share_rounded,
                                color: Colors.white,
                              ),
                              label: const Text("Share"),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white),
                            ),
                          ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
