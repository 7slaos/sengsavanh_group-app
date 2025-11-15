import 'package:pathana_school_app/states/appverification.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../custom/app_color.dart';
import '../repositorys/repository.dart';

class PickImageState extends GetxController {
  AppVerification appVerification = Get.put(AppVerification());
  // ProfileState profileState = Get.put(ProfileState());
  final ImagePicker _picker = ImagePicker();
  Repository rep = Repository();
  AppColor appColor = AppColor();
  XFile? file;
  String? imageProfile;

  pickImage(ImageSource imageSource) async {
    var image = await _picker.pickImage(source: imageSource);
    if (image == null) {
      return;
    }
    file = image;
    update();
    // Get.to(() => const EditProfile());
  }

  void deleteFileImage() {
    file = null;
    update();
  }

  void deleteImageProfile() {
    imageProfile = null;
    update();
  }

  showPickImage(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        Size size = MediaQuery.of(context).size;
        double fixSize = size.width + size.height;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                Get.back();
                pickImage(ImageSource.camera);
              },
              leading: Icon(
                Icons.photo_camera,
                color: appColor.mainColor,
                size: fixSize * 0.03,
              ),
              title: CustomText(
                text: 'camera',
                fontSize: fixSize * 0.02,
                color: Colors.black,
              ),
            ),
            ListTile(
              onTap: () {
                Get.back();
                pickImage(ImageSource.gallery);
              },
              leading: Icon(
                Icons.photo,
                color: appColor.mainColor,
                size: fixSize * 0.03,
              ),
              title: CustomText(
                text: 'gallery',
                fontSize: fixSize * 0.02,
                color: Colors.black,
              ),
            )
          ],
        );
      },
    );
  }

  // updateProfile({required XFile fileImage}) async {
  //   CustomDialogs().dialogLoading();
  //   try {
  //     var uri = Uri.parse('${rep.nuXtJsUrlApi}api/update_images_profile_student');
  //     var request = http.MultipartRequest('POST', uri);

  //     request.headers.addAll({
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer ${appVerification.token}'
  //     });

  //     Uint8List data = await fileImage.readAsBytes();
  //     var picture = http.MultipartFile.fromBytes('file_image', data,
  //         filename: fileImage.path.split('/').last);
  //     request.files.add(picture);

  //     var response = await request.send().timeout(const Duration(seconds: 120));
  //     // var responseBody = await response.stream.bytesToString();
  //     // print('11111111111111111111111111111111111111111111111111');
  //     // print(responseBody);
  //     if (response.statusCode == 200) {
  //       file = null;
  //       update();
  //       // await profileState.checkToken();
  //       Get.back();
  //       CustomDialogs()
  //           .showToast(text: 'Success', backgroundColor: AppColor().green);
  //       Get.back(result: true);
  //     } else if (response.statusCode == 403) {
  //       Get.back(result: false);
  //       CustomDialogs().showToast(
  //         text: "Unauthorized action",
  //         backgroundColor: AppColor().red.withOpacity(0.75),
  //       );
  //     } else {
  //       Get.back();
  //       CustomDialogs().showToast(
  //           text: 'Something went wrong', backgroundColor: AppColor().red);
  //     }
  //   } catch (e, stackTrace) {
  //     print(stackTrace);
  //     Get.back(result: false);
  //     CustomDialogs().showToast(
  //         text: 'Something went wrong', backgroundColor: AppColor().red);
  //   }
  // }
}
