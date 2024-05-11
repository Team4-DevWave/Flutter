import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/models/message.dart';


void main() {
  User from =User(id: 'fromId', username: 'fromUsername');
  User to =User(id: 'toId', username: 'toUsername');
  Message message=Message(id: 'messageId', from:from , fromType: 'user', to: to, toType: 'user', subject: 'messageSubject', message: 'message content', createdAt: DateTime.now(), read: false, collapsed:false, version: 0);
  group('testing messaging', () {
    message.markMessageAsRead();
    test('Marking a message as read', () {
      expect(message.read, true);
    });
  });

}
