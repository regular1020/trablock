import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trablock_flutter/src/provider/UserProvider.dart';
import 'package:trablock_flutter/src/view/RoutingView.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      UserProvider provider = Provider.of<UserProvider>(context, listen: false);
      await provider.readUserIDFromLocal();
      await provider.checkIDFromFirebase();
    });
    Timer(Duration(milliseconds: 1500), () {
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => RoutingView()
      )
      );
    });
  }


  @override
  Widget build(BuildContext context) {

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: screenHeight * 0.384375),
              const Expanded(child: SizedBox()),
              Align(
                child: Text("© Copyright 2022, 트래블럭(Trablock)",
                    style: TextStyle(
                      fontSize: screenWidth*( 14/360), color: Color.fromRGBO(255, 255, 255, 0.6),)
                ),
              ),
              SizedBox( height: MediaQuery.of(context).size.height*0.0625,),
            ],
          ),
        ),
      ),
    );
  }
}
