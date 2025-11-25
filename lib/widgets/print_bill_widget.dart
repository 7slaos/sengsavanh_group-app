
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:multiple_school_app/functions/check_lang.dart';
import 'package:multiple_school_app/functions/format_price.dart';
import 'package:multiple_school_app/widgets/custom_circle_load.dart';

class PrintBillWidget extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  const PrintBillWidget({super.key, required this.data});

  @override
  State<PrintBillWidget> createState() => _PrintBillWidgetState();
}

class _PrintBillWidgetState extends State<PrintBillWidget> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      Get.back(); // Close the dialog or screen before printing
      _printInvoice();
    });
  }

  pw.Widget _buildPdfInfoRow(String label, String value, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: font)),
          pw.Text(value, style: pw.TextStyle(font: font)),
        ],
      ),
    );
  }

  Future<void> _printInvoice() async {
    final now = DateTime.now();
    final formatDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
    try {
      final pdf = pw.Document();
      final laoFont = pw.Font.ttf(
        await rootBundle.load('assets/fonts/NotoSansLao-Regular.ttf'),
      );
      String name = '';
      String phone = '';
      if (widget.data.isNotEmpty) {
         name = CheckLang(
          nameLa: widget.data.first['name_la'] ?? '',
          nameEn: widget.data.first['name_en'] ?? '',
        ).toString();
         phone = widget.data.first['phone'] ?? '';
      }

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            double totalAmount = 0;

            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    'ໃບຮັບເງິນ',
                    style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                        font: laoFont),
                  ),
                ),
                pw.Center(
                  child: pw.Text(
                    'Receipt',
                    style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        font: laoFont),
                  ),
                ),
                pw.Center(
                  child: pw.Text(
                     "${name ?? ''}, ເບີໂທ: ${phone ?? ''}",
                    style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        font: laoFont),
                  ),
                ),
                pw.SizedBox(height: 10),
                _buildPdfInfoRow('ວັນທີ:', formatDate, laoFont),
                pw.Divider(thickness: 1),

                // Table headers
                pw.Row(
                  children: [
                    pw.Expanded(
                        child: pw.Text('ເດືອນ',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                font: laoFont))),
                    pw.Expanded(
                        child: pw.Text('ນັກຮຽນ',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                font: laoFont))),
                    pw.Expanded(
                        child: pw.Text('ຫ້ອງ',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                font: laoFont))),
                    pw.Expanded(
                        child: pw.Text('ຈໍານວນເງິນ',
                            textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                font: laoFont))),
                  ],
                ),
                pw.Divider(thickness: 1),

                // Loop through data rows
                ...widget.data.map((item) {
                  final amount =
                      double.tryParse(item['subtotal'].toString()) ?? 0;
                  totalAmount += amount;

                  final DateTime? issueDate =
                  DateTime.tryParse(item['issue_date'] ?? '');
                  final String month = issueDate != null
                      ? DateFormat('MM/yyyy').format(issueDate)
                      : '';

                  final String fullName =
                      '${item['firstname'] ?? ''} ${item['lastname'] ?? ''}';
                  final String myClass = item['my_class'] ?? '';

                  return pw.Padding(
                    padding: pw.EdgeInsets.symmetric(vertical: 4),
                    child: pw.Row(
                      children: [
                        pw.Expanded(
                            child: pw.Text(month,
                                style: pw.TextStyle(font: laoFont))),
                        pw.Expanded(
                            child: pw.Text(fullName,
                                style: pw.TextStyle(font: laoFont))),
                        pw.Expanded(
                            child: pw.Text(myClass,
                                style: pw.TextStyle(font: laoFont))),
                        pw.Expanded(
                            child: pw.Text(
                              FormatPrice(price: amount).toString(),
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(font: laoFont),
                            )),
                      ],
                    ),
                  );
                }).toList(),

                pw.Divider(thickness: 1),

                _buildPdfInfoRow(
                  'ລວມທັງໝົດ:',
                  FormatPrice(price: totalAmount).toString(),
                  laoFont,
                ),

                pw.SizedBox(height: 20),
                _buildPdfInfoRow('ຜູ້ຮັບເງິນ:', 'ຜູ້ມອບເງິນ', laoFont),
                pw.SizedBox(height: 10),
                pw.Center(
                  child: pw.Text(
                    'ຂໍຂອບໃຈ',
                    style: pw.TextStyle(
                        font: laoFont,
                        fontWeight: pw.FontWeight.bold,
                        fontStyle: pw.FontStyle.italic),
                  ),
                ),
              ],
            );
          },
        ),
      );

      await Printing.layoutPdf(onLayout: (format) async => pdf.save());
    } catch (e) {
      debugPrint('PDF Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ບໍ່ສາມາດພິມໄດ້: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: CircleLoad(),
      ),
    );
  }
}
