import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchCommunityScreenPage extends ConsumerStatefulWidget {
  const SearchCommunityScreenPage({super.key, required this.community});
  final String community;

  @override
  _SearchCommunityScreenPageState createState() =>
      _SearchCommunityScreenPageState();
}

class _SearchCommunityScreenPageState
    extends ConsumerState<SearchCommunityScreenPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isFocused = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isFocused) {
      _isFocused = true;
      // Focus the search field when the screen is loaded
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  @override
  void initState() {
    super.initState();
    //didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        
          body: Column(
            children: [
              Padding(
                padding:EdgeInsets.symmetric(vertical:16.sp,horizontal: 8.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            colorScheme: Theme.of(context).colorScheme.copyWith(
                                primary: Colors.white, secondary: Colors.white)),
                        child: TextField(
                          controller: _searchController,
                          autofocus: true,
                          decoration: InputDecoration(
                            fillColor: const Color.fromARGB(168, 34, 34, 34),
                            filled: true,
                            hintText: 'Search...',
                            hintStyle: const TextStyle(color: Colors.grey),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.cancel_outlined),
                              onPressed: () {
                                _searchController.clear();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        style:
                            TextStyle(color: Color.fromARGB(100, 255, 255, 255)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height:2.h),
              Container(
                width: double.infinity,
                color: const Color.fromARGB(168, 34, 34, 34),
                child: ListTile(
                  title: Text('Best of r/${widget.community}',
                      style: const TextStyle(fontSize: 15, color: Colors.white)),
                      leading: const Icon(Icons.rocket),
                  onTap: () {
                    // Handle item tap
                  },
                ),
              ),
              Container(
                width: double.infinity,
                color: const Color.fromARGB(168, 34, 34, 34),
                child: ListTile(
                  title: Text('New in r/${widget.community}',
                      style: const TextStyle(fontSize: 15, color: Colors.white)),
                      leading: const Icon(Icons.new_releases_outlined),
                  onTap: () {
                    // Handle item tap
                  },
                ),
              ),
            ],
          ),
        ),
      
    );
  }
}
