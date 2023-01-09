import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trablock_flutter/src/provider/UserProvider.dart';
import 'package:trablock_flutter/src/view/LoginView.dart';
import 'package:trablock_flutter/src/view/MainView.dart';
import 'package:trablock_flutter/src/view/NickNameSettingView.dart';


class RoutingView extends StatefulWidget {
  const RoutingView({Key? key}) : super(key: key);

  @override
  State<RoutingView> createState() => _RoutingViewState();
}

class _RoutingViewState extends State<RoutingView> {
  int? _flag;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      UserProvider provider = Provider.of<UserProvider>(context, listen: false);
      await provider.readUserIDFromLocal();
      await provider.checkIDFromFirebase();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _flag = Provider.of<UserProvider>(context).getRoutingFlagFromUserInformation();
    if (_flag == null) {
      return const CircularProgressIndicator();
    }
    if (_flag == 1) {
      return LoginView();
    }
    if (_flag == 2) {
      return NickNameSettingView();
    }
    return const MainView();
  }
}
