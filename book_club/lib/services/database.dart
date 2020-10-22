import 'package:book_club/models/book.dart';
import 'package:book_club/models/group.dart';
import 'package:book_club/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OurDatabase {
  final Firestore _firestore = Firestore.instance;

  Future<String> createUser(OurUser user) async {
    String returnVal = "error";
    try {
      await _firestore.collection("users").document(user.uid).setData({
        "fullName": user.fullName,
        "email": user.email,
        "accountCreated": Timestamp.now(),
      });
      returnVal = "success";
    } catch (e) {
      print(e);
    }
    return returnVal;
  }

  Future<OurUser> getUserInfo(String uid) async {
    OurUser returnVal = OurUser();

    try {
      DocumentSnapshot _docSnapshot = await _firestore.collection("users").document(uid).get();
      returnVal.uid = uid;
      returnVal.fullName = _docSnapshot.data["fullName"];
      returnVal.email = _docSnapshot.data["email"];
      returnVal.accountCreated = _docSnapshot.data["accountCreated"];
      returnVal.groupID = _docSnapshot.data["groupID"];
    } catch (e) {
      print(e);
    }

    return returnVal;
  }

  Future<String> createGroup(String groupName, String userUid, OurBook initialBook) async {
    String returnVal = "error";
    List<String> members = List();
    try {
      members.add(userUid);
      DocumentReference _docRef = await _firestore.collection("groups").add({
        "name": groupName,
        "leader": userUid,
        "members": members,
        "groupCreated": Timestamp.now(),
      });

      await _firestore.collection("users").document(userUid).updateData(
        {"groupID": _docRef.documentID},
      );

      returnVal = "success";
    } catch (e) {
      print(e);
    }
    return returnVal;
  }

  Future<String> joinGroup(String groupId, String userUid) async {
    String returnVal = "error";
    List<String> members = List();
    try {
      members.add(userUid);
      await _firestore.collection("groups").document(groupId).updateData({
        "members": FieldValue.arrayUnion(members),
      });
      await _firestore.collection("users").document(userUid).updateData(
        {"groupID": groupId},
      );
      returnVal = "success";
    } catch (e) {
      print(e);
    }
    return returnVal;
  }

  Future<OurGroup> getGroupInfo(String groupId) async {
    OurGroup returnVal = OurGroup();

    try {
      DocumentSnapshot _docSnapshot = await _firestore.collection("groups").document(groupId).get();
      returnVal.id = groupId;
      returnVal.name = _docSnapshot.data["name"];
      returnVal.leader = _docSnapshot.data["leader"];
      returnVal.members = List<String>.from(_docSnapshot.data["members"]);
      returnVal.groupCreated = _docSnapshot.data["groupCreated"];
      returnVal.currentBookId = _docSnapshot.data["currentBookId"];
      returnVal.currentBookDue = _docSnapshot.data["currentBookDue"];
    } catch (e) {
      print(e);
    }

    return returnVal;
  }

  Future<OurBook> getCurrentBook(String groupId, String bookId) async {
    OurBook returnVal = OurBook();

    try {
      DocumentSnapshot _docSnapshot = await _firestore.collection("groups").document(groupId).collection("books").document(bookId).get();
      returnVal.id = bookId;
      returnVal.name = _docSnapshot.data["name"];
      returnVal.author = _docSnapshot.data["author"];
      returnVal.length = _docSnapshot.data["length"];
      returnVal.dateCompleted = _docSnapshot.data["dateCompleted"];
    } catch (e) {
      print(e);
    }

    return returnVal;
  }
}
