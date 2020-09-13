import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_picker/Picker.dart';

class Pickers {
  List<PickerItem> pickerItem = [
    PickerItem(text: Text('EU'), value: 'EU'),
    PickerItem(text: Text('UA'), value: 'UA'),
    PickerItem(text: Text('GB'), value: 'GB'),
  ];

  sizePicker(BuildContext context, StreamController sizeController, TextEditingController controller) {
    Picker(
      height: 100,
      diameterRatio: 2,
      columnFlex: [2, 1],
      cancelText: 'Відміна',
      confirmText: 'Ok',
      itemExtent: 35,
      reversedOrder: true,
      hideHeader: true,
      onConfirm: (Picker picker, List<int> value){
          sizeController.add([
            controller,
            picker.getSelectedValues()[0].toString(),
          ]);
      },
      adapter: NumberPickerAdapter(
        data: [
          NumberPickerColumn(
            begin: 10, 
            end: 60,
            initValue: 30,
          ),
        ]
      )
    ).showDialog(context);
  }

  typeSizePicker(BuildContext context, StreamController typeSizeController, TextEditingController controller) {
    Picker(
      height: 100,
      diameterRatio: 2,
      columnFlex: [2, 1],
      cancelText: 'Відміна',
      confirmText: 'Ok',
      itemExtent: 35,
      reversedOrder: true,
      hideHeader: true,
      onConfirm: (Picker picker, List<int> value){
          typeSizeController.add([
            controller,
            picker.getSelectedValues()[0].toString(),
          ]);
      },
      adapter: PickerDataAdapter(
          data: pickerItem
        )
    ).showDialog(context);
  }
}