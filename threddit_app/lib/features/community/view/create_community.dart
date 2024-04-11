import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:threddit_clone/app/route.dart";
import "package:threddit_clone/features/community/view%20model/community_provider.dart";
import "package:threddit_clone/theme/colors.dart";

 enum CommunityType { Restricted, Public, Private }
  CommunityType _parseCommunityType(String? type) {
    switch (type) {
      case 'Restricted':
        return CommunityType.Restricted;
      case 'Public':
        return CommunityType.Public;
      case 'Private':
        return CommunityType.Private;
      default:
        return CommunityType.Public;
    }
  }

class CreateCommunity extends ConsumerStatefulWidget {
  const CreateCommunity({super.key, required this.uid});
  final String uid;

  @override
  _CreateCommunityState createState() => _CreateCommunityState();
}

class _CreateCommunityState extends ConsumerState<CreateCommunity> {
  final TextEditingController _communityNameController =
      TextEditingController();
  String communityType = 'Public';
  // ignore: unused_field
  CommunityType _type = CommunityType.Public;
  bool is18plus = false;

  @override
  void dispose() {
    _communityNameController.dispose();
    super.dispose();
  }

  void createCommunity() async {
    if (_communityNameController.text == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please enter a community name.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }
    final createCommunityFuture = ref.watch(createCommunityProvider(
        CreateCommunityParams(
            name: _communityNameController.text,
            nsfw: is18plus,
            type: communityType,
            uid: widget.uid)));
    createCommunityFuture;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: AppColors.backgroundColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteClass.mainLayoutScreen);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: const Color.fromARGB(108, 255, 255, 255),
              height: 0.25,
            ),
          ),
          title: const Text(
            "Create a community",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Community name',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 65,
                child: TextField(
                  controller: _communityNameController,
                  style: const TextStyle(
                      color: Color.fromARGB(171, 255, 255, 255)),
                  decoration: const InputDecoration(
                    filled: true,
                    prefixText: 'r/',
                    hintText: 'Community_name',
                    hintStyle:
                        TextStyle(color: Color.fromARGB(104, 255, 255, 255)),
                    fillColor: Color.fromARGB(210, 36, 36, 36),
                  ),
                  maxLength: 21,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  'Community type',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              DropdownButton<String>(
                value: communityType,
                dropdownColor: AppColors.backgroundColor,
                onChanged: (value) {
                  setState(() {
                    communityType = value!;
                    if (value == 'Public') {
                      _type = CommunityType.Public;
                    } else if (value == 'Private') {
                      _type = CommunityType.Private;
                    } else {
                      _type = CommunityType.Restricted;
                    }
                  });
                },
                style: const TextStyle(color: Colors.white),
                items: <String>['Public', 'Private', 'Restricted']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  );
                }).toList(),
              ),
              if (communityType == 'Public')
                const Text(
                  'Anyone can view, post, and comment to this community',
                  style: TextStyle(
                      color: Color.fromARGB(122, 255, 255, 255), fontSize: 13),
                ),
              if (communityType == 'Private')
                const Text(
                  'Only approved users can view and submit to this community',
                  style: TextStyle(
                      color: Color.fromARGB(122, 255, 255, 255), fontSize: 13),
                ),
              if (communityType == 'Restricted')
                const Text(
                  'Anyone can view this community, but only approved users can post',
                  style: TextStyle(
                      color: Color.fromARGB(122, 255, 255, 255), fontSize: 13),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  children: [
                    const Text(
                      '18+ Community',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Switch(
                            value: is18plus,
                            activeColor: const Color.fromARGB(255, 39, 78, 137),
                            thumbColor: const MaterialStatePropertyAll<Color>(
                                Colors.white),
                            inactiveTrackColor:
                                const Color.fromARGB(255, 57, 57, 57),
                            onChanged: (bool value) {
                              setState(() {
                                is18plus = value;
                              });
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: FilledButton(
                        onPressed: (){createCommunity;
                         Navigator.pop(context);
                         Navigator.pushNamed(
                              context, RouteClass.communityScreen,arguments:{
                                'uid': widget.uid,
                                'id':"Sample Subreddit"
                              });
                             
                        },
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(Colors.blue)),
                        child: const Text(
                          'Create Community',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
