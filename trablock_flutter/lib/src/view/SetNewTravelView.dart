import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:trablock_flutter/src/const/destinations.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SetNewTravelView extends StatefulWidget {
  const SetNewTravelView({Key? key}) : super(key: key);

  @override
  State<SetNewTravelView> createState() => _SetNewTravelViewState();
}

class _SetNewTravelViewState extends State<SetNewTravelView> {
  String _selectedContinent = "";
  String _selectedCountry = "";
  String _selectedCity = "";
  String _range = '';
  int _usedDate = 0;
  bool _destinationInputFieldRequire = false;
  TextEditingController destinationTextEditingController = TextEditingController();
  TextEditingController numberOfPeopleTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("새 여행"),
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
              child: Row(
                children: [
                  DropdownButton(
                    value: _selectedContinent.isNotEmpty ? _selectedContinent : null,
                    items: destinationList.keys.map((String dest) {
                      return DropdownMenuItem<String>(
                        value: dest,
                        child: Text(dest),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedContinent = value!;
                        _selectedCountry = "";
                        _selectedCity = "";
                      });
                    }
                  ),
                  Builder(
                    builder: (context) {
                      if (_selectedContinent.isEmpty)
                      {
                        return Container();
                      }
                      else if (_selectedContinent == "직접입력") {
                        return Container();
                      }
                      else {
                        List<String> countrys = List<String>.from(destinationList[_selectedContinent]!.keys.toList());
                        return DropdownButton(
                            value: _selectedCountry.isNotEmpty ? _selectedCountry : null,
                            items: countrys.map((String dest) {
                              return DropdownMenuItem<String>(
                                value: dest,
                                child: Text(dest),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCountry = value!;
                                _selectedCity = "";
                                if (value == "직접입력") {
                                  _destinationInputFieldRequire = true;
                                } else {
                                  _destinationInputFieldRequire = false;
                                }
                              });
                            }
                        );
                      }
                    }
                  ),
                  Builder(
                    builder: (context) {
                      if (_selectedCountry.isEmpty)
                      {
                        return Container();
                      }
                      else if (_selectedCountry == "직접입력") {
                        return Container();
                      }
                      else {
                        List<String> cities = List<String>.from(destinationList[_selectedContinent]![_selectedCountry]!);
                        return DropdownButton(
                            value: _selectedCity.isNotEmpty ? _selectedCity : null,
                            items: cities.map((String dest) {
                              return DropdownMenuItem<String>(
                                value: dest,
                                child: Text(dest),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCity = value!;
                                if (value == "직접입력") {
                                  _destinationInputFieldRequire = true;
                                } else {
                                  _destinationInputFieldRequire = false;
                                }
                              });
                            }
                        );
                      }
                    }
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: !_destinationInputFieldRequire ? Container() : SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  controller: destinationTextEditingController,
                  decoration: const InputDecoration(
                    hintText: "여행 목적지를 입력하세요",
                  ),
                ),
              ),
            ),
            Container(
              height: 3,
              color: Colors.blueGrey,
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
                      controller: numberOfPeopleTextEditingController,
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
              height: 3,
              color: Colors.blueGrey,
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
                _range = '${DateFormat('yyyy/MM/dd').format(args.value.startDate)} - ${DateFormat('yyyy/MM/dd').format(args.value.endDate ?? args.value.startDate)}';
                if (args.value.endDate != null) {
                  _usedDate = args.value.endDate.difference(args.value.startDate).inDays;
                  print(_usedDate);
                }
              },
              selectionMode: DateRangePickerSelectionMode.range,
            ),
            Container(
              height: 3,
              color: Colors.blueGrey,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  height: MediaQuery.of(context).size.height*0.08,
                  width: MediaQuery.of(context).size.width*0.5,
                  child: TextButton(
                      onPressed: () {

                      },
                      child: const Text("다음", style: TextStyle(color: Colors.white, fontSize: 20),)
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
