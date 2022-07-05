class Success {
  String? message;
  dynamic data;

  Success(this.message, this.data);
}

class Failure {
  String? message;
  Map<String, dynamic> data = {};

  Failure(this.message, this.data);
}
