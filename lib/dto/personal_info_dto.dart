class PersonalInfoDto {
  String? phoneNumber;
  String? account;
  String? password;
  String? email;
  String? realName;
  String? idCardNumber;
  String? deliveryArea;
  String? workStatus;
  String? vehicleType;
  String? createTime;
  String? updateTime;
  String? deleteStatus;
  String? version;
  String? courierStatus;
  String? imageUrl;

  PersonalInfoDto({
    this.account,
    this.phoneNumber,
    this.password,
    this.email,
    this.realName,
    this.idCardNumber,
    this.deliveryArea,
    this.workStatus,
    this.vehicleType,
    this.createTime,
    this.updateTime,
    this.deleteStatus,
    this.version,
    this.courierStatus,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'account': account,
      'phoneNumber': phoneNumber,
      'password': password,
      'email': email,
      'realName': realName,
      'idCardNumber': idCardNumber,
      'deliveryArea': deliveryArea,
      'workStatus': workStatus,
      'vehicleType': vehicleType,
      'createTime': createTime,
      'updateTime': updateTime,
      'deleteStatus': deleteStatus,
      'version': version,
      'courierStatus': courierStatus,
      'imageUrl': imageUrl,
    };
  }
}