import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/reporting/view%20model/report_provider.dart';
import 'package:threddit_clone/models/report.dart';

class ThanksForReport extends ConsumerStatefulWidget {
  const ThanksForReport( this.report,{
    super.key,
   
  });
final Report report;
  @override
  _ThanksForReportState createState() => _ThanksForReportState();
}

class _ThanksForReportState extends ConsumerState<ThanksForReport> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(
                Icons.verified_rounded,
                color: Colors.blue,
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Row(
            children: [
              Text(
                'Thanks for your report',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Thanks again for your report and for looking out for yourself and your fellow redditors. Your reporting helps make Reddit a better, safer, and more welcomin place for everyone; and it means a lot to us.',
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          const SizedBox(
            height: 20,
          ),
          FilledButton(
            onPressed: () async{
              Navigator.of(context).pop();
              await ref.read(reportSubmissionProvider(widget.report).future);
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue)),
            child: const Text('Done'),
          )
        ],
      ),
    );
  }
}
