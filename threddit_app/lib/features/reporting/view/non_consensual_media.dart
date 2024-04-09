import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/reporting/view/submit_button.dart';
import 'package:threddit_clone/models/report.dart';
// ignore: must_be_immutable
class NonConsensualMedia extends ConsumerStatefulWidget {
  NonConsensualMedia(this.report,
      {super.key,
      });
  Report report;
  @override
  _NonConsensualMediaState createState() => _NonConsensualMediaState();
}
class _NonConsensualMediaState extends ConsumerState<NonConsensualMedia> {
  String? _selectedOption;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [const Row(
              children: [
                Text('Who is the non-consensual intimate media of?',style: TextStyle(color: Colors.white,fontSize: 17),),
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