class calendar_holiday_Model {
  List<Event>? event;

  calendar_holiday_Model({this.event});

  calendar_holiday_Model.fromJson(Map<String, dynamic> json) {
    if (json['event'] != null) {
      event = <Event>[];
      json['event'].forEach((v) {
        event!.add(new Event.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.event != null) {
      data['event'] = this.event!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Event {
  int? rowId;
  String? calendarId;
  String? title;
  String? start;
  String? end;
  String? color;
  String? id;
  String? createAt;
  String? companyId;
  bool? allDay;

  Event(
      {this.rowId,
      this.calendarId,
      this.title,
      this.start,
      this.end,
      this.color,
      this.id,
      this.createAt,
      this.companyId,
      this.allDay});

  Event.fromJson(Map<String, dynamic> json) {
    rowId = json['row_id'];
    calendarId = json['calendar_id'];
    title = json['title'];
    start = json['start'];
    end = json['end'];
    color = json['color'];
    id = json['id'];
    createAt = json['create_at'];
    companyId = json['company_id'];
    allDay = json['allDay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['row_id'] = this.rowId;
    data['calendar_id'] = this.calendarId;
    data['title'] = this.title;
    data['start'] = this.start;
    data['end'] = this.end;
    data['color'] = this.color;
    data['id'] = this.id;
    data['create_at'] = this.createAt;
    data['company_id'] = this.companyId;
    data['allDay'] = this.allDay;
    return data;
  }
}
