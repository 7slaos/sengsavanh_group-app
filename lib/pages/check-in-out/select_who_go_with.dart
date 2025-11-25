// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:multiple_school_app/custom/app_color.dart';
// import 'package:multiple_school_app/custom/app_size.dart';
// import 'package:multiple_school_app/functions/format_price.dart';
// import 'package:multiple_school_app/states/adminschool/admin_students_state.dart';
// import 'package:multiple_school_app/states/camera_scan_state.dart';
// import 'package:multiple_school_app/states/superadmin/super_admin_state.dart';
//
// import 'package:multiple_school_app/widgets/custom_text_widget.dart';
// import 'package:multiple_school_app/widgets/shimmer_listview.dart';
//
// import '../../widgets/button_widget.dart';
//
// class SelectWhoGoWith extends StatefulWidget {
//   const SelectWhoGoWith({super.key, required this.branchId, this.checkInOut=false});
//   final String branchId;
//   final bool checkInOut;
//   @override
//   State<SelectWhoGoWith> createState() => _SelectWhoGoWithState();
// }
//
// class _SelectWhoGoWithState extends State<SelectWhoGoWith> {
//   AdminStudentsState adminStudentsState = Get.put(AdminStudentsState());
//   final searchT = TextEditingController();
//   AppColor appColor = AppColor();
//   @override
//   void initState() {
//     getData();
//     super.initState();
//   }
//
//   getData() {
//     Future.delayed(Duration(seconds: 5));
//     adminStudentsState.getData('', '', branchId: widget.branchId);
//   }
//
//   SuperAdminState superAdminState = Get.put(SuperAdminState());
//   CameraScanPageState cameraScanPageState = Get.put(CameraScanPageState());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: CustomText(text: 'who_go_with', color: appColor.mainColor, fontSize: fixSize(0.016, context)),
//         leading: IconButton(
//             onPressed: () {
//               Get.back();
//             },
//             icon: Icon(
//               Icons.arrow_back,
//               color: appColor.mainColor,
//             )),
//         centerTitle: true,
//         elevation: 4,
//         surfaceTintColor: appColor.white,
//
//       ),
//       body: GetBuilder<AdminStudentsState>(builder: (getD) {
//         if (getD.data.isEmpty && getD.loading == true) {
//           return ShimmerListview();
//         }
//         if (getD.data.isEmpty && getD.loading == false) {
//           return Column(
//             children: [
//               Expanded(
//                 child: Center(
//                     child: CustomText(
//                       text: 'not_found_data',
//                       color: appColor.grey,
//                       fontSize: fixSize(0.0185, context),
//                     )),
//               ),
//             ],
//           );
//         }
//         var value = getD.data
//             .where((e) =>
//         (e.firstname ?? '')
//             .toLowerCase()
//             .contains(searchT.text.toLowerCase()) ||
//             (e.lastname ?? '')
//                 .toLowerCase()
//                 .contains(searchT.text.toLowerCase()) ||
//             (e.phone ?? '')
//                 .toLowerCase()
//                 .contains(searchT.text.toLowerCase()) ||
//             (e.myClass ?? '')
//                 .toLowerCase()
//                 .contains(searchT.text.toLowerCase()))
//             .toList();
//         return Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextFormField(
//                 controller: searchT, // Attach the controller
//                 onChanged: (value) {
//                   adminStudentsState.update();
//                 },
//                 decoration: InputDecoration(
//                   suffixIcon: Icon(Icons.search),
//                   labelText: 'search'.tr,
//                   // ignore: deprecated_member_use
//                   fillColor: appColor.white.withOpacity(0.98),
//                   filled: true,
//
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide(width: 0.5, color: appColor.grey),
//                   ),
//
//                   // Customize the focused border
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       width: 0.5, // Customize width
//                       color: appColor
//                           .mainColor, // Change this to your desired color
//                     ),
//                   ),
//                   // Optionally, you can also change the enabled border
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       width: 0.5,
//                       color: appColor.grey,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: RefreshIndicator(
//                 color: appColor.mainColor,
//                 onRefresh: () async {
//                   superAdminState.clearData();
//                   getData();
//                 },
//                 child: ListView.builder(
//                   itemCount: value.length,
//                   itemBuilder: (context, index) {
//                     return InkWell(
//                       splashColor: Colors.transparent,
//                       onTap: (){
//                         if(widget.checkInOut == true){
//                           Get.back();
//                           cameraScanPageState.scanOut(context: context, code: value[index].admissionNumber);
//                         }
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.only(bottom: 8.0),
//                         child: Container(
//                             decoration: BoxDecoration(color: appColor.white),
//                             child: ListTile(
//                               title: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   CustomText(
//                                       text:
//                                       '${value[index].firstname ?? ""} ${value[index].lastname ?? ""}'),
//                                   CustomText(
//                                     text: '${"phone".tr}: ${value[index].phone}',
//                                     color: appColor.grey,
//                                   ),
//                                   CustomText(
//                                     text:
//                                     '${"class".tr}: ${value[index].myClass}',
//                                     color: appColor.grey,
//                                   ),
//                                 ],
//                               ),
//                               trailing: CustomText(
//                                 text: value[index].date ?? '',
//                                 color: appColor.grey,
//                               ),
//                             )),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }
