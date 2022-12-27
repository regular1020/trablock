import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:trablock_flutter/src/model/TravelModel.dart';
import 'package:trablock_flutter/src/provider/SelectedTravelProvider.dart';

class AddPlanView extends StatelessWidget {
  AddPlanView({super.key});

  final TextEditingController _planNameController = TextEditingController();
  final TextEditingController _planHourController = TextEditingController();
  final TextEditingController _planMinuteController = TextEditingController();
  late SelectedTravelProvider provider;

  @override
  Widget build(BuildContext context) {
    Travel travel = Provider.of<SelectedTravelProvider>(context).travel;
    provider = Provider.of<SelectedTravelProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("${travel.destination}여행 새 일정 추가"),
        actions: [
          IconButton(
            onPressed: () {
              if (_planNameController.text == "") {
                showDialog(
                  context: context, 
                  builder: ((context) => AlertDialog(
                    title: const Text("일정명을 입력해주세요."),
                    actions: [
                      TextButton(child: const Text("확인"), onPressed: () => Navigator.pop(context),)
                    ],
                  ))
                );
              } else if (_planHourController.text == "" && _planMinuteController.text == "") {
                showDialog(
                  context: context, 
                  builder: ((context) => AlertDialog(
                    title: const Text("소요시간을 입력해주세요."),
                    actions: [
                      TextButton(child: const Text("확인"), onPressed: () => Navigator.pop(context),)
                    ],
                  ))
                );
              } else {
                if (_planHourController.text == "") {
                  _planHourController.text = "0";
                }
                if (_planMinuteController.text == "") {
                  _planMinuteController.text = "0";
                }
                provider.addNewPlace(_planNameController.text, int.parse(_planHourController.text), int.parse(_planMinuteController.text));
                Navigator.pop(context);
              }
            }, 
            icon: const Icon(Icons.check)
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Row(
              children: [
                const Text("이름 : "),
                Expanded(
                  child: TextField(
                    controller: _planNameController,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Row(
              children: [
                const Text("소요시간 : "),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.2,
                  child: TextField(
                    controller: _planHourController,
                  ),
                ),
                const Text("시간"),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.2,
                  child: TextField(
                    controller: _planMinuteController,
                  ),
                ),
                const Text("분"),
              ],
            ),
          )
        ]
      ),
    );
  }
}