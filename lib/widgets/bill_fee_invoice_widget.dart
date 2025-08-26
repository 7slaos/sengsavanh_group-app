// import 'package:cit_school_user_app/custom/app_color.dart';
// import 'package:cit_school_user_app/custom/app_size.dart';
// import 'package:cit_school_user_app/functions/format_price.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// // ignore: must_be_immutable
// class PrintBillWidget extends StatelessWidget {
//   PrintBillWidget({super.key});
//   // final PrintModel data;
//   final AppColor appColor = AppColor();
//   final doc = pw.Document();
//   Future<Uint8List> _generatePdf(
//       PdfPageFormat format, String title, PrintModel data) async {
//     final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: false);
//     final font = await fontFromAssetBundle('assets/fonts/saysettha_ot.ttf');
//     final fontBold =
//         await fontFromAssetBundle('assets/fonts/Saysettha-Bold.ttf');
//     final logo = await imageFromAssetBundle('assets/images/logo.png');
//     double normalSize = 18;
//     double largeSize = 24;
//     pdf.addPage(
//       pw.Page(
//         margin: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 28),
//         pageFormat: format,
//         build: (context) {
//           return pw.Center(
//             child: pw.SizedBox(
//               width: 350,
//               // height: 200,
//               child: pw.Column(
//                 children: [
//                   pw.Image(logo, width: 100, fit: pw.BoxFit.contain),
//                   pw.SizedBox(height: 5),
//                   pw.Text(
//                     'ບໍລິສັດ ໝາກເກົາຈຳກັດຜູ້ດຽວ',
//                     style: pw.TextStyle(
//                         font: font,
//                         fontSize: largeSize,
//                         fontWeight: pw.FontWeight.bold),
//                   ),

//                   pw.SizedBox(height: 10),
//                   pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.center,
//                       children: [
//                         pw.Text(
//                           "bill_get_money".tr,
//                           style: pw.TextStyle(
//                               font: font,
//                               fontSize: largeSize,
//                               fontWeight: pw.FontWeight.bold),
//                         ),
//                       ]),
//                   pw.SizedBox(height: 20),
//                   pw.Column(
//                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                       children: [
//                         pw.Row(
//                           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                           children: [
//                             pw.Text(
//                               "${'bill_no'.tr}: ",
//                               style: pw.TextStyle(
//                                   font: font, fontSize: normalSize),
//                             ),
//                             // pw.SizedBox(height: 5),
//                             pw.Text(
//                               data.code ?? '',
//                               style: pw.TextStyle(
//                                   font: font, fontSize: normalSize),
//                             ),
//                           ],
//                         ),
//                         pw.SizedBox(height: 5),
//                         pw.Row(
//                           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                           children: [
//                             pw.Text(
//                               "${'date'.tr}: ",
//                               style: pw.TextStyle(
//                                   font: font, fontSize: normalSize),
//                             ),
//                             pw.SizedBox(height: 5),
//                             pw.Text(
//                               data.date ?? '',
//                               style: pw.TextStyle(
//                                   font: font, fontSize: normalSize),
//                             ),
//                           ],
//                         ),
//                         pw.SizedBox(height: 5),
//                         pw.Row(
//                           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                           children: [
//                             pw.Text(
//                               "${'staff'.tr}: ",
//                               style: pw.TextStyle(
//                                   font: font, fontSize: normalSize),
//                             ),
//                             pw.SizedBox(height: 5),
//                             pw.Text(
//                               data.staff ?? '',
//                               style: pw.TextStyle(
//                                   font: font, fontSize: normalSize),
//                             ),
//                           ],
//                         ),
//                         pw.SizedBox(height: 5),
//                         pw.Row(
//                           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                           children: [
//                             pw.Text(
//                               "${'customer'.tr}: ",
//                               style: pw.TextStyle(
//                                   font: font, fontSize: normalSize),
//                             ),
//                             pw.SizedBox(height: 5),
//                             pw.Text(
//                               '${data.meber.toString()}',
//                               style: pw.TextStyle(
//                                   font: font, fontSize: normalSize),
//                             ),
//                           ],
//                         ),
//                         pw.SizedBox(height: 5),
//                         pw.Row(
//                           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                           children: [
//                             pw.Text(
//                               "${'note'.tr}: ",
//                               style: pw.TextStyle(
//                                   font: font, fontSize: normalSize),
//                             ),
//                             pw.SizedBox(height: 5),
//                             pw.Text(
//                               '${data.Note ?? ''}',
//                               style: pw.TextStyle(
//                                   font: font, fontSize: normalSize),
//                             ),
//                           ],
//                         ),
//                       ]),
//                   pw.SizedBox(height: 5),
//                   pw.Divider(),
//                   pw.Row(
//                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                     children: [
//                       pw.Expanded(
//                         flex: 40,
//                         child: pw.Column(
//                           crossAxisAlignment: pw.CrossAxisAlignment.start,
//                           children: [
//                             pw.Text('product_name'.tr,
//                                 style: pw.TextStyle(
//                                     font: font,
//                                     fontSize: normalSize,
//                                     fontWeight: pw.FontWeight.bold)),
//                           ],
//                         ),
//                       ),
//                       pw.Expanded(
//                         flex: 20,
//                         child: pw.Text(
//                           // 'weight'.tr,
//                           'weight'.tr,
//                           style: pw.TextStyle(
//                               font: font,
//                               fontSize: normalSize,
//                               fontWeight: pw.FontWeight.bold),
//                         ),
//                       ),
//                       pw.Expanded(
//                         flex: 25,
//                         child: pw.Text(
//                           'as_money'.tr,
//                           style: pw.TextStyle(
//                               font: font,
//                               fontSize: normalSize,
//                               fontWeight: pw.FontWeight.bold),
//                         ),
//                       ),
//                       // pw.Expanded(
//                       //   flex: 25,
//                       //   child: pw.Align(
//                       //       alignment: pw.Alignment.centerRight,
//                       //       child: pw.Text(
//                       //         'amount',
//                       //         // '${FormatPrice(price: num.parse(data.items![index].quantity.toString()) * num.parse(data.items![index].unitPrice.toString()))}',
//                       //         style: pw.TextStyle(
//                       //             font: font, fontSize: normalSize),
//                       //       )),
//                       // )
//                     ],
//                   ),
//                   pw.SizedBox(height: 5),
//                   pw.Row(
//                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                     children: [
//                       pw.Expanded(
//                         flex: 40,
//                         child: pw.Column(
//                           crossAxisAlignment: pw.CrossAxisAlignment.start,
//                           children: [
//                             pw.Text('${data.proName ?? ''}',
//                                 style: pw.TextStyle(
//                                     font: font, fontSize: normalSize)),
//                           ],
//                         ),
//                       ),
//                       pw.Expanded(
//                         flex: 20,
//                         child: pw.Text(
//                           // 'weight'.tr,
//                           '${FormatPrice(price: num.parse(data.weight ?? ''))}',
//                           style: pw.TextStyle(font: font, fontSize: normalSize),
//                         ),
//                       ),
//                       pw.Expanded(
//                         flex: 25,
//                         child: pw.Text(
//                           '${FormatPrice(price: num.parse(data.totalPrice ?? '0'))} ₭',
//                           style: pw.TextStyle(font: font, fontSize: normalSize),
//                         ),
//                       ),
//                     ],
//                   ),
//                   pw.Divider(),
//                   pw.SizedBox(height: 5),
//                   pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                       children: [
//                         pw.Text(
//                           "${'payment_type'.tr} :",
//                           style: pw.TextStyle(
//                               fontBold: fontBold,
//                               font: font,
//                               fontSize: normalSize),
//                         ),
//                         pw.Text(
//                           data.payment == 'cash' ? 'cash'.tr : 'transfer'.tr,
//                           style: pw.TextStyle(
//                             fontBold: fontBold,
//                             font: font,
//                             fontSize: normalSize,
//                           ),
//                         ),
//                       ]),
//                   pw.SizedBox(height: 10),

//                   pw.Row(
//                     mainAxisAlignment: pw.MainAxisAlignment.center,
//                     children: [
//                       pw.Text(
//                         'thankyou'.tr,
//                         style: pw.TextStyle(
//                             fontBold: fontBold,
//                             fontWeight: pw.FontWeight.bold,
//                             font: font,
//                             fontSize: normalSize + 5),
//                       ),
//                     ],
//                   ),
//                   // footer
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//     return pdf.save();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PdfPreview(
//       canDebug: false,
//       allowSharing: false,
//       allowPrinting: true,
//       canChangePageFormat: false,
//       canChangeOrientation: false,
//       padding: EdgeInsets.only(
//         top: fixSize(0.1, context),
//       ),
//       previewPageMargin: EdgeInsets.zero,
//       pdfPreviewPageDecoration: BoxDecoration(
//         color: appColor.white,
//       ),
//       actionBarTheme: PdfActionBarTheme(backgroundColor: Colors.green),
//       build: (format) => _generatePdf(format, "bill".tr, data),
//     );
//   }
// }
