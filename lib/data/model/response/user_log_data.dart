class UserLogData {
  String countryCode;
  String phoneNumber;
  String password;

  UserLogData({this.countryCode, this.phoneNumber, this.password});

  UserLogData.fromJson(Map<String, dynamic> json) {
    countryCode = json['country_code'];
    phoneNumber = json['phone_number'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country_code'] = this.countryCode;
    data['phone_number'] = this.phoneNumber;
    data['password'] = this.password;
    return data;
  }
}
