import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/reporting/model/report_repository.dart';
import 'package:threddit_clone/models/report.dart';

/// This provider is used to provide the report repository to the widgets that need it
/// The report repository is used to submit a report
/// The submitReport function takes the reportedID, type, additionalInfo, ruleReason and userID as it's parameters
/// The submitReport function returns a Future that is used to submit the report

final reportRepositoryProvider = Provider((ref) => ReportRepository());

final reportSubmissionProvider = FutureProvider.family<void, Report>((ref, report) async {
  final reportRepository = ref.read(reportRepositoryProvider);
  await reportRepository.submitReport(reportedID: report.reportedID, type: report.type, additionalInfo: report.additionalInfo, ruleReason: report.ruleReason, userID: report.userID);
});

