class Profile_Model {
  EmployData? employData;

  Profile_Model({this.employData});

  Profile_Model.fromJson(Map<String, dynamic> json) {
    employData = json['employ_data'] != null
        ? new EmployData.fromJson(json['employ_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.employData != null) {
      data['employ_data'] = this.employData!.toJson();
    }
    return data;
  }
}

class EmployData {
  int? rowId;
  String? employeeId;
  String? employeeNo;
  String? employeeType;
  String? firstName;
  String? lastName;
  String? finger;
  String? sex;
  String? nationality;
  String? status;
  String? personalId;
  String? personalcommuId;
  String? birthDay;
  String? branchOffice;
  String? department;
  String? positionId;
  String? salary;
  String? cashAdvance;
  String? startedDate;
  String? passedDate;
  String? guaranteeNo;
  String? vatId;
  String? cashWay;
  String? bankName;
  String? bankNo;
  String? phone;
  String? email;
  int? active;
  String? password;
  String? deviceToken;
  String? refreshToken;
  String? companyId;
  String? lastUpdate;
  String? role;

  EmployData(
      {this.rowId,
      this.employeeId,
      this.employeeNo,
      this.employeeType,
      this.firstName,
      this.lastName,
      this.finger,
      this.sex,
      this.nationality,
      this.status,
      this.personalId,
      this.personalcommuId,
      this.birthDay,
      this.branchOffice,
      this.department,
      this.positionId,
      this.salary,
      this.cashAdvance,
      this.startedDate,
      this.passedDate,
      this.guaranteeNo,
      this.vatId,
      this.cashWay,
      this.bankName,
      this.bankNo,
      this.phone,
      this.email,
      this.active,
      this.password,
      this.deviceToken,
      this.refreshToken,
      this.companyId,
      this.lastUpdate,
      this.role});

  EmployData.fromJson(Map<String, dynamic> json) {
    rowId = json['row_id'];
    employeeId = json['employee_id'];
    employeeNo = json['employee_no'];
    employeeType = json['employee_type'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    finger = json['finger'];
    sex = json['sex'];
    nationality = json['nationality'];
    status = json['status'];
    personalId = json['personal_id'];
    personalcommuId = json['personalcommu_id'];
    birthDay = json['birth_day'];
    branchOffice = json['branch_office'];
    department = json['department'];
    positionId = json['position_id'];
    salary = json['salary'];
    cashAdvance = json['cash_advance'];
    startedDate = json['started_date'];
    passedDate = json['passed_date'];
    guaranteeNo = json['guarantee_no'];
    vatId = json['vat_id'];
    cashWay = json['cash_Way'];
    bankName = json['bank_name'];
    bankNo = json['bank_no'];
    phone = json['phone'];
    email = json['email'];
    active = json['active'];
    password = json['password'];
    deviceToken = json['device_token'];
    refreshToken = json['refreshToken'];
    companyId = json['company_id'];
    lastUpdate = json['last_update'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['row_id'] = this.rowId;
    data['employee_id'] = this.employeeId;
    data['employee_no'] = this.employeeNo;
    data['employee_type'] = this.employeeType;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['finger'] = this.finger;
    data['sex'] = this.sex;
    data['nationality'] = this.nationality;
    data['status'] = this.status;
    data['personal_id'] = this.personalId;
    data['personalcommu_id'] = this.personalcommuId;
    data['birth_day'] = this.birthDay;
    data['branch_office'] = this.branchOffice;
    data['department'] = this.department;
    data['position_id'] = this.positionId;
    data['salary'] = this.salary;
    data['cash_advance'] = this.cashAdvance;
    data['started_date'] = this.startedDate;
    data['passed_date'] = this.passedDate;
    data['guarantee_no'] = this.guaranteeNo;
    data['vat_id'] = this.vatId;
    data['cash_Way'] = this.cashWay;
    data['bank_name'] = this.bankName;
    data['bank_no'] = this.bankNo;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['active'] = this.active;
    data['password'] = this.password;
    data['device_token'] = this.deviceToken;
    data['refreshToken'] = this.refreshToken;
    data['company_id'] = this.companyId;
    data['last_update'] = this.lastUpdate;
    data['role'] = this.role;
    return data;
  }
}
