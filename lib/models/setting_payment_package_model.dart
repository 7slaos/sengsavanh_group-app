class SettingPaymentPackageModel {
  int? studentCount;
  String? ref2;
  String? billerID;
  String? storeID;
  String? terminalID;
  String? pricePerStudent;
  String? packageDiscount;
  SettingPaymentPackageModel(
      {this.studentCount,
      this.ref2,
      this.billerID,
      this.storeID,
      this.terminalID,
      this.pricePerStudent, this.packageDiscount});
  SettingPaymentPackageModel.fromJson(Map<String, dynamic> json) {
    studentCount = json['student_count'];
    ref2 = json['ref2'];
    billerID = json['billerID'];
    storeID = json['storeID'];
    terminalID = json['terminalID'];
    pricePerStudent = json['price_per_student'].toString();
    packageDiscount = json['package_discount'].toString();
  }
}
