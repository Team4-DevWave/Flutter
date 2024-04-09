import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/reporting/view/submit_button.dart';
import 'package:threddit_clone/models/report.dart';
// ignore: must_be_immutable
class Harassment extends ConsumerStatefulWidget {
  Harassment(this.report,
      {super.key,
      });
  Report report;
  @override
  _HarassmentState createState() => _HarassmentState();
}
class _HarassmentState extends ConsumerState<Harassment> {
 String? _selectedOption;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [const Row(
              children: [
                Text('Who is this harassment towards?',style: TextStyle(color: Colors.white,fontSize: 17),),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top:10.0),
              child: ListView(
                      shrinkWrap: true,
                      children: [
                        ListTile(
              title: const Text('You',style: TextStyle(color: Colors.white,fontSize: 17),),
              leading: Radio<String>(
                value: 'You',
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value;
                    widget.report.additionalInfo=_selectedOption!;
                  });
                },
              ),
                        ),
                        ListTile(
              title: const Text('Someone else',style: TextStyle(color: Colors.white,fontSize: 17)),
              leading: Radio<String>(
                value: 'Someone else',
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value;
                    widget.report.additionalInfo=_selectedOption!;
                  });
                },
              ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 20,),
          SubmitButton(report: widget.report),
            ],
      ),
    );
  }
}