import 'package:freezed_annotation/freezed_annotation.dart';

part 'application.freezed.dart';
part 'application.g.dart';

@freezed
class Application with _$Application {
  const factory Application({
    required int id,
  }) = _Application;

  factory Application.fromJson(Map<String, dynamic> json) =>
      _$ApplicationFromJson(json);
}
