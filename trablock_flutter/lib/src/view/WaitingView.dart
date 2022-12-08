import 'package:flutter/material.dart';

class WaitingView extends StatelessWidget {
  const WaitingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // Todo: 로딩 화면 만들어서 추가하기
      body: Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}
