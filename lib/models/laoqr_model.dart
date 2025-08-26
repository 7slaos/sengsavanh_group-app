class LaoQrModel {
  String? resDesc;
  String? qrCode;
  String? resCode;
  String? transactionId;

  LaoQrModel({this.resDesc, this.qrCode, this.resCode, this.transactionId});

  LaoQrModel.fromJson(Map<String, dynamic> json) {
    resDesc = json['res_desc'];
    qrCode = json['qrCode'];
    resCode = json['res_code'];
    transactionId = json['transactionId'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['res_desc'] = this.resDesc;
  //   data['qrCode'] = this.qrCode;
  //   data['res_code'] = this.resCode;
  //   data['transactionId'] = this.transactionId;
  //   return data;
  // }
}