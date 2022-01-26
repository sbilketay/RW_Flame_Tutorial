class ServerResponse {
  String? error;
  String? result;

  ServerResponse({this.result, this.error});

  factory ServerResponse.fromJson(Map<String, dynamic> json) {
    return ServerResponse(
      error: json['error'].toString(),
      result: json['result'].toString(),
    );
  }
}
