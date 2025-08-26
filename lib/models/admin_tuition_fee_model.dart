import 'package:pathana_school_app/models/history_model.dart';

class AdminTuitionFeeModel {
  String? total;
  List<HistoryModel>? items;
  AdminTuitionFeeModel({this.total, this.items});
  AdminTuitionFeeModel.fromJson(Map<String, dynamic> json) {
    total = json['total'].toString();
    if (json['items'] != null) {
      items = <HistoryModel>[];
      json['items'].forEach((v) {
        items!.add(new HistoryModel.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
