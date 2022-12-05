import 'package:flutter/material.dart';
import 'package:trablock_flutter/src/model/PlaceModel.dart';

class AddTravelView extends StatefulWidget {
  const AddTravelView({Key? key}) : super(key: key);

  @override
  State<AddTravelView> createState() => _AddTravelViewState();
}

class _AddTravelViewState extends State<AddTravelView> {
  List<Place> places = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // SizedBox(
          //   width: MediaQuery.of(context).size.width*0.8,
          //   child: ReorderableListView(
          //     onReorder: (int oldIndex, int newIndex)
          //     {
          //
          //     },
          //     children: [
          //
          //     ],
          //   ),
          // )
          SizedBox(
            width: MediaQuery.of(context).size.width*0.2,
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return IconButton(
                    onPressed: () {

                    },
                    icon: const Icon(Icons.add)
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
