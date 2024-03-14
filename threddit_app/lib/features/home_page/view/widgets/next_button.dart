import 'package:flutter/material.dart';
//import 'package:threddit_app/features/home_page/home_page_provider.dart';
import 'package:threddit_app/features/home_page/view/post_to_screen.dart';
import 'package:threddit_app/theme/colors.dart';

class NextButton extends StatefulWidget {
  const NextButton({super.key, required this.titleController});

  final TextEditingController titleController;
  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  Color textColor() {
    return widget.titleController.text.isEmpty ? AppColors.whiteColor : Colors.white;
  }

  Color backgroundColor() {
    return widget.titleController.text.isEmpty
        ? const Color.fromARGB(255, 30, 31, 31)
        : Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    void onNext() {
      if (widget.titleController.text.isNotEmpty) {
        Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => const PostToScreen()));
      }
    }
    return ElevatedButton(
      onPressed: onNext,
      //the button is greyed out at first until the user enters a title
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(
          backgroundColor(),
        ),
      ),
      child: Text(
        "Next",
        style: TextStyle(
          color: textColor(),
        ),
      ),
    );
  }
}
