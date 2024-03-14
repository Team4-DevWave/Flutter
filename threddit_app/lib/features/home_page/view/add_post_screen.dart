import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_app/features/home_page/home_page_provider.dart';
//import 'package:threddit_app/features/home_page/view/home_screen.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:threddit_app/features/home_page/view/widgets/next_button.dart';

class AddPostScreen extends ConsumerStatefulWidget {
  const AddPostScreen({super.key});

  @override
  ConsumerState<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends ConsumerState<AddPostScreen> {
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
          ref.read(currentScreenProvider.notifier).returnToPrevious();
        }, icon: const Icon(Icons.close)),
        actions: [
          NextButton(titleController: _titleController),
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
                    print(postTitle);
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
            Row(children: [
                IconButton(onPressed: (){}, icon: const Icon(Icons.add_link_rounded), color: AppColors.realWhiteColor,),
                IconButton(onPressed: (){}, icon: const Icon(Icons.image_outlined), color: AppColors.realWhiteColor,),
                
              ],)
            
          ]),
    );
  }
}
