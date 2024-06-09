sealed class FindNewContactEvent {
  const FindNewContactEvent();
}

class FindNewContact extends FindNewContactEvent {
  const FindNewContact(this.id);
  final String id;
}

class CreateApplication extends FindNewContactEvent {
  const CreateApplication(this.id);
  final int id;
}
