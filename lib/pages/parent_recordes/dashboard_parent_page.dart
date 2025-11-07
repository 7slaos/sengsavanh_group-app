import 'package:cached_network_image/cached_network_image.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/pages/change_language_page.dart';
import 'package:pathana_school_app/pages/parent_recordes/follow_missing_school.dart';
import 'package:pathana_school_app/pages/parent_recordes/history_missing_school_page.dart';
import 'package:pathana_school_app/pages/parent_recordes/parent_student_page.dart';
import 'package:pathana_school_app/pages/parent_recordes/take_children_page.dart';
import 'package:pathana_school_app/pages/profile_page.dart';
import 'package:pathana_school_app/pages/teacher_recordes/dashboard_page.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/states/address_state.dart';
import 'package:pathana_school_app/states/appverification.dart';
import 'package:pathana_school_app/states/auth_login_register.dart';
import 'package:pathana_school_app/states/home_state.dart';
import 'package:pathana_school_app/states/profile_state.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class DashboardParentPage extends StatefulWidget {
  const DashboardParentPage({super.key});

  @override
  State<DashboardParentPage> createState() => _DashboardParentPageState();
}

class _DashboardParentPageState extends State<DashboardParentPage> {
  HomeState homeState = Get.put(HomeState());
  ProfileState profileState = Get.put(ProfileState());
  AuthLoginRegister loginRegister = Get.put(AuthLoginRegister());
  AddressState addressState = Get.put(AddressState());

  // keep your subjects as-is
final List<Map<String, dynamic>> subjects = [
  {'title': 'score', 'icon': Icons.feed_outlined, 'color': Colors.green},
  {'title': 'Missing_school', 'icon': Icons.calendar_month_outlined, 'color': Colors.blue},
  {'title': 'check_in_check_out', 'icon': Icons.nordic_walking_sharp, 'color': Colors.blue},
  {'title': 'Tuition_fees', 'icon': Icons.school_outlined, 'color': Colors.red},
  {'title': 'student', 'icon': Icons.diversity_3_outlined, 'color': Colors.black},
  {'title': 'take_children', 'icon': Icons.campaign_outlined, 'color': Colors.black},
  {'title': 'profile', 'icon': Icons.perm_identity_outlined, 'color': Colors.orange},
  {'title': 'language', 'icon': Icons.language, 'color': Colors.teal},
  {'title': 'logout', 'icon': Icons.logout, 'color': Colors.grey},
];

void handleGridTap(int index) {
  if (index < 0 || index >= subjects.length) {
    debugPrint('handleGridTap: bad index $index');
    return;
  }

  final key = subjects[index]['title'] as String?; // 'score', 'Missing_school', ...
  if (key == null) {
    debugPrint('handleGridTap: item has no title at index $index');
    return;
  }

  final routes = <String, VoidCallback>{
    'score'           : () => homeState.setCurrentPage(1),
    'Tuition_fees'    : () => homeState.setCurrentPage(2),
    'Missing_school'  : () => Get.to(() => const FollowMissingSchool(),    transition: Transition.fadeIn),
    'check_in_check_out'  : () => Get.to(() => const HistoryMissingSchoolPage(),    transition: Transition.fadeIn),
    'student'         : () => Get.to(() => const ParentStudentPage(),      transition: Transition.fadeIn),
    'take_children'   : () => Get.to(() => const TakeChildrenPage(),       transition: Transition.fadeIn),
    'profile'         : () => Get.to(() => const ProfilePage(),            transition: Transition.fadeIn),
    'language'        : () => Get.to(() => const ChangeLanguagePage(),     transition: Transition.fadeIn),
    'logout'          : logots,
  };

  (routes[key] ?? () {
    debugPrint('No action mapped for title "$key"');
  }).call();
}


  @override
  void initState() {
    homeState.getHomeParentAndStudentList();
    getData();
    super.initState();
  }

  getData() async {
    Future.delayed(Duration.zero);
    await profileState.getProfiled();
    addressState.getReligion();
    addressState.getJob();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fSize = size.width + size.height;
    AppColor appColor = AppColor();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: appColor.mainColor, toolbarHeight: 0),
        body: GetBuilder<AppVerification>(builder: (getRole) {
          subjects.clear();
          if (getRole.role != 'p' && !subjects.any((e) => e['title'] == 'teacher')){
            subjects.add({
              'title': 'teacher',
              'icon': Icons.assignment_ind_outlined,
              'color': Colors.green
            });
          }
          subjects.addAll([
            {
              'title': 'score',
              'icon': Icons.feed_outlined,
              'color': Colors.green
            },
            {
              'title': 'Missing_school',
              'icon': Icons.calendar_month_outlined,
              'color': Colors.blue
            },
            {
              'title': 'check_in_check_out',
              'icon': Icons.nordic_walking_sharp,
              'color': Colors.blue
            },
            {
              'title': 'Tuition_fees',
              'icon': Icons.school_outlined,
              'color': Colors.red
            },
            {
              'title': 'student',
              'icon': Icons.diversity_3_outlined,
              'color': Colors.black
            },
            {
              'title': 'take_children',
              'icon': Icons.campaign_outlined,
              'color': Colors.black
            },
          ]);
          if (getRole.role == 'p' && !subjects.any((e) => e['title'] == 'profile')){
            subjects.add({
              'title': 'profile',
              'icon': Icons.perm_identity_outlined,
              'color': Colors.orange
            });
          }
           if (!subjects.any((e) => e['title'] == 'language')){
              subjects.add({'title': 'language', 'icon': Icons.language, 'color': Colors.teal});
          }
          if (!subjects.any((e) => e['title'] == 'logout')){
              subjects.add(
                {'title': 'logout', 'icon': Icons.logout, 'color': Colors.grey},
              );
          }
          return SafeArea(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: appColor.mainColor,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: fSize * 0.004,
                    vertical: fSize * 0.004,
                  ),
                  child: GetBuilder<ProfileState>(
                    builder: (get) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "${Repository().urlApi}${get.profiledModels?.profileImage}",
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(
                                      color: appColor.mainColor,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                            decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/logo.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                                  ),
                                ),
                                SizedBox(width: size.width * 0.05),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.5,
                                      child: CustomText(
                                        text:
                                            '${get.profiledModels?.firstname ?? ''} ${get.profiledModels?.lastname ?? ''}',
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: fSize * 0.0165,
                                        textOverflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(height: fSize * 0.005),
                                    CustomText(
                                      text: get.profiledModels?.phone ?? '',
                                      color: Colors.white70,
                                      fontSize: fSize * 0.0155,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                                onPressed: () {
                                  logots();
                                },
                                icon: Icon(
                                  Icons.power_settings_new,
                                  color: Colors.white,
                                  size: fSize * 0.025,
                                )),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Number of columns
                      crossAxisSpacing: 10, // Spacing between columns
                      mainAxisSpacing: 10, // Spacing between rows
                      childAspectRatio: 1, // Aspect ratio of items
                    ),
                    itemCount: subjects.length, // Total number of items
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          handleGridTap(index);
                        },
                        child: Column(
                          children: [
                            Icon(
                              subjects[index]['icon'],
                              color: appColor.mainColor,
                              size: size.width * 0.25,
                            ),
                            CustomText(
                              text: subjects[index]['title'],
                              color: Colors.grey,
                              fontSize: fSize * 0.012,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }));
  }

  logots() async {
    var res = await CustomDialogs().LogoutyesAndNoDialogWithText(
        context, 'do_you_want_to_logout',
        color: Colors.black);
    if (res == true) {
      loginRegister.logouts();
    }
  }
}
