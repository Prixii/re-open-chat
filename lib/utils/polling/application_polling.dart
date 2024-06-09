import 'package:re_open_chat/bloc/application/application_event.dart';
import 'package:re_open_chat/bloc/global/global_state.dart';
import 'package:re_open_chat/main.dart';
import 'package:re_open_chat/network/friend/friend.dart';
import 'package:re_open_chat/network/friend/types.dart';
import 'package:re_open_chat/network/group/group.dart';
import 'package:re_open_chat/network/group/types.dart';
import 'package:re_open_chat/utils/client_utils.dart';
import 'package:re_open_chat/utils/polling/polling.dart';

class ApplicationPolling extends Polling {
  var userApplicationList = <int>[];
  var groupApplicationList = <RequestResponseContent>[];
  @override
  Future<void> sendRequest() async {
    if (printDebug) talker.debug('ApplicationPolling sendRequest');
    await friendApi.request(FriendApiRequestData()).then((value) {
      userApplicationList = [...value.data.id];
    });
    await groupApi.request((GroupApiRequestData())).then((value) {
      groupApplicationList = [...value.data.request];
    });
    return;
  }

  @override
  Future<void> store() async {
    return;
  }

  @override
  Future<void> notifyBloc() async {
    talker.info('polling application $userApplicationList');
    applicationBloc
        .add(UpdateApplications(userApplicationList, groupApplicationList));
    return;
  }

  @override
  bool shouldRestartTimer() {
    return globalBloc.state.currentPage == AppPage.contactsManager;
  }
}
