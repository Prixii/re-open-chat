import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:re_open_chat/bloc/application/application_event.dart';
import 'package:re_open_chat/network/friend/friend.dart';
import 'package:re_open_chat/network/friend/types.dart';
import 'package:re_open_chat/network/group/group.dart';
import 'package:re_open_chat/network/group/types.dart';

part 'application_state.dart';
part 'application_bloc.freezed.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  ApplicationBloc() : super(const ApplicationState.initial()) {
    on<AcceptFriendApplication>(_onAcceptFriendApplication);
    on<RejectFriendApplication>(_onRejectFriendApplication);
    on<AcceptGroupApplication>(_onAcceptGroupApplication);
    on<RejectGroupApplication>(_onRejectGroupApplication);
    on<UpdateApplications>(_onUpdateApplications);
  }

  void _onAcceptFriendApplication(
    AcceptFriendApplication event,
    Emitter<ApplicationState> emit,
  ) async {
    await friendApi.agree(FriendAgreeData(id: event.contactId));
    final applicationsSnapshot = [...state.applications];
    applicationsSnapshot.remove(event.contactId);
    emit(state.copyWith(applications: applicationsSnapshot));
  }

  void _onRejectFriendApplication(
    RejectFriendApplication event,
    Emitter<ApplicationState> emit,
  ) async {
    await friendApi.disagree(FriendDisagreeData(id: event.contactId));
    final applicationsSnapshot = [...state.applications];
    applicationsSnapshot.remove(event.contactId);
    emit(state.copyWith(applications: applicationsSnapshot));
  }

  void _onAcceptGroupApplication(
    AcceptGroupApplication event,
    Emitter<ApplicationState> emit,
  ) async {
    await groupApi
        .agree(GroupAgreeData(groupID: event.groupId, userID: event.contactId));
    final groupApplicationsSnapshot = [...state.groupApplications];
    groupApplicationsSnapshot.removeWhere((item) =>
        (item.groupID == event.groupId && item.id == event.contactId));
    emit(state.copyWith(groupApplications: groupApplicationsSnapshot));
  }

  void _onRejectGroupApplication(
    RejectGroupApplication event,
    Emitter<ApplicationState> emit,
  ) async {
    await groupApi.disagree(
        GroupDisagreeData(groupID: event.groupId, userID: event.groupId));
    final groupApplicationsSnapshot = [...state.groupApplications];
    groupApplicationsSnapshot.removeWhere((item) =>
        (item.groupID == event.groupId && item.id == event.contactId));
    emit(state.copyWith(groupApplications: groupApplicationsSnapshot));
  }

  void _onUpdateApplications(
    UpdateApplications event,
    Emitter<ApplicationState> emit,
  ) async {
    emit(state.copyWith(applications: event.applications));
  }
}
