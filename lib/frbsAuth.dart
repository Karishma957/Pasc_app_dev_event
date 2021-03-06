import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FRBSAuth{
  static FirebaseAuth auth=FirebaseAuth.instance;
  static loginEmail(email,password)async{
    try{
      UserCredential result=await auth.signInWithEmailAndPassword(email: email, password: password);
      if(result.user != null){
        return auth.currentUser;
      }
    }catch(e){
      return throw e;
    }
  }
  static signupEmail(email,password,displayName)async{
    try{
      UserCredential result=await auth.createUserWithEmailAndPassword(email: email, password: password,);
      if(result.user != null){
        await auth.currentUser.updateProfile(displayName: displayName);
        return auth.currentUser;
      }
    }catch(e){
      print(e);
      return throw e;
    }
  }
  static logoutMail()async{
    await Future.delayed(Duration(milliseconds: 1000));
    await auth.signOut();
  }
}