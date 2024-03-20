import 'package:flutter/material.dart';

class SaveChanges extends StatefulWidget {
  const SaveChanges({super.key});

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
              onPressed: () {},
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
