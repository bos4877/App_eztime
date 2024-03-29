class get_attendent_employee_month_Modedl {
  List<AttendanceData>? attendanceData;

  get_attendent_employee_month_Modedl({this.attendanceData});

  get_attendent_employee_month_Modedl.fromJson(Map<String, dynamic> json) {
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
  String? timeId;
  String? timeOut;
  String? checkinTime;
  String? checkoutTime;
  String? latIn;
  String? latOut;
  String? lngIn;
  String? lngOut;

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
      this.companyId,
      this.timeId,
      this.timeOut,
      this.checkinTime,
      this.checkoutTime,
      this.latIn,
      this.latOut,
      this.lngIn,
      this.lngOut});

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
    timeId = json['time_id'];
    timeOut = json['time_out'];
    checkinTime = json['checkin_time'];
    checkoutTime = json['checkout_time'];
    latIn = json['lat_in'];
    latOut = json['lat_out'];
    lngIn = json['lng_in'];
    lngOut = json['lng_out'];
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
    data['time_id'] = this.timeId;
    data['time_out'] = this.timeOut;
    data['checkin_time'] = this.checkinTime;
    data['checkout_time'] = this.checkoutTime;
    data['lat_in'] = this.latIn;
    data['lat_out'] = this.latOut;
    data['lng_in'] = this.lngIn;
    data['lng_out'] = this.lngOut;
    return data;
  }
}
