import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:threddit_clone/features/Moderation/model/schedule_post.dart';
import 'package:threddit_clone/features/Moderation/view/screens/widgets/scheduling_sheet.dart';
import 'package:threddit_clone/features/Moderation/view_model/schedule_post.dart';
import 'package:threddit_clone/features/post/model/post_model.dart';
import 'package:threddit_clone/features/post/view/rules_screen.dart';
import 'package:threddit_clone/features/post/view/widgets/add_image.dart';
import 'package:threddit_clone/features/post/view/widgets/add_link.dart';
import 'package:threddit_clone/features/post/view/widgets/add_poll.dart';
import 'package:threddit_clone/features/post/view/widgets/add_video.dart';
import 'package:threddit_clone/features/post/view/widgets/close_button.dart';
import 'package:threddit_clone/features/post/view/widgets/post_button.dart';
import 'package:threddit_clone/features/post/view/widgets/tags.dart';
import 'package:threddit_clone/features/post/viewmodel/post_provider.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

/// A StatefulWidget responsible for confirming and posting a new content.
///
/// This widget allows users to confirm their post content before submitting
/// it to the application. Users can input a title, body text, add images,
/// videos, or links to their post, and select tags. They can also view the
/// rules of the community they are posting in.
///
/// This widget listens to the changes in the [PostDataProvider] to update the
/// content accordingly.
class PostSchedule extends ConsumerStatefulWidget {
  const PostSchedule({super.key});
  @override
  ConsumerState<PostSchedule> createState() => _PostScheduleState();
}

class _PostScheduleState extends ConsumerState<PostSchedule> {
  TextEditingController _titleController = TextEditingController(text: '');
  TextEditingController _bodytextController = TextEditingController(text: '');
  bool isImage = false;
  bool isLink = false;
  bool isVideo = false;
  late String postTitle;
  late String postBody;
  bool isPoll = false;
  bool isDisabled = false;

  /// Image picker instance for selecting images from the device gallery.
  final ImagePicker picker = ImagePicker();

  /// Base64 encoded string representation of the selected image.
  String? image;

  /// Base64 encoded string representation of the selected video.
  String? video;

  /// Represnets where the post will be posted.
  String? whereTo;

  /// File representing the selected video.
  File? videoFile;

  /// File representing the selected image.
  File? imageFile;

  /// Picks an image from the device gallery and updates the selected image.
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

  /// Picks a video from the device gallery and updates the selected video.
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

  /// Removes the selected image.
  Future<void> _removeImage() async {
    setState(() {
      image = null;
      isImage = false;
    });
  }

  /// Adds a link to the post.
  Future<void> _addLink() async {
    setState(() {
      isLink = true;
    });
  }

  /// Removes the selected video.
  Future<void> _removeVideo() async {
    setState(() {
      video = null;
      isVideo = false;
    });
  }

  /// Removes the added link.
  Future<void> _removeLink() async {
    setState(() {
      isLink = false;
    });
  }

  /// Initializes the path for the post
  void intializeData() {
    final intialData = ref.watch(postDataProvider);
    if (intialData?.community == null) {
      whereTo = 'My Profile';
    } else {
      whereTo = intialData?.community;
    }
  }

  @override
  void didChangeDependencies() {
    intializeData();
    super.didChangeDependencies();
  }

  Future<void> _addPoll() async {
    setState(() {
      isPoll = true;
    });
  }

  void _removePoll() {
    setState(() {
      isPoll = false;
    });
  }

  bool checkForScheduling(SchedulePostModel? post) {
    if (post == null) {
      return false;
    }
    DateTime selectedDateTime = DateTime(post.realDate!.year,
        post.realDate!.month, post.realDate!.day, post.realTime!.hour);
    DateTime currentDateTime = DateTime.now();
    print('selected date: $selectedDateTime');
    print('current date: $currentDateTime');
    if (selectedDateTime.isAfter(currentDateTime)) {
      setState(() {
        isDisabled = true;
      });
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodytextController.dispose();
    super.dispose();
  }

  /// Resets all data in the widget including title, body, and attachments.
  void resetAll() {
    isImage = false;
    isLink = false;
    isVideo = false;
    _titleController = TextEditingController(text: '');
    _bodytextController = TextEditingController(text: '');
    _removeLink();
    _removePoll();
    ref.read(postDataProvider.notifier).resetAll();
    ref.read(schedulePostProvider.notifier).resetDateAndTime();
  }

  /// Callback function for title field change.
  ///
  /// Updates the title in the `PostDataProvider` if it has changed.
  void onTitleChanged(String value) {
    final post = ref.watch(postDataProvider);
    if (post!.title != value) {
      ref.watch(postDataProvider.notifier).updateTitle(value);
    }
    ref.watch(schedulePostProvider.notifier).updateTitle(value);
  }

  /// Callback function for body text field change.
  ///
  /// Updates the body text in the `PostDataProvider` if it has changed.
  void onBodyChanged(String value) {
    final post = ref.watch(postDataProvider);
    if (post!.text_body != value) {
      ref.watch(postDataProvider.notifier).updateBodyText(value);
    }
    ref.watch(schedulePostProvider.notifier).updateBody(value);
    postBody = value;
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    PostData? post = ref.watch(postDataProvider);
    SchedulePostModel? schpost = ref.watch(schedulePostProvider);

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

    Widget buildPoll() {
      if (isPoll) {
        return AddPoll(removePoll: _removePoll);
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

    Widget scheduleButton() {
      // Show schedule button if the combined date and time is in the future
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: ElevatedButton(
          onPressed: () async {
            ref.read(schedulePostProvider.notifier).resetDateAndTime();
            Navigator.pop(context);
            final response =
                await ref.read(schedulePostProvider.notifier).updateSchPost();
            response.fold((l) => showSnackBar(context, l.message), (r) => null);
          },
          style: const ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(AppColors.redditOrangeColor)),
          child: const Text(
            'Schedule',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
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
          if (_titleController.text != "" && !isImage && !isLink && !isPoll && !isVideo)
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    backgroundColor: AppColors.backgroundColor,
                    builder: (context) {
                      return const SchedulingBottomSheet();
                    });
              },
              icon: const Icon(
                Icons.more_horiz,
                color: Colors.white,
              ),
            ),
          checkForScheduling(schpost)
              ? scheduleButton()
              : (isImage || isVideo)
                  ? PostButton(
                      titleController: _titleController,
                      type: "image/video",
                    )
                  : (isLink)
                      ? PostButton(
                          titleController: _titleController, type: "url")
                      : (isPoll)
                          ? PostButton(
                              titleController: _titleController, type: "poll")
                          : PostButton(
                              titleController: _titleController, type: "text")
        ],
      ),
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
                            Text(
                              whereTo!,
                              style: AppTextStyles.boldTextStyle,
                            ),
                            whereTo != "My Profile"
                                ? TextButton(
                                    onPressed: () {
                                      openRulesOverlay();
                                    },
                                    child: const Text(
                                      "Rules",
                                      style: TextStyle(
                                        color: AppColors.redditOrangeColor,
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
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
                      buildPoll(),
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
              onPressed: (!isLink && !isVideo && !isPoll && !isDisabled)
                  ? _pickImage
                  : () {},
              icon: const Icon(Icons.image),
              color: isLink || isImage || isVideo || isPoll || isDisabled
                  ? AppColors.whiteHideColor
                  : AppColors.whiteGlowColor,
            ),
            IconButton(
              onPressed: (!isLink && !isImage & !isPoll && !isDisabled)
                  ? _pickVideo
                  : () {},
              icon: const Icon(Icons.video_library_outlined),
              color: isLink || isImage || isVideo || isPoll || isDisabled
                  ? AppColors.whiteHideColor
                  : AppColors.whiteGlowColor,
            ),
            IconButton(
              onPressed: (!isImage && !isVideo && !isPoll && !isDisabled)
                  ? _addLink
                  : () {},
              icon: const Icon(Icons.link),
              color: isLink || isImage || isVideo || isPoll || isDisabled
                  ? AppColors.whiteHideColor
                  : AppColors.whiteGlowColor,
            ),
            IconButton(
              onPressed: (!isImage && !isVideo && !isLink && !isDisabled)
                  ? _addPoll
                  : () {},
              icon: const Icon(Icons.poll_outlined),
              color: isLink || isImage || isVideo || isPoll || isDisabled
                  ? AppColors.whiteHideColor
                  : AppColors.whiteGlowColor,
            ),
          ],
        ),
      ),
    );
  }
}
