class CheckPaymentModel {
  String? resDesc;
  String? paymentId;
  String? resCode;
  String? transactionId;

  CheckPaymentModel(
      {this.resDesc, this.paymentId, this.resCode, this.transactionId});

  CheckPaymentModel.fromJson(Map<String, dynamic> json) {
    resDesc = json['res_desc'];
    paymentId = json['paymentId'];
    resCode = json['res_code'];
    transactionId = json['transactionId'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['res_desc'] = this.resDesc;
  //   data['paymentId'] = this.paymentId;
  //   data['res_code'] = this.resCode;
  //   data['transactionId'] = this.transactionId;
  //   return data;
  // }
}
