import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:threddit_clone/app/route.dart";
import "package:threddit_clone/models/community.dart";
import "package:threddit_clone/features/community/view%20model/community_provider.dart";
import "package:threddit_clone/theme/colors.dart";

///this class resembles the create community screen 
///it is used to create a new community
///the createCommunity function is called when the create community button is pressed
///the createCommunity function is used to create a new community by calling the createCommunity function from the community provider
/// the createCommunity function takes the name, nsfw and type of the community as it's parameters
/// it then calls the createCommunity function from the community provider
/// the createCommunity function returns a Future that is used to create the community
/// if the community is created successfully, the user is navigated to the community screen
/// if the community is not created successfully, an error message is displayed

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

  void createCommunity(BuildContext context) async {
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

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dialog from being dismissed
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Creating community...'),
            ],
          ),
        );
      },
    );

    try {
      final int communityCreationResult =
          await ref.read(createCommunityProvider(
        CreateCommunityParams(
          name: _communityNameController.text,
          nsfw: is18plus,
          type: communityType.toLowerCase(),
        ),
      ).future);

      // Close the loading indicator dialog
      Navigator.pop(context);

      if (communityCreationResult == 201) {
        // Community created successfully
        Navigator.pop(context);
        Navigator.pushNamed(context, RouteClass.communityScreen, arguments: {
          'id': _communityNameController.text,
          'uid': widget.uid
        });
      } else if (communityCreationResult == 409) {
        // Community already exists
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Community already exists'),
          ),
        );
      } else {
        // Failed to create community
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create community'),
          ),
        );
      }
    } catch (e) {
      // Handle error
      print('Error creating community: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while creating the community'),
        ),
      );
    }
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
                        onPressed: () => createCommunity(context),
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
