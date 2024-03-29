class calendar_holiday_Model {
  List<Data>? data;
  int? count;

  calendar_holiday_Model({this.data, this.count});

  calendar_holiday_Model.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    return data;
  }
}

class Data {
  int? rowId;
  String? holidayId;
  String? holidayName;
  String? color;
  String? description;
  String? createdAt;
  String? date;
  String? calendarId;

  Data(
      {this.rowId,
      this.holidayId,
      this.holidayName,
      this.color,
      this.description,
      this.createdAt,
      this.date,
      this.calendarId});

  Data.fromJson(Map<String, dynamic> json) {
    rowId = json['row_id'];
    holidayId = json['holiday_id'];
    holidayName = json['holiday_name'];
    color = json['color'];
    description = json['description'];
    createdAt = json['created_at'];
    date = json['date'];
    calendarId = json['calendar_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['row_id'] = this.rowId;
    data['holiday_id'] = this.holidayId;
    data['holiday_name'] = this.holidayName;
    data['color'] = this.color;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['date'] = this.date;
    data['calendar_id'] = this.calendarId;
    return data;
  }
}
