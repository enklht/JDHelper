import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: "spreadsheetId", obfuscate: true)
  static String spreadsheetId = _Env.spreadsheetId;
  @EnviedField(varName: "cresidential", obfuscate: true)
  static String cresidential = _Env.cresidential;
}
