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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserProvider>(context, listen: false).readUserIDFromLocal();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<UserProvider>(context).id == null) {
      return LoginView();
    }
    if (Provider.of<UserProvider>(context).nickname == null) {
      return const NickNameSettingView();
    }
    return const MainView();
  }
}
