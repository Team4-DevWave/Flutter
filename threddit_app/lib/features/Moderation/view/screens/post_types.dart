import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/features/Moderation/model/post_types.dart';
import 'package:threddit_clone/features/Moderation/view/screens/on_exit_mod.dart';
import 'package:threddit_clone/features/Moderation/view_model/post_types.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/theme/theme.dart';

/// Enum representing different options for post types.
enum PostTypeOption { any, linkOnly, textOnly }

/// Helper function to display text for a given post type option.
String textDisplayed(String postType) {
  switch (postType) {
    case 'any':
      return "Any";
    case 'linkOnly':
      return "Link";
    case 'textOnly':
      return "Text";
    default:
      return "Any";
  }
}

/// Screen for managing post types and their settings.
class PostTypesScreen extends ConsumerStatefulWidget {
  const PostTypesScreen({super.key});

  @override
  ConsumerState<PostTypesScreen> createState() => _PostTypesScreenState();
}

class _PostTypesScreenState extends ConsumerState<PostTypesScreen> {
  PostTypeOption _selectedPostType = PostTypeOption.any;
  bool isValid = false;
  bool _isLoading = false;
  bool imagePosts = false;
  bool videoPosts = false;
  bool pollPosts = false;
  late PostTypes postTypesData;

  /// Saves the changes made to post types settings.
  Future<void> onSave() async {
    ref
        .read(postTypesProvider.notifier)
        .updatePostTypesOption(_selectedPostType.name);
    if (_selectedPostType.name == "textOnly") {
      ref.read(postTypesProvider.notifier).updateImagePosts(false);
      ref.read(postTypesProvider.notifier).updateVideoPosts(false);
      ref.read(postTypesProvider.notifier).updatePollPosts(pollPosts);
    } else {
      ref.read(postTypesProvider.notifier).updateImagePosts(imagePosts);
      ref.read(postTypesProvider.notifier).updateVideoPosts(videoPosts);
      ref.read(postTypesProvider.notifier).updatePollPosts(pollPosts);
    }

    final response =
        await ref.read(postTypesProvider.notifier).updatePostTypes();

    response.fold(
        (failure) =>
            showSnackBar(navigatorKey.currentContext!, failure.message),
        (success) => Navigator.pop(context));
  }

  /// Updates the validity of the form based on the changes made.
  void _updateValidaty() {
    isValid = imagePosts != postTypesData.imagePosts ||
        videoPosts != postTypesData.videoPosts ||
        pollPosts != postTypesData.pollPosts ||
        _selectedPostType.name != postTypesData.postTypesOptions;
  }

  /// Fetches the initial data for post types settings.
  Future<void> _setData() async {
    setState(() {
      _isLoading = true;
    });
    final response = await ref.read(postTypesProvider.notifier).getPostTypes();
    response.fold(
        (failure) =>
            showSnackBar(navigatorKey.currentContext!, failure.message),
        (postTypesReturened) => postTypesData = postTypesReturened);
    imagePosts = postTypesData.imagePosts!;
    videoPosts = postTypesData.videoPosts!;
    pollPosts = postTypesData.pollPosts!;
    switch (postTypesData.postTypesOptions) {
      case 'any':
        _selectedPostType = PostTypeOption.any;
      case 'linkOnly':
        _selectedPostType = PostTypeOption.linkOnly;
      case 'textOnly':
        _selectedPostType = PostTypeOption.textOnly;
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              leading: isValid
                  ? const ExitMod()
                  : IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back, size: 27.spMin)),
              backgroundColor: AppColors.backgroundColor,
              title: Text(
                'Post types',
                style:
                    AppTextStyles.primaryTextStyle.copyWith(fontSize: 24.spMin),
              ),
              actions: [
                TextButton(
                  onPressed: isValid ? onSave : null,
                  child: Text(
                    'save',
                    style: AppTextStyles.primaryTextStyle.copyWith(
                      fontSize: 20.spMin,
                      color: isValid
                          ? AppColors.blueColor
                          : AppColors.blueHideColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                ListTile(
                  title: Text("Post type options",
                      style: AppTextStyles.primaryTextStyle
                          .copyWith(color: AppColors.whiteGlowColor)),
                  subtitle: Text(
                      "Choose the types of posts you allow in your community",
                      style: AppTextStyles.primaryTextStyle
                          .copyWith(fontSize: 15.spMin)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(textDisplayed(_selectedPostType.name),
                          style: AppTextStyles.primaryTextStyle.copyWith(
                              fontSize: 16.spMin,
                              color: AppColors.whiteHideColor)),
                      const Icon(
                        Icons.keyboard_arrow_down_outlined,
                      ),
                    ],
                  ),
                  onTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15.0.r)),
                      ),
                      backgroundColor: AppColors.backgroundColor,
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RadioListTile<PostTypeOption>(
                              fillColor: const MaterialStatePropertyAll(
                                  AppColors.blueColor),
                              title: Text("Any",
                                  style: AppTextStyles.primaryTextStyle
                                      .copyWith(
                                          color: AppColors.whiteGlowColor)),
                              subtitle: Text(
                                  "Allow text, link, image, and video posts",
                                  style: AppTextStyles.primaryTextStyle
                                      .copyWith(fontSize: 15.spMin)),
                              value: PostTypeOption.any,
                              groupValue: _selectedPostType,
                              onChanged: (PostTypeOption? value) {
                                setState(() {
                                  _selectedPostType = value!;
                                  _updateValidaty();
                                });
                                Navigator.pop(context);
                              },
                            ),
                            RadioListTile<PostTypeOption>(
                              fillColor: const MaterialStatePropertyAll(
                                  AppColors.blueColor),
                              title: Text("Link Only",
                                  style: AppTextStyles.primaryTextStyle
                                      .copyWith(
                                          color: AppColors.whiteGlowColor)),
                              subtitle: Text("Only allow link posts",
                                  style: AppTextStyles.primaryTextStyle
                                      .copyWith(fontSize: 15.spMin)),
                              value: PostTypeOption.linkOnly,
                              groupValue: _selectedPostType,
                              onChanged: (PostTypeOption? value) {
                                setState(() {
                                  _selectedPostType = value!;
                                  _updateValidaty();
                                });
                                Navigator.pop(context);
                              },
                            ),
                            RadioListTile<PostTypeOption>(
                              fillColor: const MaterialStatePropertyAll(
                                  AppColors.blueColor),
                              title: Text("Text Only",
                                  style: AppTextStyles.primaryTextStyle
                                      .copyWith(
                                          color: AppColors.whiteGlowColor)),
                              subtitle: Text("Only allow text posts",
                                  style: AppTextStyles.primaryTextStyle
                                      .copyWith(fontSize: 15.spMin)),
                              value: PostTypeOption.textOnly,
                              groupValue: _selectedPostType,
                              onChanged: (PostTypeOption? value) {
                                setState(() {
                                  _selectedPostType = value!;
                                  _updateValidaty();
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                if (_selectedPostType.name != "textOnly")
                  ListTile(
                    title: Text("Image posts",
                        style: AppTextStyles.primaryTextStyle
                            .copyWith(color: AppColors.whiteGlowColor)),
                    subtitle: Text(
                        "Allow images uploaded directly to Reddit as well as links to popular image hosting sites such as Imgur",
                        style: AppTextStyles.primaryTextStyle
                            .copyWith(fontSize: 15.spMin)),
                    trailing: Switch(
                      activeColor: AppColors.whiteGlowColor,
                      activeTrackColor: AppColors.blueColor,
                      trackOutlineColor:
                          const MaterialStatePropertyAll(AppColors.switchOff),
                      inactiveTrackColor: AppColors.switchOff,
                      thumbColor: const MaterialStatePropertyAll(
                          AppColors.whiteGlowColor),
                      inactiveThumbColor: AppColors.whiteGlowColor,
                      value: imagePosts,
                      onChanged: (newValue) {
                        setState(() {
                          imagePosts = newValue;
                          _updateValidaty();
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        imagePosts = !imagePosts;
                        _updateValidaty();
                      });
                    },
                  ),
                if (_selectedPostType.name != "textOnly")
                  ListTile(
                    title: Text("Video posts",
                        style: AppTextStyles.primaryTextStyle
                            .copyWith(color: AppColors.whiteGlowColor)),
                    subtitle: Text("Allow videos uploaded directly to Reddit",
                        style: AppTextStyles.primaryTextStyle
                            .copyWith(fontSize: 15.spMin)),
                    trailing: Switch(
                      activeColor: AppColors.whiteGlowColor,
                      activeTrackColor: AppColors.blueColor,
                      trackOutlineColor:
                          const MaterialStatePropertyAll(AppColors.switchOff),
                      inactiveTrackColor: AppColors.switchOff,
                      thumbColor: const MaterialStatePropertyAll(
                          AppColors.whiteGlowColor),
                      inactiveThumbColor: AppColors.whiteGlowColor,
                      value: videoPosts,
                      onChanged: (newValue) {
                        setState(() {
                          videoPosts = newValue;
                          _updateValidaty();
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        videoPosts = !videoPosts;
                        _updateValidaty();
                      });
                    },
                  ),
                ListTile(
                  title: Text("Poll posts",
                      style: AppTextStyles.primaryTextStyle
                          .copyWith(color: AppColors.whiteGlowColor)),
                  subtitle: Text("Allow poll posts in your community",
                      style: AppTextStyles.primaryTextStyle
                          .copyWith(fontSize: 15.spMin)),
                  trailing: Switch(
                    activeColor: AppColors.whiteGlowColor,
                    activeTrackColor: AppColors.blueColor,
                    trackOutlineColor:
                        const MaterialStatePropertyAll(AppColors.switchOff),
                    inactiveTrackColor: AppColors.switchOff,
                    thumbColor: const MaterialStatePropertyAll(
                        AppColors.whiteGlowColor),
                    inactiveThumbColor: AppColors.whiteGlowColor,
                    value: pollPosts,
                    onChanged: (newValue) {
                      setState(() {
                        pollPosts = newValue;
                        _updateValidaty();
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      pollPosts = !pollPosts;
                      _updateValidaty();
                    });
                  },
                ),
              ],
            ),
          );
  }
}
