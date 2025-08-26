import 'package:get/get.dart';
import 'package:pathana_school_app/models/province_model.dart';
import 'package:pathana_school_app/repositorys/repository.dart';

class AddressState extends GetxController {
  Repository rep = Repository();
  List<ProvinceDropdownModel> provinceList = [];
  List<DistrictDropdownModel> districtList = [];
  List<VillageDropdownModel> villageList = [];
  List<ClassGroupDropdownModel> classgroupList = [];
  List<BloodGroupDropdownModel> bloodgroupList = [];
  List<ReligionDropdownModel> religiongroupList = [];
  List<NationalityDropdownModel> nationalityList = [];
  List<EducationLevelDropdownModel> educationlevelList = [];
  List<LanguageGroupDropdownModel> languageGroupList = [];
  List<EthnicGroupDropdownModel> ethnicityList = [];
  List<SpecialHealthdownModel> specialHealthList = [];
  List<ResidencedownModel> residenList = [];
  List<JobDropdownModel> jobList = [];
  ProvinceDropdownModel? selectProvince;
  DistrictDropdownModel? selectDistrict;
  VillageDropdownModel? selectVillage;
  BloodGroupDropdownModel? selectBloodGroup;
  NationalityDropdownModel? selectNationality;
  ReligionDropdownModel? selectReligion;
  EducationLevelDropdownModel? selectEducationLevel;
  LanguageGroupDropdownModel? selectlanguageGroup;
  EthnicGroupDropdownModel? selectEthinicity;
  SpecialHealthdownModel? selectspecialHealth;
  ResidencedownModel? selectResidense;
  JobDropdownModel? selectJob;
  List<ClassListDropdownModel> classList = [];
  updateDropDownJob(JobDropdownModel v) {
    selectJob = v;
    update();
  }

  updateDropDownBloodGroup(BloodGroupDropdownModel v) {
    selectBloodGroup = v;
    update();
  }

  updateDropDownNationality(NationalityDropdownModel v) {
    selectNationality = v;
    update();
  }

  updateDropdownReligion(ReligionDropdownModel v) {
    selectReligion = v;
    update();
  }

  updateDropDownEducationLevel(EducationLevelDropdownModel v) {
    selectEducationLevel = v;
    update();
  }

  updateDropDownlanguageDrop(LanguageGroupDropdownModel v) {
    selectlanguageGroup = v;
    update();
  }

  updateDropDownEthinicity(EthnicGroupDropdownModel v) {
    selectEthinicity = v;
    update();
  }

  updateDropDownspecialHealth(SpecialHealthdownModel v) {
    selectspecialHealth = v;
    update();
  }

  updateDropDownResidences(ResidencedownModel v) {
    selectResidense = v;
    update();
  }

  updateDropDownProvince(ProvinceDropdownModel v) {
    selectProvince = v;
    update();
  }

  updateDropDownDistrict(DistrictDropdownModel v) {
    selectDistrict = v;
    update();
  }

  updateDropDownVillage(VillageDropdownModel v) {
    selectVillage = v;
    update();
  }

  clearDistrict() {
    selectDistrict = null;
    update();
  }

  clearVillage() {
    selectDistrict = null;
    update();
  }

  clearData() {
    selectProvince = null;
    selectDistrict = null;
    selectVillage = null;
    selectReligion = null;
    selectNationality = null;
    selectEthinicity = null;
    selectlanguageGroup = null;
    selectEducationLevel = null;
    selectResidense = null;
    selectBloodGroup = null;
    selectspecialHealth = null;
    update();
  }

  getProvince() async {
    provinceList = [];
    var res = await rep.get(url: '${rep.urlApi}api/provinces');
    if (res.statusCode == 200) {
      for (var item in jsonDecode(res.body)['data']) {
        provinceList.add(ProvinceDropdownModel.fromMap(item));
      }
    }
    update();
  }

  getBloodGroup() async {
    bloodgroupList = [];
    var res =
        await rep.get(url: '${rep.urlApi}api/get_blood_group', auth: true);
    if (res.statusCode == 200) {
      for (var item in jsonDecode(res.body)['data']) {
        bloodgroupList.add(BloodGroupDropdownModel.fromMap(item));
      }
    }
    update();
  }

  getReligion() async {
    religiongroupList = [];
    var res = await rep.get(url: '${rep.urlApi}api/get_religion', auth: true);
    if (res.statusCode == 200) {
      for (var item in jsonDecode(res.body)['data']) {
        religiongroupList.add(ReligionDropdownModel.fromMap(item));
      }
    }
    update();
  }

  getNationality() async {
    nationalityList = [];
    var res =
        await rep.get(url: '${rep.urlApi}api/get_nationality', auth: true);
    if (res.statusCode == 200) {
      for (var item in jsonDecode(res.body)['data']) {
        nationalityList.add(NationalityDropdownModel.fromMap(item));
      }
    }
    update();
  }

  geteducationLevel() async {
    educationlevelList = [];
    var res =
        await rep.get(url: '${rep.urlApi}api/get_education_level', auth: true);
    if (res.statusCode == 200) {
      for (var item in jsonDecode(res.body)['data']) {
        educationlevelList.add(EducationLevelDropdownModel.fromMap(item));
      }
    }
    update();
  }

  getlanguageGroup() async {
    languageGroupList = [];
    var res =
        await rep.get(url: '${rep.urlApi}api/get_language_group', auth: true);
    if (res.statusCode == 200) {
      for (var item in jsonDecode(res.body)['data']) {
        languageGroupList.add(LanguageGroupDropdownModel.fromMap(item));
      }
    }
    update();
  }

  getEthinicity() async {
    ethnicityList = [];
    var res = await rep.get(url: '${rep.urlApi}api/get_ethnicity', auth: true);
    if (res.statusCode == 200) {
      for (var item in jsonDecode(res.body)['data']) {
        ethnicityList.add(EthnicGroupDropdownModel.fromMap(item));
      }
    }
    update();
  }

  getSpecialHealth() async {
    specialHealthList = [];
    var res =
        await rep.get(url: '${rep.urlApi}api/get_special_health', auth: true);
    if (res.statusCode == 200) {
      for (var item in jsonDecode(res.body)['data']) {
        specialHealthList.add(SpecialHealthdownModel.fromMap(item));
      }
    }
    update();
  }

  getResidence() async {
    residenList = [];
    var res = await rep.get(url: '${rep.urlApi}api/get_residence', auth: true);
    if (res.statusCode == 200) {
      for (var item in jsonDecode(res.body)['data']) {
        residenList.add(ResidencedownModel.fromMap(item));
      }
    }
    update();
  }

  getJob() async {
    jobList = [];
    var res = await rep.get(url: '${rep.urlApi}api/get_jobs', auth: true);
    if (res.statusCode == 200) {
      for (var item in jsonDecode(res.body)['data']) {
        jobList.add(JobDropdownModel.fromMap(item));
      }
    }
    update();
  }

  Future<void> getProvinceById(String id) async {
    selectProvince = null;
    if (provinceList.isEmpty) {
      await getProvince();
    }
    selectProvince =
        provinceList.firstWhereOrNull((e) => e.id.toString() == id.toString());
    update();
  }

  getDistrictById(String id) async {
    selectDistrict = null;
    selectDistrict =
        districtList.firstWhereOrNull((e) => e.id.toString() == id.toString());
    update();
  }

  getVillageById(String id) {
    selectVillage = null;
    selectVillage =
        villageList.firstWhereOrNull((e) => e.id.toString() == id.toString());
    update();
  }

  getDistrict(int id, DistrictDropdownModel? v) async {
    districtList = [];
    var res = await rep.get(url: '${rep.urlApi}api/district_by_province/$id');
    if (res.statusCode == 200) {
      for (var item in jsonDecode(res.body)['data']) {
        districtList.add(DistrictDropdownModel.fromMap(item));
      }
    }
    selectDistrict = v;
    update();
  }

  getVillage(int id, VillageDropdownModel? v) async {
    villageList = [];
    var res = await rep.get(url: '${rep.urlApi}api/village_by_districts/$id');
    if (res.statusCode == 200) {
      for (var item in jsonDecode(res.body)['data']) {
        villageList.add(VillageDropdownModel.fromMap(item));
      }
    }
    selectVillage = v;
    update();
  }

  getclassGroup(int id) async {
    classgroupList = [];
    var res = await rep.get(url: '${rep.urlApi}api/class_group/$id');
    // print(jsonDecode(res.body));
    if (res.statusCode == 200) {
      for (var item in jsonDecode(res.body)['data']) {
        classgroupList.add(ClassGroupDropdownModel.fromMap(item));
      }
    }
    update();
  }

  getClassList({required String id, required String branchId}) async {
    classList = [];
    var res = await rep.post(
        url: '${rep.urlApi}api/class_list',
        body: {'id': id, 'branch_id': branchId});
    if (res.statusCode == 200) {
      for (var item in jsonDecode(res.body)['data']) {
        classList.add(ClassListDropdownModel.fromMap(item));
      }
    }
    update();
  }

  @override
  void onInit() {
    getProvince();
    getclassGroup(0);
    super.onInit();
  }
}
