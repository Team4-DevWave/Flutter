import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    return MediaQuery(
      data: newMediaQueryData,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Increase text size"),
        ),
        body: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Override device settings"),
              titleTextStyle: AppTextStyles.primaryTextStyle,
              trailing: Switch(
                value: ref.watch(enableResizeProvider),
                onChanged: (value) {
                  setState(() {
                    ref
                        .watch(enableResizeProvider.notifier)
                        .update((state) => value);
                    ref.watch(sliderProvider.notifier).update((state) => 1.0);
                  });
                },
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsetsDirectional.only(bottom: 10),
              alignment: Alignment.bottomCenter,
              child: Slider(
                min: 1,
                max: 2,
                divisions: 3,
                value: ref.watch(sliderProvider),
                onChanged: ref.watch(enableResizeProvider)
                    ? (value) {
                        setState(() {
                          ref
                              .watch(sliderProvider.notifier)
                              .update((state) => value);
                          redditTheme.copyWith(
                              textTheme: redditTheme.textTheme.apply(
                            fontSizeFactor: ref.watch(sliderProvider),
                          ));
                          
                        });
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
