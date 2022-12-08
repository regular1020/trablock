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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      UserProvider provider = Provider.of<UserProvider>(context, listen: false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<UserProvider>(context, listen: false).getRoutingFlagFromUserInformation(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == 1) {
            return LoginView();
          }
          if (snapshot.data == 2) {
            return const NickNameSettingView();
          }
          return const MainView();
        }
        return const CircularProgressIndicator();
      }),
    );
  }
}
