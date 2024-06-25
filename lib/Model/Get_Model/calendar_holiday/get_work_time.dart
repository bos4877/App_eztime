class get_worktime_model {
  List<Data>? data;

  get_worktime_model({this.data});

  get_worktime_model.fromJson(Map<String, dynamic> json) {
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
  bool? isweekend;
  String? description;
  String? start;
  String? end;

  Data(
      {this.shiftDate, this.isweekend, this.description, this.start, this.end});

  Data.fromJson(Map<String, dynamic> json) {
    shiftDate = json['shift_date'];
    isweekend = json['isweekend'];
    description = json['description'];
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shift_date'] = this.shiftDate;
    data['isweekend'] = this.isweekend;
    data['description'] = this.description;
    data['start'] = this.start;
    data['end'] = this.end;
    return data;
  }
}
