import 'package:local_auth/local_auth.dart';

class ClassName {
  final LocalAuthentication auth = LocalAuthentication();
  Future localAuth() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
  }
}
