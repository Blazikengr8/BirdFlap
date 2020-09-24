import 'dart:async';

import 'package:birdflap/barriers.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'bird.dart';
import 'main.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdYaxis = 0;
  double time = 0;
  double height = 0;
  double initialHeight = birdYaxis;
  bool gameHasStarted = false;
  static double barrierXone = 1;
  double barrierXtwo = barrierXone + 1.2;
  double check1=0.5;
  double check2=-0.7;
  int flag=1;
  int flag1=0;
  int counter=0;
  int maxcount=48;
  List<myData> allData=[];
  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYaxis;
    });
  }
  void send() {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    var data = {
      "score": counter,
    };
    ref.child('scorer').push().set(data);
  }

   startGame() {
    // maxcount=allData[allData.length-1].score;
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 45), (timer) {
      time += 0.04;
      height = -4.9 * time * time + 2.6 * time; // -4.9 t^2 + v*t
      setState(() {
        birdYaxis = initialHeight - height;
      });
      setState(() {
        if (barrierXone < -1.1) {
          barrierXone += 2.2;
        } else {
          barrierXone -= 0.035;
        }
      });

      setState(() {
        if (barrierXtwo < -1.1) {
          barrierXtwo += 2.2;
        } else {
          barrierXtwo -= 0.035;
        }
      });
      if (birdYaxis<check2||birdYaxis>check1) {
        timer.cancel();
        gameHasStarted = false;
        birdYaxis = 0;
         time = 0;
         height = 0;
         initialHeight = birdYaxis;
         gameHasStarted = false;
         barrierXone = 1;
         barrierXtwo = barrierXone + 1.2;
         check1=0.4;
        check2=-0.7;
        if(maxcount<counter)
          {
            send();
          }

          DatabaseReference ref=FirebaseDatabase.instance.reference();
          ref.child('scorer').once().then((DataSnapshot snap) {
            var keys=snap.value.keys;
            var data=snap.value;
            for(var key in keys)
            {
              allData.add(new myData(data[key]['score'],));
            }
          });
          allData.sort((a,b)=>a.score.compareTo(b.score));
          maxcount=allData[allData.length-1].score;
          counter=0;
          maxcount=allData[allData.length-1].score;
        //  Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    DatabaseReference ref=FirebaseDatabase.instance.reference();
    ref.child('scorer').once().then((DataSnapshot snap) {
      var keys=snap.value.keys;
      var data=snap.value;
      for(var key in keys)
      {
        allData.add(new myData(data[key]['score'],));
      }
    });
    allData.sort((a,b)=>a.score.compareTo(b.score));

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {

          jump();counter++;
        } else {
          startGame();counter++;
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    AnimatedContainer(
                      alignment: Alignment(0, birdYaxis), //b'w -1 to 1
                      duration: Duration(milliseconds: 0),
                      color: Colors.blue,
                      child: MyBird(),
                    ),
                    Container(
                      alignment: Alignment(0, -0.3),
                      child: gameHasStarted
                          ? Text("")
                          : Text(
                              "T A P  T O  P L A Y",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXone, 1.09),
                      duration: Duration(milliseconds: 0),
                      child: MyBarrier(
                        size: 200.0,
                      ),
                      onEnd: (){
                        check2=-0.7;
                      },
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXone, -1.09),
                      duration: Duration(milliseconds: 0),
                      child: MyBarrier(

                        size: 160.0,
                      ),
                      onEnd: (){
                        check1=0.47;

                      },
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXtwo, 1.09),
                      duration: Duration(milliseconds: 0),
                      child: MyBarrier(
                        size: 120.0,
                      ),
                      onEnd: (){
                        check2=-0.75;
                      },
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXtwo, -1.09),
                      duration: Duration(milliseconds: 0),
                      child: MyBarrier(
                        size: 210.0,
                      ),
                      onEnd: (){
                        check1=0.8;
                      },
                    ),
                  ],
                )),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "SCORE",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          counter.toString(),
                          //"0",
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "BEST",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        maxcount!=null
                        ?Text(
                          maxcount.toString(),
                          //"0",
                          style: TextStyle(color: Colors.white, fontSize: 35))
                        :Text("Loading...",style: TextStyle(color: Colors.white, fontSize: 35))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
