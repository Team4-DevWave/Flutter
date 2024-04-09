import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/theme/theme.dart';

final sliderProvider = StateProvider<double>((ref) {
  return 1.0;
});
final enableResizeProvider = StateProvider<bool>((ref) {
  return false;
});

class TextSizeScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TextSizeScreenState();
}

class _TextSizeScreenState extends ConsumerState<TextSizeScreen> {
  bool enabled = false;

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);

    final newMediaQueryData = mediaQueryData.copyWith(
      textScaler: TextScaler.linear(ref.watch(sliderProvider)),
    );
    Future<bool?> getStatus() async {
      bool? status = await ref.watch(textSizeProvider.notifier).getFontOption();
      if (status != null) {
        ref.watch(enableResizeProvider.notifier).update((state) => status);
      } else {
        ref.watch(enableResizeProvider.notifier).update((state) => false);
      }
      return ref.watch(textSizeProvider.notifier).getFontOption();
    }

    Future<double?> getValue() async {
      double? status = await ref.watch(textSizeProvider.notifier).getTextSize();
      if (status != null) {
        ref.watch(sliderProvider.notifier).update((state) => status);
      } else {
        ref.watch(sliderProvider.notifier).update((state) => 1.0);
      }
      return ref.watch(textSizeProvider.notifier).getTextSize();
    }

    return MediaQuery(
      data: newMediaQueryData,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Increase text size"),
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<bool?>(
                future: getStatus(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text("Override device settings"),
                          titleTextStyle: AppTextStyles.primaryTextStyle,
                          trailing: Switch(
                            value: ref.watch(enableResizeProvider),
                            onChanged: (value) {
                              setState(() {
                                saveFontOption(value);
                                ref
                                    .watch(enableResizeProvider.notifier)
                                    .update((state) => value);
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<double?>(
                future: getValue(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Column(
                      children: [
                        const Spacer(),
                        Container(
                          padding: const EdgeInsetsDirectional.only(bottom: 10),
                          alignment: Alignment.bottomCenter,
                          child: Slider(
                            min: 1,
                            max: 1.75,
                            divisions: 3,
                            value: ref.watch(sliderProvider),
                            onChanged: ref.watch(enableResizeProvider)
                                ? (value) {
                                    setState(() {
                                      saveTextSize(value);
                                      ref
                                          .watch(sliderProvider.notifier)
                                          .update((state) => value);
                                    });
                                  }
                                : null,
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
