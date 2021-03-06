import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pulzion_app/frbsAuth.dart';

class FRBSChat{
  static String
      sender="",
      receiver="",
      data="";
  static final FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;
  static List myMsgs=[];

  static sendMsg(d)async{
    if(d!=null && receiver!=""){
      for(int i=0;i<d.length;i++){
        data+=d[0].join("");
      }
      await firebaseFirestore.collection("messages").add({
        "sender":sender,
        "receiver":receiver,
        "data":data,
        "time":DateTime.now().toString().substring(0,16),
      });
      data="";
    }
  }
  static receiveMsg()async{
    await for(var i in firebaseFirestore.collection("messages").snapshots()){
      for(var j in i.docs){
        if(j.data()["sender"]==sender || j.data()["receiver"]==sender){
          if(!(myMsgs.contains(j.data()))){
            myMsgs.insert(0,j.data());
          }
        }
      }
    }
    print(myMsgs);
  }
  static isEmailthere(email)async {
    await for (var i in firebaseFirestore.collection("users").snapshots()) {
      for (var j in i.docs) {
        if (j.data()["email"] == email) {
          return true;
        }
      }
    }
    return false;
  }
}