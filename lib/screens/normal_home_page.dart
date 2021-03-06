import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pulzion_app/frbsAuth.dart';
import 'package:pulzion_app/frbsChat.dart';

import 'log_in_page.dart';

class NormalHomePage extends StatefulWidget {
  @override
  _NormalHomePageState createState() => _NormalHomePageState();
}

class _NormalHomePageState extends State<NormalHomePage> {
  final sendValue = TextEditingController();
  final searchValue = TextEditingController();
  @override
  Widget build(BuildContext context) {
    FRBSChat.sender=FRBSAuth.auth.currentUser.email;
    return WillPopScope(
      onWillPop: ()async{
        if(FRBSChat.receiver==""){
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }else{
          setState(() {
            FRBSChat.receiver="";
          });
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme
            .of(context)
            .backgroundColor,
        appBar: AppBar(
          title: Text(FRBSChat.receiver==""?'CHATS':FRBSChat.receiver),
          elevation: 0,
        ),
        drawer: Drawer(
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 200,),
                Text(FRBSChat.sender, style: Theme
                    .of(context)
                    .textTheme
                    .bodyText1,),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                    onPressed: ()async{
                      await setVisitingFlag(false, "","","");
                      await FRBSAuth.logoutMail();
                      FRBSChat.receiver="";
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LogInPage()),
                      );
                    },
                    child: Text("Logout")
                ),
              ],
            ),
          ),
        ),
        body: FRBSChat.receiver==""?Column(
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(16)),
                child: TextField(
                  controller: searchValue,
                  onSubmitted: (String input) {
                    print(input.toUpperCase());
                  },
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyText1,
                  decoration: InputDecoration(
                    prefixIcon: GestureDetector(
                      onTap: ()async{
                        if(await FRBSChat.isEmailthere(searchValue.text.toString().trim())){
                          if(searchValue.text.toString().trim()!=FRBSChat.sender){
                            setState(() {
                              FRBSChat.receiver=searchValue.text.toString().trim();
                            });
                          }
                        }
                      },
                      child: Icon(
                        Icons.search,
                        color: Colors.black87,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(7),
                    border: InputBorder.none,
                    hintText: 'Search Name',
                    hintStyle: Theme
                        .of(context)
                        .textTheme
                        .caption,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                ),
              ),
            ),
            StreamBuilder(
                stream: FRBSChat.firebaseFirestore.collection("messages").snapshots(),
                builder: (context,i){
                  FRBSChat.receiveMsg();
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: FRBSChat.myMsgs.length==0?
                      Container():
                      ListView.builder(
                        itemCount: FRBSChat.myMsgs.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: (){
                              setState(() {
                                print(FRBSChat.myMsgs[index]['sender']);
                                FRBSChat.receiver=FRBSChat.myMsgs[index]['sender'];
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical:13.0,horizontal: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(FRBSChat.myMsgs[index]['sender'], style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyText1,),
                                  SizedBox(
                                    height: 3.0,
                                  ),
                                  Text("To: "+
                                      FRBSChat.myMsgs[index]['receiver'],
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyText2,),
                                  SizedBox(
                                    height: 3.0,
                                  ),
                                  Text(FRBSChat.myMsgs[index]['data'], style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyText2, maxLines: 1, overflow: TextOverflow.clip,),
                                  Divider(color: Theme
                                      .of(context)
                                      .primaryColor,)
                                ],
                              ),
                            ),
                          );
                        },),
                    ),
                  );
                }
            ),
          ],
        ):
        Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FRBSChat.firebaseFirestore.collection("messages").snapshots(),
                  builder: (context,i){
                    FRBSChat.receiveMsg();
                    return Container(
                      //height: MediaQuery.of(context).size.height -
                      //    MediaQuery.of(context).padding.top,
                      //width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(8.0),
                      child: FRBSChat.myMsgs.isNotEmpty?Column(
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              margin: FRBSChat.myMsgs[0]['sender']==FRBSChat.sender
                                  ? EdgeInsets.only(
                                top: 8.0,
                                bottom: 8.0,
                                left: 80.0,
                              )
                                  : EdgeInsets.only(
                                top: 8.0,
                                bottom: 8.0,
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                              width: MediaQuery.of(context).size.width * 0.75,
                              decoration: BoxDecoration(
                                color:
                                Colors.blue[600],
                                borderRadius: FRBSChat.myMsgs[0]['sender']==FRBSChat.sender
                                    ? BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  bottomLeft: Radius.circular(15.0),
                                )
                                    : BorderRadius.only(
                                  topRight: Radius.circular(15.0),
                                  bottomRight: Radius.circular(15.0),
                                ),
                              ),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 8.0),
                                  Text(
                                      FRBSChat.myMsgs[0]['data'],
                                      style: Theme.of(context).textTheme.bodyText1
                                  ),
                                  SizedBox(height: 8,),
                                  Text(
                                      FRBSChat.myMsgs[0]['time'],
                                      style: TextStyle(
                                          fontSize: 8,
                                          color: Colors.white54
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ]
                      ):Expanded(child: Container()),
                    );
                  }
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(16)),
                child: TextField(
                  controller: sendValue,
                  onSubmitted: (String input) {
                    print(input.toUpperCase());
                  },
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyText1,
                  decoration: InputDecoration(
                    prefixIcon: GestureDetector(
                      onTap: ()async{
                        try{
                          FRBSChat.sendMsg([sendValue.text.toUpperCase().split("")]);
                          sendValue.text="";
                        }catch(e){
                          print(e);
                        }
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.black87,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(7),
                    border: InputBorder.none,
                    hintText: 'Enter message',
                    hintStyle: Theme
                        .of(context)
                        .textTheme
                        .caption,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}