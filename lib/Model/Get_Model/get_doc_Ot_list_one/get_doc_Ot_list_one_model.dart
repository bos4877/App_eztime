class get_doc_Ot_list_one_model {
  List<DocList>? docList;

  get_doc_Ot_list_one_model({this.docList});

  get_doc_Ot_list_one_model.fromJson(Map<String, dynamic> json) {
    if (json['doc_list'] != null) {
      docList = <DocList>[];
      json['doc_list'].forEach((v) {
        docList!.add(new DocList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.docList != null) {
      data['doc_list'] = this.docList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DocList {
  String? docOtId;
  String? otId;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  String? employeeNo;
  String? companyId;
  String? description;
  String? createAt;
  Ot? ot;
  String? status;
  String? approveBy;
  String? status2;
  String? approveBy2;
  List<ApproveName>? approveName;

  DocList(
      {this.docOtId,
      this.otId,
      this.startDate,
      this.endDate,
      this.startTime,
      this.endTime,
      this.employeeNo,
      this.companyId,
      this.description,
      this.createAt,
      this.ot,
      this.status,
      this.approveBy,
      this.status2,
      this.approveBy2,
      this.approveName});

  DocList.fromJson(Map<String, dynamic> json) {
    docOtId = json['doc_ot_id'];
    otId = json['ot_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    employeeNo = json['employee_no'];
    companyId = json['company_id'];
    description = json['description'];
    createAt = json['create_at'];
    ot = json['Ot'] != null ? new Ot.fromJson(json['Ot']) : null;
    status = json['status'];
    approveBy = json['approve_by'];
    status2 = json['status2'];
    approveBy2 = json['approve_by2'];
    if (json['approve_name'] != null) {
      approveName = <ApproveName>[];
      json['approve_name'].forEach((v) {
        approveName!.add(new ApproveName.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doc_ot_id'] = this.docOtId;
    data['ot_id'] = this.otId;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['employee_no'] = this.employeeNo;
    data['company_id'] = this.companyId;
    data['description'] = this.description;
    data['create_at'] = this.createAt;
    if (this.ot != null) {
      data['Ot'] = this.ot!.toJson();
    }
    data['status'] = this.status;
    data['approve_by'] = this.approveBy;
    data['status2'] = this.status2;
    data['approve_by2'] = this.approveBy2;
    if (this.approveName != null) {
      data['approve_name'] = this.approveName!.map((v) => v.toJson()).toList();
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

class ApproveName {
  String? firstName;
  String? lastName;

  ApproveName({this.firstName, this.lastName});

  ApproveName.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    return data;
  }
}
