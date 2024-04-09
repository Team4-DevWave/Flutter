import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/reporting/view/submit_button.dart';
import 'package:threddit_clone/models/report.dart';

// ignore: must_be_immutable
class MinorAbuse extends ConsumerStatefulWidget {
  MinorAbuse(this.report,{
    super.key,
  });
Report report;
  @override
  _MinorAbuseState createState() => _MinorAbuseState();
}

class _MinorAbuseState extends ConsumerState<MinorAbuse> {
  String? _selectedOption;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
              const Text(
                'What type of minor abuse or sexualization is this?',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            
          
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  title: const Text(
                    'Sexual or aggressive content',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  leading: Radio<String>(
                    value: 'Sexual or aggressive content',
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
                  title: const Text('Predatory or inappropriate behavior',
                      style: TextStyle(color: Colors.white, fontSize: 17)),
                  leading: Radio<String>(
                    value: 'Predatory or inappropriate behavior',
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
                  title: const Text('Content involving physical or emotional abuse or neglect',
                      style: TextStyle(color: Colors.white, fontSize: 17)),
                  leading: Radio<String>(
                    value: 'Content involving physical or emotional abuse or neglect',
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
          const SizedBox(
            height: 20,
          ),
          SubmitButton(report: widget.report),
        ],
      ),
    );
  }
}
