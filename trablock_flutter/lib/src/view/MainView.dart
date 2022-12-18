import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trablock_flutter/src/model/TravelModel.dart';
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
        title: const Text("내 여행"),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Text(
                "메뉴",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30
                ),
              ),
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTravelView()));
        }
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: travels.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                "${travels[index].destination}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container()
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              "여행인원 : ${travels[index].numberOfPeople.toString()}명",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              "출발일자 : ${travels[index].period.split(" - ")[0]}",
                              style: const TextStyle(
                                color: Colors.white
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0, bottom: 5),
                            child: Text(
                              "도착일자 : ${travels[index].period.split(" - ")[1]}",
                              style: const TextStyle(
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Provider.of<TravelProvider>(context, listen: false).selectTravel(travels[index].id);
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
