class AppSettingModel {
  String responseCode;
  String message;
  List<Property> property;
  String status;

  AppSettingModel(
      {this.responseCode, this.message, this.property, this.status});

  AppSettingModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    if (json['property'] != null) {
      property = <Property>[];
      json['property'].forEach((v) {
        property.add(new Property.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['message'] = this.message;
    if (this.property != null) {
      data['property'] = this.property.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Property {
  String id;
  String sKey;
  String sValue;

  Property({this.id, this.sKey, this.sValue});

  Property.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sKey = json['s_key'];
    sValue = json['s_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['s_key'] = this.sKey;
    data['s_value'] = this.sValue;
    return data;
  }
}
