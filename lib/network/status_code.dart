enum StatusCode {
  success(200),
  phoneNumberAlreadyExist(20000001),
  phoneNumberNotFound(20000002),
  wrongPassword(20000003),
  wrongDeviceId(20000004),
  noChangePermission(20000006),
  notInOrgan(20000007),
  noRequest(20000008),
  notAdmin(20000009),
  noGroupFound(20000010),
  notCreator(20000011),
  userNotInGroup(20000012),
  userIsCreator(20000013),
  userIsAdmin(20000014),
  alreadyRequest(20000015),
  userIsMember(20000016),
  noUserRequestFound(20000017),
  userIsNotAdmin(20000018);

  final int value;

  const StatusCode(this.value);
}

enum BadStatusCode {
  serverError1(500),
  serverError2(501),
  badGateway(502),
  wrongMessage(400),
  networkError(0);

  final int value;

  const BadStatusCode(this.value);
}
