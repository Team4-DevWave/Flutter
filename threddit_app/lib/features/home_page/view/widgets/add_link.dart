import 'package:flutter/material.dart';

class AddLinkWidget extends StatefulWidget {
  const AddLinkWidget({super.key});

  @override
  State<AddLinkWidget> createState() => _AddLinkWidgetState();
}

class _AddLinkWidgetState extends State<AddLinkWidget> {
  TextEditingController? _linkController;

  @override
  void initState() {
    _linkController = TextEditingController();
    super.initState();
  }

  void clearLink(BuildContext context){
    setState(() {
      _linkController = null;
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget content;
    if (_linkController == null) {
      content = SizedBox(width: MediaQuery.sizeOf(context).width, height: 20,);
      }


    return TextField(
        controller: _linkController,
        decoration: InputDecoration(
          labelText: "Enter link",
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ));
  }
}
