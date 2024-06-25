class get_attendent_employee_one_model {
  List<Data>? data;

  get_attendent_employee_one_model({this.data});

  get_attendent_employee_one_model.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? shiftDate;
  String? checkinTime;
  String? checkoutTime;
  String? isWork;
  String? late;

  Data(
      {this.shiftDate,
      this.checkinTime,
      this.checkoutTime,
      this.isWork,
      this.late});

  Data.fromJson(Map<String, dynamic> json) {
    shiftDate = json['shift_date'];
    checkinTime = json['checkin_time'];
    checkoutTime = json['checkout_time'];
    isWork = json['is_work'];
    late = json['late'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shift_date'] = this.shiftDate;
    data['checkin_time'] = this.checkinTime;
    data['checkout_time'] = this.checkoutTime;
    data['is_work'] = this.isWork;
    data['late'] = this.late;
    return data;
  }
}
