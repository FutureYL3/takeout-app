class PersonalInfoDto {
  late final String? phoneNumber;
  late final String? account;
  late final String? password;
  late final String? email;
  late final String? realName;
  late final String? idCardNumber;
  late final String? deliveryArea;
  late final String? workStatus;
  late final String? vehicleType;
  late final String? createTime;
  late final String? updateTime;
  late final String? deleteStatus;
  late final String? version;
  late final String? courierStatus;
  late final String? imageUrl;

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