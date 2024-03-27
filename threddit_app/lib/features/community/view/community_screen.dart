import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/commenting/model/community.dart';
import 'package:threddit_clone/theme/photos.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  final String name;
  final Community community;
  const CommunityScreen({Key? key, required this.name, required this.community})
      : super(key: key);

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  String _selectedItem = 'Hot Posts'; // Initial selected item

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 60,
              floating: true,
              snap: true,
              flexibleSpace: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      Photos.snoLogo,
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(widget.community.avatar),
                            radius: 30,
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'r/${widget.community.name}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${widget.community.members.length} members',
                                style: const TextStyle(
                                  color: Color.fromARGB(108, 255, 255, 255),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SizedBox(
                            width: 75,
                            height: 33,
                            child: FilledButton(
                              onPressed: () {},
                              style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          Color.fromARGB(255, 8, 46, 77))),
                              child: const Text(
                                'Join',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${widget.community.description}',
                      style: const TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            SizedBox(
              child: Container(
                color: const Color.fromARGB(130, 12, 12, 12),
                height: 40,
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
                      dropdownColor: Color.fromARGB(
                          206, 0, 0, 0), // Set dropdown background color
                      items: <String>[
                        'Hot Posts',
                        'New Posts',
                        'Top Posts',
                        'Controversial Posts',
                        'Rising Posts'
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
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String item) {
    switch (item) {
      case 'Hot Posts':
        return Icons.whatshot;
      case 'New Posts':
        return Icons.fiber_new;
      case 'Top Posts':
        return Icons.star;
      case 'Controversial Posts':
        return Icons.warning;
      case 'Rising Posts':
        return Icons.trending_up;
      default:
        return Icons.whatshot; // Default to hot icon
    }
  }
}
