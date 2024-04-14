/// Function for setting all permissions to true given that full permission is
/// selected
void setAllPermissions(bool? value, Map<String, bool?> modPermissions) {
  modPermissions.forEach((key, _) {
    modPermissions[key] = value;
  });
}

/// Functions to check if all permissions are true to check the full permissions
/// or if any permissions false and set full permissions to false.
///
bool checkPermissions(Map<String, bool?> modPermissions) {
  if (modPermissions.values.every((value) => value == true)) {
    return true;
  } else {
    return false;
  }
}

/// Validator function
/// Checks for the necessary checks and if not true returns a number
/// 1 for rule not chose
/// 2 for ban length == 0(custom ban and the length = 0)
/// 3 for name is empty
/// 0 if all checks pass
int validateBan(String name, String rule, String length) {
  if (rule == "Select a rule") {
    return 1;
  } else if (length == "0") {
    return 2;
  } else if (name == "") {
    return 3;
  } else {
    return 0;
  }
}

/// Validator function
/// Checks for the necessary checks and if not true returns a number
/// 3 for name is empty
/// 0 if all checks pass
int validateApprove(String name) {
  if (name == "") {
    return 3;
  } else {
    return 0;
  }
}
