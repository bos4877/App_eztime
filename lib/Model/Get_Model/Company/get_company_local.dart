class get_company_local {
  Company? company;

  get_company_local({this.company});

  get_company_local.fromJson(Map<String, dynamic> json) {
    company =
        json['company'] != null ? new Company.fromJson(json['company']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.company != null) {
      data['company'] = this.company!.toJson();
    }
    return data;
  }
}

class Company {
  int? rowId;
  String? locationId;
  String? ownId;
  String? locationName;
  String? address;
  String? latitude;
  String? longitude;
  int? active;
  String? radians;

  Company(
      {this.rowId,
      this.locationId,
      this.ownId,
      this.locationName,
      this.address,
      this.latitude,
      this.longitude,
      this.active,
      this.radians});

  Company.fromJson(Map<String, dynamic> json) {
    rowId = json['row_id'];
    locationId = json['location_id'];
    ownId = json['own_id'];
    locationName = json['location_name'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    active = json['active'];
    radians = json['radians'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['row_id'] = this.rowId;
    data['location_id'] = this.locationId;
    data['own_id'] = this.ownId;
    data['location_name'] = this.locationName;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['active'] = this.active;
    data['radians'] = this.radians;
    return data;
  }
}
