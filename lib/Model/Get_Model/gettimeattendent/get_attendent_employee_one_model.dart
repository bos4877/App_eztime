class get_attendent_employee_one_model {
  List<AttendanceData>? attendanceData;

  get_attendent_employee_one_model({this.attendanceData});

  get_attendent_employee_one_model.fromJson(Map<String, dynamic> json) {
    if (json['attendanceData'] != null) {
      attendanceData = <AttendanceData>[];
      json['attendanceData'].forEach((v) {
        attendanceData!.add(new AttendanceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.attendanceData != null) {
      data['attendanceData'] =
          this.attendanceData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AttendanceData {
  int? rowId;
  String? attendanceId;
  String? employeeNo;
  String? status;
  int? late;
  String? timeInput;
  String? createAt;
  String? reslatitude;
  String? lat;
  String? lng;
  String? companyId;

  AttendanceData(
      {this.rowId,
      this.attendanceId,
      this.employeeNo,
      this.status,
      this.late,
      this.timeInput,
      this.createAt,
      this.reslatitude,
      this.lat,
      this.lng,
      this.companyId});

  AttendanceData.fromJson(Map<String, dynamic> json) {
    rowId = json['row_id'];
    attendanceId = json['attendance_id'];
    employeeNo = json['employee_no'];
    status = json['status'];
    late = json['late'];
    timeInput = json['time_input'];
    createAt = json['create_at'];
    reslatitude = json['reslatitude'];
    lat = json['lat'];
    lng = json['lng'];
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['row_id'] = this.rowId;
    data['attendance_id'] = this.attendanceId;
    data['employee_no'] = this.employeeNo;
    data['status'] = this.status;
    data['late'] = this.late;
    data['time_input'] = this.timeInput;
    data['create_at'] = this.createAt;
    data['reslatitude'] = this.reslatitude;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['company_id'] = this.companyId;
    return data;
  }
}
