import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/post/model/post_model.dart';
import 'package:threddit_clone/features/post/view/rules_screen.dart';
import 'package:threddit_clone/features/post/view/widgets/add_image.dart';
import 'package:threddit_clone/features/post/view/widgets/add_link.dart';
import 'package:threddit_clone/features/post/view/widgets/add_video.dart';
import 'package:threddit_clone/features/post/view/widgets/close_button.dart';
import 'package:threddit_clone/features/post/view/widgets/post_button.dart';
import 'package:threddit_clone/features/post/view/widgets/tags.dart';
import 'package:threddit_clone/features/post/viewmodel/post_provider.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class PostSchedule extends ConsumerStatefulWidget {
  const PostSchedule({super.key, required this.communityName});
  final String communityName;
  @override
  ConsumerState<PostSchedule> createState() => _PostScheduleState();
}

class _PostScheduleState extends ConsumerState<PostSchedule> {
  TextEditingController _titleController = TextEditingController(text: '');
  TextEditingController _bodytextController = TextEditingController(text: '');
  bool isImage = false;
  bool isLink = false;
  bool isVideo = false;
  bool isPoll = false;
  late String postTitle;
  late String postBody;

  ///add image picker data
  final ImagePicker picker = ImagePicker();
  String? image;
  String? video;
  String? whereTo;
  File? videoFile;
  File? imageFile;

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return;

    imageFile = File(pickedImage.path);

    Uint8List imageBytes = await imageFile!.readAsBytes();

    setState(() {
      image = base64Encode(imageBytes);

      isImage = true;
      ref.read(postDataProvider.notifier).updateImages(image!);
      ref.read(postDataProvider.notifier).updateImagePath(imageFile!);
    });
  }

  Future<void> _pickVideo() async {
    final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);
    // If the user does not select a video then return null.
    if (pickedVideo == null) return;
    videoFile = File(pickedVideo.path);
    Uint8List videoBytes = await videoFile!.readAsBytes();
    setState(() {
      video = base64Encode(videoBytes);
      isVideo = true;
      ref.read(postDataProvider.notifier).updateVideo(video!);
      ref.read(postDataProvider.notifier).updateVideoPath(videoFile!);
    });
  }

  Future<void> _removeImage() async {
    setState(() {
      image = null;
      isImage = false;
    });
  }

  Future<void> _addLink() async {
    setState(() {
      isLink = true;
    });
  }

  Future<void> _removeVideo() async {
    setState(() {
      video = null;
      isVideo = false;
    });
  }

  Future<void> _removeLink() async {
    setState(() {
      isLink = false;
    });
  }

  void intializeData() {
    whereTo = widget.communityName;
  }

  @override
  void didChangeDependencies() {
    intializeData();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodytextController.dispose();
    super.dispose();
  }

  void resetAll() {
    _titleController = TextEditingController(text: '');
    _bodytextController = TextEditingController(text: '');
    _removeLink();
    ref.read(postDataProvider.notifier).resetAll();
  }

  void onTitleChanged(String value) {
    final post = ref.watch(postDataProvider);
    if (post!.title != value) {
      ref.watch(postDataProvider.notifier).updateTitle(value);
    }
  }

  void onBodyChanged(String value) {
    final post = ref.watch(postDataProvider);
    if (post!.text_body != value) {
      ref.watch(postDataProvider.notifier).updateBodyText(value);
    }
    postBody = value;
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    PostData? post = ref.watch(postDataProvider);

    Widget buildImageContent() {
      if (image == null || isLink || isVideo) {
        return const SizedBox();
      }
      return AddImageWidget(onPressed: _removeImage, imagePath: imageFile!);
    }

    Widget buildVideoContent() {
      if (video == null || isLink || isImage) {
        return const SizedBox();
      }
      return AddVideoWidget(onPressed: _removeVideo, videoPath: videoFile!);
    }

    Widget buildLink() {
      if (isLink) {
        return AddLinkWidget(
          removeLink: _removeLink,
        );
      }
      return const SizedBox();
    }

    void openRulesOverlay() {
      showModalBottomSheet(
          backgroundColor: AppColors.backgroundColor,
          context: context,
          builder: (ctx) {
            return RulesPage(
              communityName: whereTo!,
            );
          });
    }

    void openTagsOverlay() {
      showModalBottomSheet(
          context: context,
          backgroundColor: AppColors.backgroundColor,
          builder: (ctx) {
            return TagsWidget(
              post: post,
            );
          });
    }

    void scheduling() {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: AppColors.backgroundColor,
          builder: (ctx) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.navigate_before),
                        color: AppColors.whiteGlowColor,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        "Schedule Post",
                        style: TextStyle(
                            color: AppColors.whiteGlowColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      ElevatedButton(
                         style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(223, 49, 49, 49)),),
                          onPressed: () {},
                          child: Text(
                            'Save',
                            style: AppTextStyles.primaryButtonGlowTextStyle,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Text(
                        "Start on date",
                        style: AppTextStyles.boldTextStyle
                            .copyWith(fontSize: 16.spMin),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Text(
                        "Start on time ",
                        style: AppTextStyles.boldTextStyle
                            .copyWith(fontSize: 16.spMin),
                      ),
                    ],
                  )
                ],
              ),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: ClosedButton(
            resetAll: resetAll,
            firstScreen: 2,
            titleController: _titleController,
            isImage: isImage,
            isLink: isLink,
            isVideo: isVideo,
            isPoll: isPoll,
          ),
          actions: [
            if (_titleController.text != "")
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      backgroundColor: AppColors.backgroundColor,
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Post Settings",
                                style: AppTextStyles.boldTextStyle,
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              InkWell(
                                onTap: () {
                                  scheduling();
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const Icon(
                                      Icons.calendar_today_outlined,
                                      color: AppColors.whiteGlowColor,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      "Schedule Post",
                                      style: AppTextStyles.boldTextStyle
                                          .copyWith(fontSize: 16.spMin),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      Icons.navigate_next,
                                      color: AppColors.whiteGlowColor,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      });
                },
                icon: const Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                ),
              ),
            if (isImage || isVideo)
              PostButton(
                titleController: _titleController,
                type: "image/video",
              )
            else if (isLink)
              PostButton(titleController: _titleController, type: "url")
            else
              PostButton(titleController: _titleController, type: "text")
          ]),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RouteClass.postToScreen);
                              },
                              splashColor: AppColors.realWhiteColor,
                              child: Text(
                                whereTo!,
                                style: AppTextStyles.boldTextStyle,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                openRulesOverlay();
                              },
                              child: const Text(
                                "Rules",
                                style: TextStyle(
                                  color: AppColors.redditOrangeColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextField(
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          controller: _titleController,
                          style: const TextStyle(
                              fontSize: 24, color: AppColors.whiteGlowColor),
                          cursorColor: AppColors.redditOrangeColor,
                          cursorWidth: 1.5,
                          decoration: const InputDecoration(
                              labelText: 'Title',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              labelStyle: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24)),
                          onChanged: (value) async => {
                            await Future.microtask(() => onTitleChanged(value))
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: openTagsOverlay,
                        style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                AppColors.whiteHideColor)),
                        child: const Text(
                          "Add Tags",
                          style: TextStyle(color: AppColors.whiteGlowColor),
                        ),
                      ),
                      buildImageContent(),
                      buildLink(),
                      buildVideoContent(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 40),
                        child: TextField(
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            keyboardType: TextInputType.text,
                            maxLines: null,
                            controller: _bodytextController,
                            style: const TextStyle(
                                fontSize: 16, color: AppColors.whiteGlowColor),
                            cursorColor: AppColors.redditOrangeColor,
                            cursorWidth: 1.5,
                            decoration: const InputDecoration(
                                labelText: 'body text (optional)',
                                floatingLabelAlignment:
                                    FloatingLabelAlignment.start,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                labelStyle: TextStyle(
                                    color: AppColors.whiteColor, fontSize: 16)),
                            onChanged: (value) async => await Future.microtask(
                                () => onBodyChanged(value))),
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: AppColors.backgroundColor,
        height: 40.h,
        child: Row(
          children: [
            IconButton(
              onPressed: (!isLink && !isVideo) ? _pickImage : () {},
              icon: const Icon(Icons.image),
              color: isLink || isImage || isVideo
                  ? AppColors.whiteHideColor
                  : AppColors.whiteGlowColor,
            ),
            IconButton(
              onPressed: (!isLink && !isImage) ? _pickVideo : () {},
              icon: const Icon(Icons.video_library_outlined),
              color: isLink || isImage || isVideo
                  ? AppColors.whiteHideColor
                  : AppColors.whiteGlowColor,
            ),
            IconButton(
              onPressed: (!isImage && !isVideo) ? _addLink : () {},
              icon: const Icon(Icons.link),
              color: isLink || isImage || isVideo
                  ? AppColors.whiteHideColor
                  : AppColors.whiteGlowColor,
            ),
          ],
        ),
      ),
    );
  }
}