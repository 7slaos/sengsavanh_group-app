class BankPaymentModel {
  int? id;
  String? logo;
  int? bankId;
  String? nameLa;
  String? nameEn;
  String? aCCOUNTNO;
  String? aCCOUNTNAME;
  String? billerID;
  String? storeID;
  String? terminalID;
  String? ref2;
  String? mERCHANTID;
  String? mERCHANTNAME;
  String? clientId;
  String? clientSecret;
  String? partnerId;
  String? signatureSecretKey;
  String? phone;

  BankPaymentModel(
      {this.id,
      this.logo,
      this.bankId,
      this.nameLa,
      this.nameEn,
      this.aCCOUNTNO,
      this.aCCOUNTNAME,
      this.billerID,
      this.storeID,
      this.terminalID,
      this.ref2,
      this.mERCHANTID,
      this.mERCHANTNAME,
      this.clientId,
      this.clientSecret,
      this.partnerId,
      this.signatureSecretKey});

  BankPaymentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logo = json['logo'];
    bankId = json['bank_id'];
    nameLa = json['name_la'];
    nameEn = json['name_en'];
    aCCOUNTNO = json['ACCOUNT_NO'];
    aCCOUNTNAME = json['ACCOUNT_NAME'];
    billerID = json['billerID'];
    storeID = json['storeID'];
    terminalID = json['terminalID'];
    ref2 = json['ref2'];
    mERCHANTID = json['MERCHANT_ID'];
    mERCHANTNAME = json['MERCHANT_NAME'];
    clientId = json['client_id'];
    clientSecret = json['client_secret'];
    partnerId = json['partner_id'];
    signatureSecretKey = json['signature_secret_key'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['logo'] = this.logo;
    data['bank_id'] = this.bankId;
    data['name_la'] = this.nameLa;
    data['name_en'] = this.nameEn;
    data['ACCOUNT_NO'] = this.aCCOUNTNO;
    data['ACCOUNT_NAME'] = this.aCCOUNTNAME;
    data['billerID'] = this.billerID;
    data['storeID'] = this.storeID;
    data['terminalID'] = this.terminalID;
    data['ref2'] = this.ref2;
    data['MERCHANT_ID'] = this.mERCHANTID;
    data['MERCHANT_NAME'] = this.mERCHANTNAME;
    data['client_id'] = this.clientId;
    data['client_secret'] = this.clientSecret;
    data['partner_id'] = this.partnerId;
    data['signature_secret_key'] = this.signatureSecretKey;
    data['phone'] = this.phone;
    return data;
  }
}