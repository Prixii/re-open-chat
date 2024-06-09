import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:re_open_chat/network/contact/types.dart';

part 'contact.freezed.dart';

mixin Contact {
  int get id;
  String get profile;
  String get name;
  String get avatarId;
  static bool isGroup(int id) => (id ~/ 100000000 == 6);
}

@freezed
class User with _$User implements Contact {
  const factory User({
    @Default('') String phone,
    @Default('') String password,
    @Default(0) int id,
    @Default('') String name,
    @Default('') String profile,
    @Default('') String avatarId,
    @Default(0) int addedOn,
  }) = _User;

  const factory User.debug({
    @Default('12345678910') String phone,
    @Default('c4d038b4bed09fdb1471ef51ec3a32cd') String password,
    @Default(100000001) int id,
    @Default('debugger') String name,
    @Default('i am a debugger') String profile,
    @Default('') String avatarId,
    @Default(1) int addedOn,
  }) = _Debug;

  factory User.fromContactData(ContactData data, {int addedOn = 0}) {
    return User(
      id: data.id,
      name: data.name,
      profile: data.profile,
      avatarId: data.avatar,
      addedOn: addedOn,
    );
  }
}

@freezed
class Group with _$Group, Contact {
  const factory Group({
    @Default(0) int id,
    @Default('') String name,
    @Default('') String profile,
    @Default('') String avatarId,
    @Default(0) int addedOn,
  }) = _Group;

  factory Group.fromContactData(ContactData data) {
    return Group(
      id: data.id,
      name: data.name,
      profile: data.profile,
      avatarId: data.avatar,
    );
  }
}
