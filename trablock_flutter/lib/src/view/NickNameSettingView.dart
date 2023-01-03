import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trablock_flutter/src/provider/UserProvider.dart';

class NickNameSettingView extends StatefulWidget {
  const NickNameSettingView({Key? key}) : super(key: key);

  @override
  State<NickNameSettingView> createState() => _NickNameSettingViewState();
}

class _NickNameSettingViewState extends State<NickNameSettingView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("닉네임 설정"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "닉네임을 입력하세요"
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height*0.08,
            width: MediaQuery.of(context).size.width*0.5,
            child: TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  userProvider.addUserNickNameToFireStore(userProvider.id!, controller.text);
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: const Text("닉네임을 입력하십시오."),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("확인"),
                            )
                          ],
                        );
                      }
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.grey;
                  } else {
                    return Colors.indigo;
                  }
                }),
              ),
              child: const Text("설정", style: TextStyle(color: Colors.white, fontSize: 20),),
            ),
          ),
        ],
      ),
    );
  }
}
