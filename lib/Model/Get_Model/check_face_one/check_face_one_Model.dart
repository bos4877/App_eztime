class check_face_one {
  String? message;
  Results? results;

  check_face_one({this.message, this.results});

  check_face_one.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    results =
        json['results'] != null ? new Results.fromJson(json['results']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.results != null) {
      data['results'] = this.results!.toJson();
    }
    return data;
  }
}

class Results {
  String? label;
  double? distance;
  String? employeeId;

  Results({this.label, this.distance, this.employeeId});

  Results.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    distance = json['distance'];
    employeeId = json['employee_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['distance'] = this.distance;
    data['employee_id'] = this.employeeId;
    return data;
  }
}
