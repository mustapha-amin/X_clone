import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/constants/firebase_constants.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/models/message_model.dart';
import 'package:x_clone/models/user_model.dart';

final messageRepoProvider = Provider((ref) {
  return MessageRepository(firebaseFirestore: ref.watch(firestoreProvider));
});

class MessageRepository {
  final FirebaseFirestore firebaseFirestore;

  MessageRepository({required this.firebaseFirestore});

  FutureVoid sendMessage(Message message) async {
    // sender
    firebaseFirestore
        .collection(FirebaseConstants.messagesCollection)
        .doc(message.senderID)
        .collection('messagesWith${message.receiverID}')
        .doc(message.id)
        .set(message.toJson());
    // receiver
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
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messagesWith$receiverID')
        .orderBy('timeSent')
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => Message.fromJson(doc.data())).toList());
  }

  FutureVoid deleteMessage(Message? message) async {
    // sender
    await firebaseFirestore
        .collection(FirebaseConstants.messagesCollection)
        .doc(message!.senderID)
        .collection('messagesWith${message.receiverID}')
        .doc(message.id)
        .delete();
  }

  Future<void> addToConversationList(String? id) async {
    await firebaseFirestore
        .collection(FirebaseConstants.usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'conversationList': FieldValue.arrayUnion([id]),
    });
  }
}
