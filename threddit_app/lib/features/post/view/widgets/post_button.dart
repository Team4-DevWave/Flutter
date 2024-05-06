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

/// A widget representing a post button for submitting posts.
///
/// This widget displays a post button that is initially disabled if no title
/// is entered by the user. Once a title is entered, the button becomes enabled
/// and allows the user to submit a post.
///
/// [titleController] is a required parameter of type [TextEditingController]
/// which holds the controller for the title input field.
///
/// [type] is a required parameter of type [String] which specifies the type
/// of post being submitted.
class PostButton extends ConsumerWidget {
  /// Constructs a [PostButton] widget.
  ///
  /// [titleController] is a required parameter of type [TextEditingController]
  /// which holds the controller for the title input field.
  ///
  /// [type] is a required parameter of type [String] which specifies the type
  /// of post being submitted.
  const PostButton(
      {super.key, required this.titleController, required this.type});

  /// Controller for the title input field.
  final TextEditingController titleController;

  /// Specifies the type of post being submitted.
  final String type;

  /// Determines the text color of the post button.
  ///
  /// Returns [AppColors.whiteColor] if the title field is empty, otherwise
  /// returns [Colors.white].
  Color textColor() {
    return titleController.text.isEmpty ? AppColors.whiteColor : Colors.white;
  }

  /// Determines the background color of the post button.
  ///
  /// Returns [Color.fromARGB(255, 30, 31, 31)] if the title field is empty,
  /// otherwise returns [AppColors.redditOrangeColor].
  Color backgroundColor() {
    return titleController.text.isEmpty
        ? const Color.fromARGB(255, 30, 31, 31)
        : AppColors.redditOrangeColor;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Handles the action to be executed when the post button is pressed.
    ///
    /// If the title field is not empty, the function submits the post data to
    /// the backend. After submitting, it navigates to the main layout screen
    /// and displays a snackbar if an error occurs.
    void onPost() async {
      //check if there is a title
      if (titleController.text.isNotEmpty) {
        //call function to send data to the backend
        final response = await ref.watch(createPost.notifier).submitPost(type);
        response.fold((l) {
          showSnackBar(navigatorKey.currentContext!, l.message);
        }, (post) {
          ref.read(postDataProvider.notifier).resetAll();

          //should route to the posted post page but it routes to the mainLayout for now
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
