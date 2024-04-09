import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/reporting/model/report_repository.dart';
import 'package:threddit_clone/models/report.dart';


final reportRepositoryProvider = Provider((ref) => ReportRepository());

final reportSubmissionProvider = FutureProvider.family<void, Report>((ref, report) async {
  final reportRepository = ref.read(reportRepositoryProvider);
  await reportRepository.submitReport(reportedID: report.reportedID, type: report.type, additionalInfo: report.additionalInfo, ruleReason: report.ruleReason, userID: report.userID);
});

