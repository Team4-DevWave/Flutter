import 'package:flutter/material.dart';
import 'package:threddit_app/theme/colors.dart';

class AddComment extends StatefulWidget {
  const AddComment({super.key});

  @override
  State<AddComment> createState() {
    return _AddComment();
  }
}

class _AddComment extends State<AddComment> {
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (BuildContext context) {
        return Container(
          color: AppColors.backgroundColor,
          height: 60,
          child: Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top:6.0),
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      onTap: () {},
                      decoration: const InputDecoration(
                        labelText: 'Add a comment',
                        labelStyle: TextStyle(color: Color.fromARGB(171, 255, 255, 255)),
                        filled: true,
                        fillColor: Color.fromARGB(212, 87, 87, 87),
                        
                      ),
                    ),
                  ),
                ),
                
                
              ],
            ),
          ),
        );
      },
    );
  }
}
