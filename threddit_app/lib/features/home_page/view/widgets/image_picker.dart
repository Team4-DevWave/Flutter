// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';

// class PickImage extends StatelessWidget {
//   PickImage({super.key, required this.imagesList});
//   List<XFile>?imagesList;

//   @override
//   Widget build(BuildContext context) {
//     Widget content = SizedBox(
//       child:  const Text("no image selected"),
//     );
//     if(imagesList!.isNotEmpty){
//     content = SizedBox(
//       height: 250,
//       width: double.maxFinite,
//       child: ListView.builder(
//           keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//           scrollDirection: Axis.horizontal,
//           itemCount: imagesList!.length,
//           itemBuilder: (context, index) {
//             return Image.file(
//               File(imagesList![index].path),
//               width: MediaQuery.of(context).size.width - 8,
//               fit: BoxFit.contain,
//             );
//           }),
//     );
//     }

//     return content;
//   }
// }
