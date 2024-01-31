class get_Ot_Model {
  List<Ot>? ot;

  get_Ot_Model({this.ot});

  get_Ot_Model.fromJson(Map<String, dynamic> json) {
    if (json['ot'] != null) {
      ot = <Ot>[];
      json['ot'].forEach((v) {
        ot!.add(new Ot.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ot != null) {
      data['ot'] = this.ot!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ot {
  int? rowId;
  String? otId;
  String? otName;
  String? rate;
  String? companyId;

  Ot({this.rowId, this.otId, this.otName, this.rate, this.companyId});

  Ot.fromJson(Map<String, dynamic> json) {
    rowId = json['row_id'];
    otId = json['ot_id'];
    otName = json['ot_name'];
    rate = json['rate'];
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['row_id'] = this.rowId;
    data['ot_id'] = this.otId;
    data['ot_name'] = this.otName;
    data['rate'] = this.rate;
    data['company_id'] = this.companyId;
    return data;
  }
}
