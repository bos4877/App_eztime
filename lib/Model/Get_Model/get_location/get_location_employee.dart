class get_location_model {
  List<Data>? data;

  get_location_model({this.data});

  get_location_model.fromJson(Map<String, dynamic> json) {
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
  String? locationId;
  String? locationName;
  String? latitude;
  String? longitude;
  String? radians;

  Data(
      {this.locationId,
      this.locationName,
      this.latitude,
      this.longitude,
      this.radians});

  Data.fromJson(Map<String, dynamic> json) {
    locationId = json['locationId'];
    locationName = json['locationName'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    radians = json['radians'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['locationId'] = this.locationId;
    data['locationName'] = this.locationName;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['radians'] = this.radians;
    return data;
  }
}
