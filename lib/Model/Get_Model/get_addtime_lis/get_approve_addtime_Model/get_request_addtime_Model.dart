class get_addtime_Model {
  List<Data>? data;

  get_addtime_Model({this.data});

  get_addtime_Model.fromJson(Map<String, dynamic> json) {
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
  String? docId;
  String? description;
  String? status;
  String? shiftDate;
  String? createAt;
  Employee? employee;
  List<DocApprove>? docApprove;

  Data(
      {this.docId,
      this.description,
      this.status,
      this.shiftDate,
      this.createAt,
      this.employee,
      this.docApprove});

  Data.fromJson(Map<String, dynamic> json) {
    docId = json['doc_id'];
    description = json['description'];
    status = json['status'];
    shiftDate = json['shift_date'];
    createAt = json['create_at'];
    employee = json['Employee'] != null
        ? new Employee.fromJson(json['Employee'])
        : null;
    if (json['Doc_Approve'] != null) {
      docApprove = <DocApprove>[];
      json['Doc_Approve'].forEach((v) {
        docApprove!.add(new DocApprove.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doc_id'] = this.docId;
    data['description'] = this.description;
    data['status'] = this.status;
    data['shift_date'] = this.shiftDate;
    data['create_at'] = this.createAt;
    if (this.employee != null) {
      data['Employee'] = this.employee!.toJson();
    }
    if (this.docApprove != null) {
      data['Doc_Approve'] = this.docApprove!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Employee {
  String? firstName;
  String? lastName;

  Employee({this.firstName, this.lastName});

  Employee.fromJson(Map<String, dynamic> json) {
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

class DocApprove {
  String? docId;
  String? updateDate;
  String? status;
  String? employeeName;

  DocApprove({this.docId, this.updateDate, this.status, this.employeeName});

  DocApprove.fromJson(Map<String, dynamic> json) {
    docId = json['doc_id'];
    updateDate = json['update_date'];
    status = json['status'];
    employeeName = json['employee_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doc_id'] = this.docId;
    data['update_date'] = this.updateDate;
    data['status'] = this.status;
    data['employee_name'] = this.employeeName;
    return data;
  }
}
