import 'package:flutter/material.dart';

/// A stateless widget that creates a new page with a `WebView`.
///
/// The `WebViewPage` takes a URL as a parameter and displays the web page
/// at that URL in a `WebView` widget. The `WebView` is placed in the body
/// of a `Scaffold`, and the `Scaffold` also includes an `AppBar` with a title.
///
/// The `WebViewPage` widget is typically used to open web pages from within the app.
class WebViewPage extends StatelessWidget {
  /// The URL of the web page to display in the `WebView`.
  final String url;

  /// Creates a `WebViewPage` widget.
  ///
  /// The [url] parameter must not be null.
  const WebViewPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('WebView'),
        ),
        body: WebViewPage(
          url: url,
        ));
  }
}
