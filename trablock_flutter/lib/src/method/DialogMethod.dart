import 'package:flutter/material.dart';

void inputDataEmptyAlertDialogInSetTravelView(BuildContext context, String missingDataName) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text("$missingDataName을(를) 입력해주세요."),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("확인")
          )
        ],
      );
    }
  );
}

void unselectedDataAlertDialogInSetTravelView(BuildContext context, String unselectedDataName) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text("$unselectedDataName을(를) 선택해주세요."),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("확인")
          )
        ],
      );
    }
  );
}