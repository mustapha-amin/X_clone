import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/features/messaging/repository/message_repository.dart';
import 'package:x_clone/models/message_model.dart';

final fetchMessagesProvider =
    StreamProvider.family<List<Message>, String>((ref, id) {
  final messageRepo = ref.watch(messageRepoProvider);
  return messageRepo.fetchMessages(id);
});

final deleteMessageProvider =
    FutureProvider.family<void, Message>((ref, message) async {
  final messageRepo = ref.watch(messageRepoProvider);
  await messageRepo.deleteMessage(message);
});

final sendMessageProvider =
    FutureProvider.family<void, Message>((ref, message) async {
  final messageRepo = ref.watch(messageRepoProvider);
  await messageRepo.sendMessage(message);
});
