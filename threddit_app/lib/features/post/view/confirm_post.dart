import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/post/viewmodel/post_provider.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class ConfirmPost extends ConsumerStatefulWidget{
  const ConfirmPost({super.key});
  
  @override
  ConsumerState<ConfirmPost> createState()=>  _ConfirmPostState();
}

class _ConfirmPostState extends ConsumerState<ConfirmPost>{

  @override
  Widget build(BuildContext context) {
    final post = ref.watch(postDataProvider)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(post.title, style: AppTextStyles.primaryTextStyle,),
        Text(post.community?? "no community", style: AppTextStyles.primaryTextStyle,),
        Text(post.postBody?? "no body", style: AppTextStyles.primaryTextStyle,),
        Text(post.link?? "no link", style: AppTextStyles.primaryTextStyle,),
      ]
    );
  }
}