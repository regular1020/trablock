import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trablock_flutter/src/provider/AuthProvider.dart';
import 'package:trablock_flutter/src/view/LoginWithGoogleView.dart';


class RoutingView extends StatelessWidget {
  const RoutingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.user == null) {
      return LoginWithGoogleView();
    } else {
      return Container();
    }
  }
}
