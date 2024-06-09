import 'package:re_open_chat/model/contact.dart';
import 'package:re_open_chat/model/message.dart';

const contactList = <Contact>[
  User(id: 1, name: 'Ash', profile: 'Ash profile'),
  User(id: 2, name: 'Dusk', profile: 'Dusk profile'),
  User(id: 3, name: 'Wish a del', profile: 'Wish a del profile'),
  User(id: 4, name: 'Logos', profile: 'Logos profile'),
  Group(id: 5, name: 'Group 1', profile: 'Group 1 profile'),
  User(id: 6, name: 'Typhon', profile: 'Typhon profile'),
];

const mockMessageList = <Message>[
  Message(id: 1, senderId: 100000001, content: 'Hello world'),
  Message(id: 2, senderId: 100000001, content: 'Hello world 2'),
  Message(id: 3, senderId: 100000001, content: 'Hello world 3'),
  Message(id: 4, senderId: 100000002, content: 'Hello world 4'),
  Message(
      id: 5,
      senderId: 100000002,
      imgFiles: [],
      content:
          'Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4Hello world 4'),
];
