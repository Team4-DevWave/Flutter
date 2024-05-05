///Failure class is a data class
///this data class has [message] paramter
///where this [message] is used to store the error [message]
///error [message] stored is commonly used for increasing user experience
///by showing the user the reason of the failure
///some time is used in debugging to show the developer the error
class Failure {
  Failure(this.message);
  final String message;
}
