import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
//import 'package:threddit_clone/features/reporting/view/breaks_community_rules.dart';
import 'package:threddit_clone/features/reporting/view/copyright_violation.dart';
import 'package:threddit_clone/features/reporting/view/harassment.dart';
import 'package:threddit_clone/features/reporting/view/impersonation.dart';
import 'package:threddit_clone/features/reporting/view/minor_abuse.dart';
import 'package:threddit_clone/features/reporting/view/non_consensual_media.dart';
import 'package:threddit_clone/features/reporting/view/thanks_for_your_report.dart';
import 'package:threddit_clone/features/reporting/view/sharing_personal_information.dart';
import 'package:threddit_clone/features/reporting/view/spam.dart';
import 'package:threddit_clone/features/reporting/view/threat_bottom_sheet.dart';
import 'package:threddit_clone/features/reporting/view/trademark_violation.dart';
import 'package:threddit_clone/models/data.dart';
import 'package:threddit_clone/models/report.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class ReportBottomSheet extends ConsumerStatefulWidget {
   ReportBottomSheet(
      {super.key,
      required this.reportedID,
      required this.type,
      required this.userID});
  final reportedID;
  final type;
  final userID;
late Report report = Report(
      reportedID: reportedID,
      type: type,
      additionalInfo: 'NA',
      ruleReason: 'NA', 
      userID: 'userID',
    );
  @override
  _ReportBottomSheetState createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends ConsumerState<ReportBottomSheet> {
  
  String? selectedReportReason;
  Widget getReportSheetContent(String reason, Report report) {
    switch (reason) {
      case 'Breaks community rules':
        return ThanksForReport(report);
        //TODO to be changed 
      case 'Harassment':
        return Harassment(report);
      case 'Threatning Violence':
        return threatBottomSheet(report);
      case 'Hate':
        return ThanksForReport(report);
      case 'Minor abuse or sexualization':
        return MinorAbuse(report);

      case 'Sharing personal information':
        return SharePersonalInformation(report);

      case 'Non-consensual intmate media':
        return NonConsensualMedia(report);

      case 'Prohibited transaction':
        return ThanksForReport(report);

      case 'Impersonation':
        return Impersonation(report);

      case 'Copyright violation':
        return CopyrightViolation(report);

      case 'Trademark violation':
        return TrademarkViolation(report);

      case 'Self-harm or suicide':
        return ThanksForReport(report);

      case 'Spam':
        return Spam(report);

      default:
        return ThanksForReport(report);
    }
  }

  void submitReport(String reason) async {
    if (selectedReportReason == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please choose the reason for the report.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }
Navigator.of(context).pop();
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      backgroundColor: AppColors.backgroundColor,
      builder: (context) {
         widget.report.setRuleReason(reason);
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                color: AppColors.backgroundColor,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Submit a report',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
             
              getReportSheetContent(reason,widget.report)
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            color: AppColors.backgroundColor,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Submit a report',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Thanks for looking out for yourself and your fellow redditors by reporting things that break the rules. Let us know what is happening, and we will look into it.',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    Wrap(
                      spacing: 8.0,
                      children: reportReasons.map((reason) {
                        return OutlinedButton(
                          onPressed: () {
                            setState(() {
                              selectedReportReason =
                                  reason == selectedReportReason
                                      ? null
                                      : reason;
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              reason == selectedReportReason
                                  ? Colors.blue.withOpacity(0.1)
                                  : Colors.transparent,
                            ),
                          ),
                          child: Text(
                            reason,
                            style: TextStyle(
                              color: reason == selectedReportReason
                                  ? Colors.blue
                                  : const Color.fromARGB(101, 255, 255, 255),
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13),
                          children: [
                            const TextSpan(
                              text:
                                  'Not sure if something is breaking the rules? ',
                            ),
                            TextSpan(
                              text: 'Review Reddit\'s Content policy',
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  final Uri url = Uri.parse(
                                      'https://www.redditinc.com/policies/content-policy');
                                  Future<void> launchUrlContentPolicy() async {
                                    if (!await launchUrl(url)) {
                                      throw Exception('Could not launch $url');
                                    }
                                  }

                                  launchUrlContentPolicy();
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            submitReport(selectedReportReason!);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color?>(
                              selectedReportReason == null
                                  ? const Color.fromARGB(255, 6, 38, 64)
                                  : Colors.blue,
                            ),
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
