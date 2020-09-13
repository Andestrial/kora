import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:kora/core/ui/stateLessWidgets.dart/inputText.dart';
import 'package:kora/domain/filter.dart';
import 'package:kora/resources/colors/colors.dart';

class Filter extends StatelessWidget {
  final StreamController<FilterData> controller;
  Filter({Key key, this.controller}) : super(key: key);

  
  final GlobalKey<FormBuilderState> _fKey = GlobalKey<FormBuilderState>();
  TextEditingController modelController = TextEditingController();
  TextEditingController materialController = TextEditingController();
  TextEditingController sizeFromController = TextEditingController();
  TextEditingController sizeToController = TextEditingController();
  TextEditingController priceFromController = TextEditingController();
  TextEditingController priceToController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(13), 
          topRight: Radius.circular(13)
        ),
        child: Container(
          height: 400,
          margin: MediaQuery.of(context).viewInsets,
          padding: EdgeInsets.only(left: 17, right: 17, bottom: 20, top: 5),
          decoration: BoxDecoration(
            color: Color.fromRGBO(78, 78, 78, 1),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(13), topRight: Radius.circular(13))
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 45,
                  ),
                ),
              ),
              FormBuilder(
                key: _fKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InputText(
                        attribute: 'Model',
                        title: 'Модель',
                        controller: modelController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InputText(
                        attribute: 'Material',
                        title: 'Матеріал',
                        controller: materialController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: InputText(
                                attribute: 'SizeFrom',
                                title: 'Розмір',
                                controller: sizeFromController,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: InputText(
                                attribute: 'SizeTo',
                                title: '',
                                controller: sizeToController,
                              ),
                            )
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: InputText(
                                attribute: 'PriceFrom',
                                title: 'Ціна',
                                controller: priceFromController,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: InputText(
                                attribute: 'PriceTo',
                                title: '',
                                controller: priceToController,
                              ),
                            )
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 3,
                      child: InkWell(
                        onTap: () {
                          var fData = null;
                          controller.add(fData);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Скинути',
                          style: TextStyle(
                            color: blueColor,
                            fontSize: 14
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: InkWell(
                        onTap: () {
                          _fKey.currentState.save();
                          var fData = FilterData(
                            //model: modelController.text,
                            model: _fKey.currentState.value['Model'],
                            material: _fKey.currentState.value['Material'],
                            sizeFrom: double.tryParse(_fKey.currentState.value['SizeFrom']),
                            sizeTo: double.tryParse(_fKey.currentState.value['SizeTo']),
                            priceFrom: double.tryParse(_fKey.currentState.value['PriceFrom']),
                            priceTo: double.tryParse(_fKey.currentState.value['PriceTo'])
                          );
                          controller.add(fData);
                          Navigator.pop(context);
                          //_fKey.currentState.reset();
                        },
                        child: Text(
                          'Застосувати',
                          style: TextStyle(
                            color: blueColor,
                            fontSize: 14
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}