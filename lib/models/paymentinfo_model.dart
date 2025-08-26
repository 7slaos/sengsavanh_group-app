class PaymentInfoModel {
  String? resDesc;
  String? resCode;
  PaymentInfo? paymentInfo;

  PaymentInfoModel({this.resDesc, this.resCode, this.paymentInfo});

  PaymentInfoModel.fromJson(Map<String, dynamic> json) {
    resDesc = json['res_desc'];
    resCode = json['res_code'];
    paymentInfo = json['paymentInfo'] != null
        ? new PaymentInfo.fromJson(json['paymentInfo'])
        : null;
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['res_desc'] = this.resDesc;
  //   data['res_code'] = this.resCode;
  //   if (this.paymentInfo != null) {
  //     data['paymentInfo'] = this.paymentInfo!.toJson();
  //   }
  //   return data;
  // }
}

class PaymentInfo {
  String? billerID;
  String? payCurrencyCode;
  String? payAmount;
  String? payDateTime;
  String? payerAccountNo;
  String? payerName;
  String? ref2;
  String? ref1;
  String? payerBankCode;
  String? paymentBank;
  String? paymentAt;
  String? paymentReference;
  String? amount;
  String? currency;
  String? contact;

  PaymentInfo(
      {this.billerID,
      this.payCurrencyCode,
      this.payAmount,
      this.payDateTime,
      this.payerAccountNo,
      this.payerName,
      this.ref2,
      this.ref1,
      this.payerBankCode,
      this.paymentBank,
      this.paymentAt,
      this.paymentReference,
      this.amount,
      this.currency,
      this.contact});

  PaymentInfo.fromJson(Map<String, dynamic> json) {
    billerID = json['billerID'];
    payCurrencyCode = json['payCurrencyCode'];
    payAmount = json['payAmount'];
    payDateTime = json['payDateTime'];
    payerAccountNo = json['payerAccountNo'];
    payerName = json['payerName'];
    ref2 = json['ref2'];
    ref1 = json['ref1'];
    payerBankCode = json['payerBankCode'];
    paymentBank = json['paymentBank'];
    paymentAt = json['paymentAt'];
    paymentReference = json['paymentReference'];
    amount = json['amount'].toString();
    currency = json['currency'];
    payerName = json['payerName'];
    contact = json['contact'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['billerID'] = this.billerID;
  //   data['payCurrencyCode'] = this.payCurrencyCode;
  //   data['payAmount'] = this.payAmount;
  //   data['payDateTime'] = this.payDateTime;
  //   data['payerAccountNo'] = this.payerAccountNo;
  //   data['payerName'] = this.payerName;
  //   data['ref2'] = this.ref2;
  //   data['ref1'] = this.ref1;
  //   data['payerBankCode'] = this.payerBankCode;
  //   return data;
  // }
}
