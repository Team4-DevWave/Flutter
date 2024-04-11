import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/listing/view/widgets/feed_widget.dart';

class testScreenForCoummunity extends StatefulWidget {
  const testScreenForCoummunity({super.key});

  @override
  State<testScreenForCoummunity> createState() =>
      _testScreenForCoummunityState();
}

class _testScreenForCoummunityState extends State<testScreenForCoummunity> {
  String _selectedItem = 'Hot Posts';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                child: Container(
                  color: const Color.fromARGB(130, 12, 12, 12),
                  height: 40.h,
                  width: double.infinity,
                  child: Row(
                    children: [
                      const SizedBox(width: 16), // Add some spacing

                      const SizedBox(width: 8), // Add some spacing
                      DropdownButton<String>(
                        value: _selectedItem,
                        onChanged: (value) {
                          setState(() {
                            _selectedItem = value!;
                          });
                        },
                        underline: Container(), // Hide the default underline
                        dropdownColor: const Color.fromARGB(
                            206, 0, 0, 0), // Set dropdown background color
                        items: <String>[
                          'Hot Posts',
                          'New Posts',
                          'Top Posts',
                          // 'Controversial Posts',
                          // 'Rising Posts'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                Icon(_getIcon(value),
                                    color:
                                        Colors.white), // Get corresponding icon
                                const SizedBox(width: 8), // Add some spacing
                                Text(
                                  value,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 600.h, child: FeedWidget(feedID: _selectedItem))
            ],
          ),
        ),
      ),
    );
  }
}

IconData _getIcon(String item) {
  switch (item) {
    case 'Hot Posts':
      return Icons.whatshot;
    case 'New Posts':
      return Icons.fiber_new;
    case 'Top Posts':
      return Icons.star;
    // case 'Controversial Posts':
    //   return Icons.warning;
    // case 'Rising Posts':
    //  return Icons.trending_up;
    default:
      return Icons.whatshot; // Default to hot icon
  }
}
