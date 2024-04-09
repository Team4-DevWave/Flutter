import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/reporting/view/submit_button.dart';
import 'package:threddit_clone/models/report.dart';
// ignore: must_be_immutable
class Spam extends ConsumerStatefulWidget {
  Spam(this.report,
      {super.key,
      });
  Report report;
  @override
  _SpamState createState() => _SpamState();
}
class _SpamState extends ConsumerState<Spam> {
  String? _selectedOption;
    @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [const Row(
              children: [
                Text('What type of spam is this?',style: TextStyle(color: Colors.white,fontSize: 17),),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top:10.0),
              child: ListView(
                      shrinkWrap: true,
                      children: [
                        ListTile(
              title: const Text('Link farming',style: TextStyle(color: Colors.white,fontSize: 17),),
              leading: Radio<String>(
                value: 'Link farming',
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
              title: const Text('Unsolicited messaging',style: TextStyle(color: Colors.white,fontSize: 17)),
              leading: Radio<String>(
                value: 'Unsolicited messaging',
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
              title: const Text('Excessive posts or comments in a community',style: TextStyle(color: Colors.white,fontSize: 17)),
              leading: Radio<String>(
                value: 'Excessive posts or comments in a community',
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
              title: const Text('Posting harmful links (malware)',style: TextStyle(color: Colors.white,fontSize: 17)),
              leading: Radio<String>(
                value: 'Posting harmful links (malware)',
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
              title: const Text('Harmful bots',style: TextStyle(color: Colors.white,fontSize: 17)),
              leading: Radio<String>(
                value: 'Harmful bots',
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
              title: const Text('Other',style: TextStyle(color: Colors.white,fontSize: 17)),
              leading: Radio<String>(
                value: 'Other',
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