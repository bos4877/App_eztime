class get_addtime_list_model {
  List<DocList>? docList;

  get_addtime_list_model({this.docList});

  get_addtime_list_model.fromJson(Map<String, dynamic> json) {
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
  String? addTimeId;
  String? date;
  String? time;
  String? employeeNo;
  String? description;
  String? createAt;
  String? status;
  String? companyId;
  Employee? employee;
  List<DocAddtimeApprove>? docAddtimeApprove;

  DocList(
      {this.addTimeId,
      this.date,
      this.time,
      this.employeeNo,
      this.description,
      this.createAt,
      this.status,
      this.companyId,
      this.employee,
      this.docAddtimeApprove});

  DocList.fromJson(Map<String, dynamic> json) {
    addTimeId = json['add_time_id'];
    date = json['date'];
    time = json['time'];
    employeeNo = json['employee_no'];
    description = json['description'];
    createAt = json['create_at'];
    status = json['status'];
    companyId = json['company_id'];
    employee = json['Employee'] != null
        ? new Employee.fromJson(json['Employee'])
        : null;
    if (json['Doc_Addtime_Approve'] != null) {
      docAddtimeApprove = <DocAddtimeApprove>[];
      json['Doc_Addtime_Approve'].forEach((v) {
        docAddtimeApprove!.add(new DocAddtimeApprove.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['add_time_id'] = this.addTimeId;
    data['date'] = this.date;
    data['time'] = this.time;
    data['employee_no'] = this.employeeNo;
    data['description'] = this.description;
    data['create_at'] = this.createAt;
    data['status'] = this.status;
    data['company_id'] = this.companyId;
    if (this.employee != null) {
      data['Employee'] = this.employee!.toJson();
    }
    if (this.docAddtimeApprove != null) {
      data['Doc_Addtime_Approve'] =
          this.docAddtimeApprove!.map((v) => v.toJson()).toList();
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

class DocAddtimeApprove {
  String? aproveAddtimeId;
  String? addTimeId;
  String? status;
  String? approveBy;
  String? createAt;
  String? approveFname;
  String? approveLname;

  DocAddtimeApprove(
      {this.aproveAddtimeId,
      this.addTimeId,
      this.status,
      this.approveBy,
      this.createAt,
      this.approveFname,
      this.approveLname});

  DocAddtimeApprove.fromJson(Map<String, dynamic> json) {
    aproveAddtimeId = json['aprove_addtime_id'];
    addTimeId = json['add_time_id'];
    status = json['status'];
    approveBy = json['approve_by'];
    createAt = json['create_at'];
    approveFname = json['approve_fname'];
    approveLname = json['approve_lname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aprove_addtime_id'] = this.aproveAddtimeId;
    data['add_time_id'] = this.addTimeId;
    data['status'] = this.status;
    data['approve_by'] = this.approveBy;
    data['create_at'] = this.createAt;
    data['approve_fname'] = this.approveFname;
    data['approve_lname'] = this.approveLname;
    return data;
  }
}
