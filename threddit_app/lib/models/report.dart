class Report {
  final String reportedID;
  final String type;
  String additionalInfo;
  String ruleReason;
  final String userID;

  Report({
    required this.reportedID,
    required this.type,
    required this.additionalInfo,
    required this.ruleReason,
    required this.userID,
  });
  setAdditionalInfo(String info) {
    additionalInfo = info;
  }
  setRuleReason(String reason) {
    ruleReason = reason;
  }

  Map<String, dynamic> toJson() {
    return {
      'reportedID': reportedID,
      'type': type,
      'additional_info': additionalInfo,
      'rule_reason': ruleReason,
      'userID': userID,
    };
  }
}
