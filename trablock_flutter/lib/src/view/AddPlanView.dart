import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trablock_flutter/src/model/TravelModel.dart';
import 'package:trablock_flutter/src/provider/AddPlanViewProvider.dart';
import 'package:trablock_flutter/src/provider/SelectedTravelProvider.dart';
import 'package:trablock_flutter/src/const/addPlanConsts';

class AddPlanView extends StatelessWidget {
  AddPlanView({super.key});

  final TextEditingController _planNameController = TextEditingController();
  final TextEditingController _planHourController = TextEditingController();
  final TextEditingController _planMinuteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Travel travel = Provider.of<SelectedTravelProvider>(context).travel;
    SelectedTravelProvider provider = Provider.of<SelectedTravelProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("일정 관리"),
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
              } else if (Provider.of<AddPlanViewProvider>(context, listen: false).dropDownValue == null) {

              } else {
                if (_planHourController.text == "") {
                  _planHourController.text = "0";
                  return;
                }
                if (_planMinuteController.text == "") {
                  _planMinuteController.text = "0";
                  return;
                }
                provider.addNewPlace(_planNameController.text, int.parse(_planHourController.text), int.parse(_planMinuteController.text), Provider.of<AddPlanViewProvider>(context, listen: false).dropDownValue!);
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
          ),
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Row(
              children: [
                const Text("종류 : "),
                DropdownButton<String>(
                  value: Provider.of<AddPlanViewProvider>(context).dropDownValue,
                  onChanged: (String? value) {
                    Provider.of<AddPlanViewProvider>(context, listen: false).setDropDownValue(value);
                  },
                  items: categoryList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList()
                )
              ],
            ),
          )
        ]
      ),
    );
  }
}