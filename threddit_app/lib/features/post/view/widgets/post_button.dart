import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/view_model/home_page_provider.dart';
import 'package:threddit_clone/features/post/viewmodel/post_provider.dart';
import 'package:threddit_clone/features/post/viewmodel/send_post.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/theme/colors.dart';

class PostButton extends ConsumerWidget {
  const PostButton(
      {super.key, required this.titleController, required this.type});
  final TextEditingController titleController;
  final String type;
  Color textColor() {
    return titleController.text.isEmpty ? AppColors.whiteColor : Colors.white;
  }

  Color backgroundColor() {
    return titleController.text.isEmpty
        ? const Color.fromARGB(255, 30, 31, 31)
        : AppColors.redditOrangeColor;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //this functions collects the data to send it to the backend

    void onPost() async {
      ///check if there is a title
      if (titleController.text.isNotEmpty) {
        ///call function to send data to the backend
        final response = await ref.watch(createPost.notifier).submitPost(type);
        response.fold((l) {
          showSnackBar(navigatorKey.currentContext!, l.message);
        }, (post) {
          ///should route to the posted post page but it routes to the mainLayout for now
          ref.read(currentScreenProvider.notifier).updateCurrentScreen(0);
          Navigator.pushNamed(context, RouteClass.postScreen, arguments: {
            'currentpost': post,
            'uid': ref.read(userModelProvider)?.id
          });
        });
      } else {
        null;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ElevatedButton(
        onPressed: onPost,
        //the button is greyed out at first until the user enters a title
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
            backgroundColor(),
          ),
          iconSize: const MaterialStatePropertyAll(40),
        ),
        child: Text(
          "Post",
          style: TextStyle(
            color: textColor(),
          ),
        ),
      ),
    );
  }
}
