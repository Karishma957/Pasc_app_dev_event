import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../frbsChat.dart';
import '../morseCode.dart';
import '../screens/normal_home_page.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';

import '../frbsAuth.dart';
import 'log_in_page.dart';

class SpecialHomePage extends StatefulWidget {
  @override
  _SpecialHomePageState createState() => _SpecialHomePageState();
}

class _SpecialHomePageState extends State<SpecialHomePage> {
  String messageFormed = '',msgfmeng='';
  final searchValue = TextEditingController();
  final List

  messages

  = [
    {
      'sender': 'aryan@gmail.com',
      'lastMessage': 'This is the last message sent to this contact by this pnone number'
    },
    {
      'sender': 'utkarsh@gmail.com',
      'lastMessage': 'This is the last message sent to this contact b  aaaaaaaaaaaaaaaaaaaaa'
    },
    {
      'sender': 'name lastName 3',
      'lastMessage': 'This is the last message sent to this contact  bbbbbbbbbbbbbbbb'
    },
    {
      'sender': 'name lastName 4',
      'lastMessage': 'This is the last message sent to this contact ccccccccccc'
    },
    {
      'sender': 'name lastName 5',
      'lastMessage': 'This is the last message sent to this contact cccccccccccccc'
    },
    {
      'sender': 'name lastName 6',
      'lastMessage': 'This is the last message sent to this contact cccccccccccccc'
    },
    {
      'sender': 'name lastName 7',
      'lastMessage': 'This is the last message sent to this contact cccccccccccccc'
    },
    {
      'sender': 'name lastName 8',
      'lastMessage': 'This is the last message sent to this contactcccccccccccccc'
    },
    {
      'sender': 'name lastName 5',
      'lastMessage': 'This is the last message sent to this contactcccccccccccccc'
    },
  ];
  List letters = [];
  List word = [];
  double initialX = 0.0;
  double distanceX = 0.0;
  double initialY = 0.0;
  double distanceY = 0.0;
  Timer timer;
  int timePassed = 0;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        timePassed++;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void resetTimer() {
    timePassed = 0;
  }

  singlemsgconversion(){
    try{
      if(messageFormed.length==5){
        msgfmeng=(MorseCode.numbers.indexOf(messageFormed).toString());
      }else
      if(messageFormed.length<5){
        msgfmeng=(MorseCode.alphabets[messageFormed].toString());
      }else{
        msgfmeng="invalid";
      }
    }catch(e){
      print(e);
    }
  }

  void vibrateMorse(pattern){
    Vibration.vibrate(
      pattern: pattern,
    );
  }

  void executeVibrate(List mList){
    List<int> vibrationPattern=[];
    print(mList);
    int pause=0;
    for (int j = 0; j < mList.length; j++) {
      pause+=600;
      for (int i = 0; i < mList[j].length; i++) {
        if(mList[j][i]=='.') {
          vibrationPattern.add(pause);
          vibrationPattern.add(400);
          pause=600;
        }
        else if(mList[j][i]=='-'){
          vibrationPattern.add(pause);
          vibrationPattern.add(800);
          pause=600;
        }
        else{
          pause=2400;
        }
      }
    }
    print(vibrationPattern);
    vibrateMorse(vibrationPattern);
  }

  ChatListPage(){
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .backgroundColor,
      appBar: AppBar(
        title: Text(FRBSChat.receiver==""?'CHATS':FRBSChat.receiver),
        elevation: 0,
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
                autocorrect: true,
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
                              FRBSChat.receiver=messages[index]['sender'];
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical:13.0,horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  FRBSChat.myMsgs[index]['sender'],
                                  style: Theme
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
      StreamBuilder(
          stream: FRBSChat.firebaseFirestore.collection("messages").snapshots(),
          builder: (context,i){
            int c=FRBSChat.myMsgs.length;
            FRBSChat.receiveMsg();
            if(FRBSChat.myMsgs.length!=c){
              var a=FRBSChat.myMsgs[0]["data"];
              var b=[];
              for(var d in a.split("")){
                b.add(d);
              }
              executeVibrate(b);
            }
            print(FRBSChat.myMsgs);
            return Container(
              //height: MediaQuery.of(context).size.height -
              //    MediaQuery.of(context).padding.top,
              //width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(8.0),
              child: FRBSChat.myMsgs.isNotEmpty?Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              ):Container(),
            );
          }
      ),
    );
  }

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
        backgroundColor: Theme.of(context).backgroundColor,
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
        body: GestureDetector(
          //time stop,time compare,time reset, and append letter
          onTapDown: (_) {
            if (timer != null) timer.cancel();
            else if(timePassed>3) resetTimer();
            else if (timePassed > 1) {
              if(messageFormed!=""){
                letters.add(messageFormed);
              }
              print(letters);
              setState(() {
                messageFormed = '';
                msgfmeng='';
              });
            }
          },
          //append message string,start time
          onTapUp: (_) {
            setState(() {
              messageFormed += '.';
              singlemsgconversion();
            });
            startTimer();
          },
          //time stop,time compare,time reset, and append letter
          onLongPressStart: (_) {
            if (timer != null) timer.cancel();
            else if(timePassed>3) resetTimer();
            else if (timePassed > 1) {
              if(messageFormed!=""){
                letters.add(messageFormed);
              }
              print(letters);
              setState(() {
                messageFormed = '';
              });
            }
          },
          //append message string,start time
          onLongPressEnd: (_) {
            setState(() {
              messageFormed += '-';
              singlemsgconversion();
            });
            startTimer();
          },
          onHorizontalDragStart: (DragStartDetails details) {
            initialX = details.globalPosition.dx;
          },
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            distanceX = details.globalPosition.dx - initialX;
          },
          onHorizontalDragEnd: (DragEndDetails detail) {
            if (timer != null) timer.cancel();
            initialX = 0;
            initialY = 0;
            //left swipe
            //timer stop, reset
            //message empty string
            if (distanceX.isNegative) {
              setState(() {
                print("erased");
              });
            }
            //right swipe
            //timer stop, reset
            //letter append, word append=' ' , word append letters list, letter=[],message='',
            else {
              if(messageFormed!=""){
                letters.add(messageFormed);
              }
              word.add(letters);
              word.add([' ']);
              letters=[];
              print('space');
            }
            setState(() {
              messageFormed = '';
              msgfmeng=" ";
            });
            resetTimer();
          },
          onVerticalDragStart: (DragStartDetails details) {
            initialY = details.globalPosition.dy;
          },
          onVerticalDragUpdate: (DragUpdateDetails details) {
            distanceY = details.globalPosition.dy - initialY;
          },
          onVerticalDragEnd: (DragEndDetails detail)async {
            if (timer != null) timer.cancel();
            initialY = 0;
            initialX = 0;
            //upward swipe
            //timer stop, reset
            //letter append,word append,print word, empty all 3
            if (distanceY.isNegative) {
              if(messageFormed!=""){
                letters.add(messageFormed);
              }
              word.add(letters);
              if(word.isNotEmpty) {
                print(word);
                await Future.delayed(Duration(seconds: 1));
                try{
                  for(int i=0;i<word.length;i++){
                    executeVibrate(word[i]);
                  }
                  FRBSChat.sendMsg(MorseCode.convertSentences(1, word));
                }catch(e){
                  print(e);
                }
              }
              setState(() {
                messageFormed="";
                word=[];
                letters=[];
              });
              print('sent');
            }
            //downward swipe
            //timer stop, reset
            //letter append,word append, word append \n,empty letter,empty message
            else {
              if(messageFormed!=""){
                letters.add(messageFormed);
                print(letters);
                //word.add(letters);
              }
              //word.add(['\n']);
              //letters=[];
              print('newline');
            }
            setState(() {
              messageFormed = '';
              msgfmeng='';
            });
            distanceX = 0;
            distanceY = 0;
            //resetTimer();
          },
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                  child: ChatListPage(),
              ),
              Expanded(
                child: Container(
                  //height: MediaQuery.of(context).size.height -
                  //MediaQuery.of(context).padding.top,
                  //width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      msgfmeng,
                      style: Theme.of(context).textTheme.headline6,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  //height: MediaQuery.of(context).size.height -
                      //MediaQuery.of(context).padding.top,
                  //width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      messageFormed,
                      style: Theme.of(context).textTheme.headline6,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}