import 'package:currency_picker/currency_picker.dart';
import 'package:flag/flag.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:trablock_flutter/main.dart';
import 'package:trablock_flutter/src/method/DialogMethod.dart';
import 'package:trablock_flutter/src/model/TravelModel.dart';
import 'package:trablock_flutter/src/provider/TravelProvider.dart';
import 'package:trablock_flutter/src/provider/UserProvider.dart';
import 'package:trablock_flutter/src/view/TravelInfoView.dart';

class AddTravelView extends StatefulWidget {
  const AddTravelView({Key? key}) : super(key: key);

  @override
  State<AddTravelView> createState() => _AddTravelViewState();
}

class _AddTravelViewState extends State<AddTravelView> {
  late TravelProvider travelProvider;
  late UserProvider userProvider;
  String _travelPeriod = '';
  int _usedDate = 0;
  final TextEditingController _destinationTextEditingController = TextEditingController();
  final TextEditingController _numberOfPeopleTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    travelProvider = Provider.of<TravelProvider>(context,listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    bool? displayFlagPicker;

    return Scaffold(
      appBar: AppBar(
        title: const Text("여행 설정"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "여행지",
                style: TextStyle(
                    fontSize: 30
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: TextField(
                controller: _destinationTextEditingController,
              )
            ),
            Container(
              height: 1,
              color: Colors.black,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "여행 인원",
                style: TextStyle(
                    fontSize: 30
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.5,
                    child: TextField(
                      controller: _numberOfPeopleTextEditingController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "명",
                    style: TextStyle(
                        fontSize: 20
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 1,
              color: Colors.black,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "여행 기간",
                style: TextStyle(
                    fontSize: 30
                ),
              ),
            ),
            SfDateRangePicker(
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                _travelPeriod = '${DateFormat('yyyy/MM/dd').format(args.value.startDate)}-${DateFormat('yyyy/MM/dd').format(args.value.endDate ?? args.value.startDate)}';
                if (args.value.endDate != null) {
                  _usedDate = args.value.endDate.difference(args.value.startDate).inDays + 1;
                }
              },
              selectionMode: DateRangePickerSelectionMode.range,
            ),
            Container(
              height: 1,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  height: MediaQuery.of(context).size.height*0.08,
                  width: MediaQuery.of(context).size.width*0.5,
                  child: TextButton(
                      onPressed: () {
                        if (_destinationTextEditingController.text.isEmpty) {
                          inputDataEmptyAlertDialogInSetTravelView(context, "여행지");
                          return;
                        }
                        if (_numberOfPeopleTextEditingController.text.isEmpty) {
                          inputDataEmptyAlertDialogInSetTravelView(context, "여행인원");
                          return;
                        }
                        if (_travelPeriod.isEmpty) {
                          unselectedDataAlertDialogInSetTravelView(context, "여행 기간");
                          return;
                        }
                        travelProvider.addTravelToFireStore(userProvider.id!, _destinationTextEditingController.text, int.parse(_numberOfPeopleTextEditingController.text), _travelPeriod, _usedDate);
                        Navigator.pop(context);
                      },
                      child: const Text("확인", style: TextStyle(color: Colors.black, fontSize: 20),)
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}