// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: 'lib/env/.env')
abstract class Env {
  @EnviedField(varName: 'BASE', defaultValue: 'localhost:8080')
  static const String base = _Env.base;
  @EnviedField(varName: 'VERSION_KEY', defaultValue: 'version_key')
  static const String versionKey = _Env.versionKey;
  @EnviedField(varName: 'DEVICE_ID', defaultValue: 'device_id')
  static const String deviceId = _Env.deviceId;
}
