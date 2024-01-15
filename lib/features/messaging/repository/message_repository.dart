import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/constants/firebase_constants.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/models/message_model.dart';

final messageRepoProvider = Provider((ref) {
  return MessageRepository(firebaseFirestore: ref.watch(firestoreProvider));
});

class MessageRepository {
  final FirebaseFirestore firebaseFirestore;

  MessageRepository({required this.firebaseFirestore});

  FutureVoid sendMessage(Message message) async {
    firebaseFirestore
        .collection(FirebaseConstants.messagesCollection)
        .doc(message.receiverID)
        .collection('messagesWith${message.senderID}')
        .doc(message.id)
        .set(message.toJson());
  }

  Stream<List<Message>> fetchMessages(String? receiverID) {
    return firebaseFirestore
        .collection(FirebaseConstants.messagesCollection)
        .doc(receiverID)
        .collection('messagesWith${FirebaseAuth.instance.currentUser!.uid}')
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => Message.fromJson(doc.data())).toList());
  }

  FutureVoid deleteMessage(Message? message) async {
    await firebaseFirestore
        .collection(FirebaseConstants.messagesCollection)
        .doc(message!.receiverID)
        .collection('messagesWith${FirebaseAuth.instance.currentUser!.uid}')
        .doc(message.id)
        .delete();
  }
}
