import 'package:re_open_chat/network/group/types.dart';

sealed class ApplicationEvent {
  const ApplicationEvent();
}

final class AcceptFriendApplication extends ApplicationEvent {
  const AcceptFriendApplication(this.contactId);
  final int contactId;
}

final class RejectFriendApplication extends ApplicationEvent {
  const RejectFriendApplication(this.contactId);
  final int contactId;
}

final class AcceptGroupApplication extends ApplicationEvent {
  const AcceptGroupApplication(
      {required this.contactId, required this.groupId});
  final int contactId;
  final int groupId;
}

final class RejectGroupApplication extends ApplicationEvent {
  const RejectGroupApplication(
      {required this.contactId, required this.groupId});
  final int contactId;
  final int groupId;
}

final class UpdateApplications extends ApplicationEvent {
  const UpdateApplications(this.applications, this.groupApplications);
  final List<int> applications;
  final List<RequestResponseContent> groupApplications;
}
