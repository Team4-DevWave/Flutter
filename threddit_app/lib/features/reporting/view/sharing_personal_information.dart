import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/reporting/view/submit_button.dart';
import 'package:threddit_clone/models/report.dart';
// ignore: must_be_immutable
class SharePersonalInformation extends ConsumerStatefulWidget {
  SharePersonalInformation(this.report,
      {super.key,
      });
  Report report;
  @override
  _SharePersonalInformationState createState() => _SharePersonalInformationState();
}
class _SharePersonalInformationState extends ConsumerState<SharePersonalInformation> {
  String? _selectedOption;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [const Row(
              children: [
                Text('Whose personal information is it?',style: TextStyle(color: Colors.white,fontSize: 17),),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top:10.0),
              child: ListView(
                      shrinkWrap: true,
                      children: [
                        ListTile(
              title: const Text('Yours',style: TextStyle(color: Colors.white,fontSize: 17),),
              leading: Radio<String>(
                value: 'Yours',
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