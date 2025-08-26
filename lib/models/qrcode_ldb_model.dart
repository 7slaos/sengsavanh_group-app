class QrcodeLDBModel {
  String? processingStatus;
  String? responseDt;
  String? qrCode;
  String? expiredTime;
  DeeplinkInfo? deeplinkInfo;

  QrcodeLDBModel(
      {this.processingStatus,
      this.responseDt,
      this.qrCode,
      this.expiredTime,
      this.deeplinkInfo});

  QrcodeLDBModel.fromJson(Map<String, dynamic> json) {
    processingStatus = json['processingStatus'];
    responseDt = json['responseDt'];
    qrCode = json['qrCode'];
    expiredTime = json['expiredTime'];
    deeplinkInfo = json['deeplinkInfo'] != null
        ? new DeeplinkInfo.fromJson(json['deeplinkInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['processingStatus'] = this.processingStatus;
    data['responseDt'] = this.responseDt;
    data['qrCode'] = this.qrCode;
    data['expiredTime'] = this.expiredTime;
    if (this.deeplinkInfo != null) {
      data['deeplinkInfo'] = this.deeplinkInfo!.toJson();
    }
    return data;
  }
}

class DeeplinkInfo {
  String? transactionId;
  String? deeplinkURL;

  DeeplinkInfo({this.transactionId, this.deeplinkURL});

  DeeplinkInfo.fromJson(Map<String, dynamic> json) {
    transactionId = json['transactionId'];
    deeplinkURL = json['deeplinkURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionId'] = this.transactionId;
    data['deeplinkURL'] = this.deeplinkURL;
    return data;
  }
}