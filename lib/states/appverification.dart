import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppVerification extends GetxController {
  final GetStorage storage = GetStorage();

  String role = '';
  String token = '';
  String nUxtToken = '';
  bool rememberMe = false;
  String phone = '';
  String password = '';

  @override
  void onInit() {
    super.onInit();
    setInitToken();
  }

  /// Load values from storage (with safe fallbacks)
  void setInitToken() {
    token      = (storage.read<String>('token')) ?? '';
    role       = (storage.read<String>('role')) ?? '';
    nUxtToken  = (storage.read<String>('nUxtToken')) ?? '';
    rememberMe = (storage.read<bool>('rememberMe')) ?? false;
    phone      = (storage.read<String>('phone')) ?? '';
    password   = (storage.read<String>('password')) ?? '';
    update();
  }

  /// Save login/session + optional Remember Me
  Future<void> setNewToken({
    required String text,        // the token
    required String role,        // the role
    String? phone,
    String? password,
    bool rememberMe = false,
  }) async {
    await storage.write('token', text);
    await storage.write('role', role);

    if (rememberMe) {
      await storage.write('phone', phone ?? '');
      await storage.write('password', password ?? '');
      await storage.write('rememberMe', true);
    } else {
      await storage.write('phone', '');
      await storage.write('password', '');
      await storage.write('rememberMe', false);
    }

    // Re-load into memory (ensures types + triggers update)
    setInitToken();
  }

  Future<void> setNewNUxtToken({required String token}) async {
    await storage.write('nUxtToken', token);
    nUxtToken = (storage.read<String>('nUxtToken')) ?? '';
    update();
  }

  /// Clear everything (and persist cleared state)
  Future<void> removeToken() async {
    await storage.remove('token');
    await storage.remove('role');
    await storage.remove('nUxtToken');
    await storage.remove('phone');
    await storage.remove('password');
    await storage.write('rememberMe', false);

    token = '';
    role = '';
    nUxtToken = '';
    phone = '';
    password = '';
    rememberMe = false;
    update();
  }

  /// Toggle or set rememberMe and persist it
  Future<void> updateRemember(bool? value) async {
    rememberMe = value ?? !rememberMe;   // toggle if null
    await storage.write('rememberMe', rememberMe);
    update();
    // print('rememberMe = $rememberMe');
  }
}
