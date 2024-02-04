import 'package:x_clone/models/message_model.dart';

enum GroupType {
  day,
  minute,
}

extension MessageExtension on List<Message> {
  List<Iterable<Message>> groupedMessagesBy(GroupType groupType) {
    List<Iterable<Message>> groupedMessages = []; //! stores the groups
    Set<int> checked = {}; //! keeps track of grouped dates

    for (final message in this) {
      int param = groupType == GroupType.day
          ? message.timeSent!.day
          : message.timeSent!.minute;
      if (!checked.contains(param)) {
        groupType == GroupType.day
            ? groupedMessages
                .add(where((message) => message.timeSent!.day == param).toList())
            : groupedMessages.add(
                where((message) => message.timeSent!.minute == param).toList());
        checked.add(param);
      }
    }

    return groupedMessages;
  }
}
