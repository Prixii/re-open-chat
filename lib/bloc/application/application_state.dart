part of 'application_bloc.dart';

@freezed
class ApplicationState with _$ApplicationState {
  const factory ApplicationState.initial({
    @Default([]) List<int> applications,
    @Default([]) List<RequestResponseContent> groupApplications,
    @Default([]) List<int> historyApplications,
  }) = _Initial;
}
