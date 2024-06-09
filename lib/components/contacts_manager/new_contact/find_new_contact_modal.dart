import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_open_chat/bloc/find_new_contact/find_new_contact_bloc.dart';
import 'package:re_open_chat/bloc/find_new_contact/find_new_contact_event.dart';
import 'package:re_open_chat/components/contacts_manager/contacts_list_tile.dart';
import 'package:re_open_chat/components/hello/tabbed_view.dart';
import 'package:re_open_chat/model/contact.dart';
import 'package:re_open_chat/utils/context_reader.dart';
import 'package:unicons/unicons.dart';

class FindNewContactModal extends StatelessWidget {
  const FindNewContactModal({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
                child: buildTextField(
              'id',
              controller,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            )),
            const SizedBox(width: 12),
            InkWell(
                onTap: () => readFindNewContactBloc(context)
                    .add(FindNewContact(controller.text)),
                child: const Icon(UniconsLine.search)),
          ],
        ),
        BlocSelector<FindNewContactBloc, FindNewContactState, List<Contact>>(
          selector: (state) {
            return state.results;
          },
          builder: (context, results) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: results.length,
              itemBuilder: (context, index) {
                return _buildResult(results, index, context);
              },
            );
          },
        ),
        Divider(
          color: readThemeData(context).dividerColor,
        )
      ],
    );
  }

  Row _buildResult(List<Contact> results, int index, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ContactListTile(
            contactId: results[index].id,
          ),
        ),
        BlocSelector<FindNewContactBloc, FindNewContactState, bool>(
          selector: (state) {
            return state.applicationSent;
          },
          builder: (context, applicationSent) {
            return InkWell(
              onTap: () => !applicationSent
                  ? readFindNewContactBloc(context)
                      .add(CreateApplication(results[index].id))
                  : null,
              child: !applicationSent
                  ? Icon(
                      UniconsLine.plus,
                      size: 24,
                      color:
                          readThemeData(context).colorScheme.onPrimaryContainer,
                    )
                  : Icon(
                      UniconsLine.check,
                      size: 24,
                      color: readThemeData(context)
                          .colorScheme
                          .onSecondaryContainer,
                    ),
            );
          },
        )
      ],
    );
  }
}
