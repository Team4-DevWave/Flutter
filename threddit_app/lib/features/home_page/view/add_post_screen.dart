import 'package:flutter/material.dart';
import 'package:threddit_app/features/home_page/view/home_screen.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_app/theme/colors.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  late String postTitle;
  late String postBody;
  late TextEditingController _titleController;
  late TextEditingController _bodytextController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _bodytextController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodytextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          //Navigator.popAndPushNamed(context, );
        }, icon: const Icon(Icons.close)),
        actions: [
          ElevatedButton(
            //this button should only be pressable when there is a title provided
            //it redirects to choose a community to post on page
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
            ),
             child: const Text(
              'Next',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _titleController,
                style: const TextStyle(fontSize: 24, color: AppColors.realWhiteColor),
                cursorColor: AppColors.redditOrangeColor,
                cursorWidth: 1.5,
                decoration: const InputDecoration(
                    labelText: 'Title',
                    focusColor: null,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    labelStyle: TextStyle(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 24)),
                onChanged: (value) => {
                  setState(() {
                    postTitle = value;
                  })
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _bodytextController,
                  style: const TextStyle(fontSize: 16, color: AppColors.realWhiteColor),
                  cursorColor: AppColors.redditOrangeColor,
                  cursorWidth: 1.5,
                  decoration: const InputDecoration(
                      labelText: 'body text (optional)',
                      focusColor: null,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      labelStyle: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 16)),
                  onChanged: (value) => {
                    setState(() {
                      postBody = value;
                    })
                  }
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
              left: 0,
              right: 0,
              child: Row(children: [
                IconButton(onPressed: (){}, icon: const Icon(Icons.add_link_rounded), color: AppColors.realWhiteColor,),
                IconButton(onPressed: (){}, icon: const Icon(Icons.image_outlined), color: AppColors.realWhiteColor,),
                
              ],)
            )
          ]),
    );
  }
}
