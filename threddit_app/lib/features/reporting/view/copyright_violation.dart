import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/reporting/view/submit_button.dart';
import 'package:threddit_clone/models/report.dart';
// ignore: must_be_immutable
class CopyrightViolation extends ConsumerStatefulWidget {
  CopyrightViolation(
    this.report,
      {super.key,
      });
  Report report;
  @override
  _CopyrightViolationState createState() => _CopyrightViolationState();
}
class _CopyrightViolationState extends ConsumerState<CopyrightViolation> {
 String? _selectedOption;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [const Row(
              children: [
                Text('Whose copyright is it?',style: TextStyle(color: Colors.white,fontSize: 17),),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top:10.0),
              child: ListView(
                      shrinkWrap: true,
                      children: [
                        ListTile(
              title: const Text('Yours or an individual or entity you represent',style: TextStyle(color: Colors.white,fontSize: 17),),
              leading: Radio<String>(
                value: 'Yours or an individual or entity you represent',
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
              title: const Text('Someone else\'s',style: TextStyle(color: Colors.white,fontSize: 17)),
              leading: Radio<String>(
                value: 'Someone else\'s',
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