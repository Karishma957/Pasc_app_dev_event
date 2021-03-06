import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../frbsAuth.dart';
import '../frbsChat.dart';
import './log_in_page.dart';
import 'normal_home_page.dart';
import 'special_home_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String email = '';
  String username = '';
  String password = '';
  String error = '';
  bool hidePassword = true;
  TextEditingController emailController=TextEditingController();
  TextEditingController usernameController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  int group = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.075,),
            Container(
              height: MediaQuery.of(context).size.height * 0.85,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 7,
                    spreadRadius: 9,
                    offset: Offset(3, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Register", style: Theme.of(context).textTheme.headline6),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: usernameController,
                      style: Theme.of(context).textTheme.bodyText1,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(12),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.white70,
                        ),
                        border: InputBorder.none,
                        hintText: 'Enter Username',
                        hintStyle: Theme.of(context).textTheme.caption,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: Theme.of(context).textTheme.bodyText1,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(12),
                        prefixIcon: Icon(
                          Icons.mail,
                          color: Colors.white70,
                        ),
                        border: InputBorder.none,
                        hintText: 'Enter Email',
                        hintStyle: Theme.of(context).textTheme.caption,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: hidePassword,
                      style: Theme.of(context).textTheme.bodyText1,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(12),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.white70,
                        ),
                        suffixIcon: GestureDetector(
                          child: Icon(
                            Icons.remove_red_eye,
                            color: Colors.white,
                          ),
                          onTap: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                        ),
                        border: InputBorder.none,
                        hintText: 'Enter Password',
                        hintStyle: Theme.of(context).textTheme.caption,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:24.0),
                    child: Row(
                      children: [
                        Radio(
                            value: 1,
                            groupValue: group,
                            onChanged: (T) {
                              setState(() {
                                group = T;
                              });
                            }),
                        Text('Special',style: Theme.of(context).textTheme.caption,),
                        Spacer(),
                        Radio(
                            value: 2,
                            groupValue: group,
                            onChanged: (T) {
                              setState(() {
                                group = T;
                              });
                            }),
                        Text('Normal',style: Theme.of(context).textTheme.caption,),
                      ],
                    ),
                  ),
                  Container(
                      height: 50,
                      child: Center(
                          child: Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ))),
                  // ignore: deprecated_member_use
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                    color: Theme.of(context).buttonColor,
                    onPressed: ()async {
                      email=emailController.text.toString().trim();
                      password=passwordController.text.toString().trim();
                      username=usernameController.text.toString().trim();
                      if (email.length == 0 ||
                          password.length == 0 ||
                          username.length == 0) {
                        setState(() {
                          error = 'Enter valid credentials';
                        });
                      } else {
                        try{
                          User x=await FRBSAuth.signupEmail(email,password,username+group.toString());
                          await FRBSChat.firebaseFirestore.collection("users").add({
                            "email":email
                          });
                          setState(() {
                            if(x!=null){
                              setVisitingFlag(true, email, password, FRBSAuth.auth.currentUser.displayName);
                              Navigator.pushReplacement(context,
                                MaterialPageRoute(
                                    builder: (context) => FRBSAuth.auth.currentUser.displayName.endsWith("2")?
                                    NormalHomePage():SpecialHomePage()),
                              );
                            }
                          });
                        }catch(e){
                          setState(() {
                            error=e.toString().split("]")[1];
                          });
                        }
                      }
                      print(email + username + password+group.toString());
                    },
                    child: Text(
                      "Submit",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already a member? ',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            fontWeight: FontWeight.w400),
                      ),
                      // ignore: deprecated_member_use
                      FlatButton(
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.lightBlueAccent,
                                fontWeight: FontWeight.w400),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LogInPage()),
                            );
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ],

        ),
      ),
    );
  }
}
setVisitingFlag(b,e,p,n)async{
  SharedPreferences preferences=await SharedPreferences.getInstance();
  await preferences.setBool("userlogged",b);
  await preferences.setStringList("cred",[e,p,n]);
}