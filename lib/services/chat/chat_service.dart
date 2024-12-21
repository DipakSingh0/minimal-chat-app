import 'package:chat/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  // get instance of firestore and auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get all user stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        //go through each individual user
        final user = doc.data();

        //return user
        return user;
      }).toList();
    });
  }

  //get all user stream except blocked users
  // GET ALL USERS STREAM EXCEPT BLOCKED USERS
 Stream<List<Map<String, dynamic>>> getUsersStreamExcludingBlocked() {
  final currentUser = _auth.currentUser;

  return _firestore
      .collection('Users')
      .doc(currentUser!.uid)
      .collection('BlockedUsers')
      .snapshots()
      .asyncMap((snapshot) async {
        // get blocked user ids
        final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

        // get all users
        final usersSnapshot = await _firestore.collection('Users').get();

        // return as stream list
        return usersSnapshot.docs
            .where((doc) =>
                doc.data()['email'] != currentUser.email &&
                !blockedUserIds.contains(doc.id))
            .map((doc) => doc.data())
            .toList();
      });
}


  // send message
  Future<void> sendMessage(String receiverId, message) async {
    //get curretn user info - id and email
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create a new meessgae
    Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverId,
        message: message,
        timestamp: timestamp);

    // construct chatroom Id for 2 users (sorted to ensure uniqueness)
    List<String> ids = [currentUserID, receiverId];
    ids.sort();
    String chatroomID = ids.join('_');

    //add  new message to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatroomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // get messages
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    // Construct a chatroom ID for the two users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  //report user
  Future<void> reportUser(String messageId, String userId) async {
    final currentUser = _auth.currentUser;
    final report = {
      'reportedBy': currentUser!.uid,
      'messageId': messageId,
      'messageOwnerId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('Reports').add(report);
  }

  //block user -- kun userlai block gareko
  Future<void> blockUser(String userId) async {
    final currentUser = _auth.currentUser; // user lyaune kun ho chalaudai
    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers') // userlai blocked db ma halne
        .doc(userId)
        .set({});
    notifyListeners(); // ui lai update garne
  }

  //unblock user
  Future<void> unlockUser(String blockedUserId) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers') // userlai blocked db ma halne
        .doc(blockedUserId)
        .delete();
  }

  //get blocked user stream
  Stream<List<Map<String, dynamic>>> getBlockedUsersStream(String userId) {
    return _firestore
        .collection('Users')
        .doc(userId)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
          //get list of blocked user ids
          final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

          final userDocs = await Future.wait(
            blockedUserIds.map((id) => _firestore.collection('Users').doc(id).get()),
          );

          //return as a list
           return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        });
  }
}
