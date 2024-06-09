sealed class CreateGroupEvent {
  const CreateGroupEvent();
}

final class CreateGroup extends CreateGroupEvent {
  const CreateGroup(this.pop);
  final Function() pop;
}

final class AddContact extends CreateGroupEvent {
  const AddContact(this.id);
  final int id;
}

final class RemoveContact extends CreateGroupEvent {
  const RemoveContact(this.id);
  final int id;
}
