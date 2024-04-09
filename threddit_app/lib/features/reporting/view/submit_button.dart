import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/reporting/view%20model/report_provider.dart';
import 'package:threddit_clone/models/report.dart';

class SubmitButton extends ConsumerStatefulWidget {
  const SubmitButton({super.key,required this.report});
    final Report report;
  @override
  _SubmitButtonState createState() => _SubmitButtonState();
}

class _SubmitButtonState extends ConsumerState<SubmitButton> {
  @override
  Widget build(BuildContext context) {
    bool iscontainingreason;
    widget.report.additionalInfo=='NA'?iscontainingreason=false:iscontainingreason=true;
    return FilledButton(
      onPressed: ()async {
        if(iscontainingreason)
        {
          Navigator.of(context).pop();
          await ref.read(reportSubmissionProvider(widget.report).future);
        }
        else 
        {
          showDialog(
            context: context,
            builder: (ctx)=>AlertDialog(
              title: const Text('Error'),
              content: const Text('Please select one of the options.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      },
      style:
          ButtonStyle(backgroundColor: MaterialStateProperty.all(iscontainingreason?Colors.blue:const Color.fromARGB(255, 13, 38, 81))),
      child: Text('Submit'),
    );
  }
}
