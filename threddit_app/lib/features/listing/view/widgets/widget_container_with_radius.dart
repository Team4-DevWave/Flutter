import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The `widget_container_with_radius.dart` file defines a stateless widget `AddRadiusBoarder`
/// that is used to wrap a child widget with a container that has a border and a circular border radius.

/// The `AddRadiusBoarder` widget takes a `Widget` object as a parameter through its constructor.
/// This `Widget` object represents the child widget that will be wrapped by the `Container`.

/// The `build` method of the `AddRadiusBoarder` class returns a `Container` widget that wraps
/// the child widget. The `Container` is decorated with a border and a circular border radius
/// using the `BoxDecoration` class. The color and width of the border are specified, and the
/// radius of the circular border is set to 15.

/// The `Container` also has symmetric horizontal and vertical padding to provide space around
/// the child widget. The child widget is passed to the `child` property of the `Container`.

/// The `AddRadiusBoarder` widget is designed to be flexible and reusable, allowing it to be
/// used in any part of the application that requires a container with a border and a circular
/// border radius.

// ignore: must_be_immutable
class AddRadiusBoarder extends StatelessWidget {
  Widget childWidget;
  AddRadiusBoarder({super.key, required this.childWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(143, 255, 255, 255),
          width: 2.w,
        ),
        borderRadius: BorderRadius.circular(
            15), // Add this line to make the border circular
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: childWidget,
    );
  }
}
