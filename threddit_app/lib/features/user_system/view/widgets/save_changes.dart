import 'package:flutter/material.dart';

/// SaveChanges class responisble for the save/cancel button in Update Email and Change
/// Password takes the function it's going to call when save is Pressed as a
/// parameter.
class SaveChanges extends StatefulWidget {
  final VoidCallback saveChanges;
  const SaveChanges({super.key, required this.saveChanges});

  @override
  State<SaveChanges> createState() => _SaveChangesState();
}

class _SaveChangesState extends State<SaveChanges> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: const Color.fromARGB(255, 253, 253, 253),
              ),
              child: const Text("Cancel"),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: widget.saveChanges,
              style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor: const Color.fromARGB(255, 0, 140, 255)),
              child: const Text("Save"),
            ),
          ),
        ],
      ),
    );
  }
}
