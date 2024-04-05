import 'package:flutter/material.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/theme/colors.dart';

class PostButton extends StatelessWidget {
  const PostButton({super.key, required this.titleController});
  final TextEditingController titleController;
  Color textColor() {
    return titleController.text.isEmpty ? AppColors.whiteColor : Colors.white;
  }

  Color backgroundColor() {
    return titleController.text.isEmpty
        ? const Color.fromARGB(255, 30, 31, 31)
        : AppColors.redditOrangeColor;
  }

  @override
  Widget build(BuildContext context) {
    void onPost() {
      ///check if there is a title 
      if (titleController.text.isNotEmpty) {
        ///call function to send data to the backend
        
        ///route to the posted post page
        ///Navigator.pushNamed(context, RouteClass.?);
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
          iconSize:const MaterialStatePropertyAll(40),
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
