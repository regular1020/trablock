import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trablock_flutter/src/model/TravelModel.dart';
import 'package:trablock_flutter/src/provider/SelectedTravelProvider.dart';
import 'package:trablock_flutter/src/provider/TravelProvider.dart';
import 'package:trablock_flutter/src/provider/UserProvider.dart';
import 'package:trablock_flutter/src/view/AddTravelView.dart';
import 'package:trablock_flutter/src/view/TravelInfoView.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      TravelProvider travelProvider = Provider.of<TravelProvider>(context, listen: false);
      if (travelProvider.travels.isEmpty) {
        travelProvider.readTravelFromFireStore(Provider.of<UserProvider>(context, listen: false).id!);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Travel> travels = Provider.of<TravelProvider>(context).travels;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("내 여행"),
        centerTitle: true,
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Text(
                "메뉴",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30
                ),
              ),
            ),
            ListTile(
              title: const Text("새 여행"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTravelView()));
              },
            ),
            ListTile(
              title: const Text("내 정보"),
              onTap: () {
                // Todo : Navigate to user information view
              },
            ),
            ListTile(
              title: const Text("로그아웃"),
              onTap: () {
                // Todo : Logout
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: travels.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 1.3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,

                            )
                          ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                travels[index].destination,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 30
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Icon(Icons.airplanemode_on_outlined, color: Colors.primaries[Random().nextInt(Colors.primaries.length)], size: 100),
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              "여행인원 : ${travels[index].numberOfPeople.toString()}명",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              "출발일자 : ${travels[index].period.split("-")[0]}",
                              style: const TextStyle(
                                color: Colors.black
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0, bottom: 5),
                            child: Text(
                              "도착일자 : ${travels[index].period.split("-")[1]}",
                              style: const TextStyle(
                                  color: Colors.black
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Provider.of<SelectedTravelProvider>(context, listen: false).selectTravel(travels[index]);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TravelInfoView()));
                      // ToDo : Navigate to travel plan view
                    },
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
