import 'package:flutter/material.dart';
import 'package:threddit_app/features/posting/data/data.dart';
import 'package:threddit_app/models/post.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:threddit_app/theme/text_styles.dart';

class HomeScreenPostCard extends StatefulWidget {
  const HomeScreenPostCard({super.key, required this.post});
  final Post post;
  @override
  _HomeScreenPostCard createState() => _HomeScreenPostCard();
}

class _HomeScreenPostCard extends State<HomeScreenPostCard> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(widget.post.createdAt);
    final hoursSincePost = difference.inHours;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundColor,
      ),
      //padding: const EdgeInsets.symmetric(vertical: 10),
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
                  ),
                ),
                //Image.asset(Photos.defaultavatar,width: 16,height: 16,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('r/${widget.post.communityName}',
                        style: AppTextStyles.primaryTextStyle.copyWith(
                            fontSize: 12,
                            color: const Color.fromARGB(98, 255, 255, 255),
                            fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Text(
                          'u/${widget.post.username}',
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 13.0),
              child: Text(
                widget.post.title,
                style: AppTextStyles.primaryTextStyle.copyWith(
                    color: const Color.fromARGB(238, 255, 255, 255),
                    fontSize: 18),
              ),
            ),
            if (widget.post.description != null)
              Text(
                widget.post.description!,
                style: AppTextStyles.primaryTextStyle.copyWith(
                    color: const Color.fromARGB(196, 255, 255, 255),
                    fontSize: 15),
              ),
              Row(
                children: [
                  IconButton(onPressed: (){}, icon:const Icon (Icons.arrow_upward_outlined, size: 30,) ),
                  Text('${widget.post.upvotes.length-widget.post.downvotes.length==0?"vote":widget.post.upvotes.length-widget.post.downvotes.length}',style: AppTextStyles.primaryTextStyle.copyWith(color: AppColors.whiteColor),),
                  IconButton(onPressed: (){}, icon:const Icon (Icons.arrow_downward_outlined, size: 30,) ),
                  IconButton(onPressed: (){}, icon: const Icon(Icons.comment)),
                  Text('${widget.post.commentCount}',style: AppTextStyles.primaryTextStyle.copyWith(color: AppColors.whiteColor)),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(onPressed: (){}, icon: const Icon(Icons.refresh)),
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
