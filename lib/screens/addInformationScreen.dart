import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:kora/core/ui/stateLessWidgets.dart/mainButton.dart';
import 'package:kora/core/ui/stateLessWidgets.dart/startEllipse.dart';
import 'package:kora/domain/user.dart';
import 'package:kora/resources/colors/colors.dart';
import 'package:kora/screens/authorizationScreen.dart';
import 'package:kora/services/auth.dart';
import 'package:kora/services/database.dart';
import 'package:provider/provider.dart';

class AddInformation extends StatefulWidget {
  AddInformation({Key key}) : super(key: key);

  @override
  _AddInformationState createState() => _AddInformationState();
}

class _AddInformationState extends State<AddInformation> {

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController avatarController = TextEditingController(
    text: 'https://firebasestorage.googleapis.com/v0/b/kora-9feed.appspot.com/o/Avatars%2FdefaultAvatar.png?alt=media&token=df904217-b96f-49f0-9d91-920dc78c7141');
  FirebaseUser currentUser;
  bool varifyphone = false;

  void ini() async {

    currentUser = await FirebaseAuth.instance.currentUser();
    User user = await DatabaseService().info(currentUser.uid);
    nameController.text = user.name;
    surnameController.text = user.surname;
    cityController.text = user.city;
    avatarController.text = user.urlAvatar;
    if(currentUser.phoneNumber != null && currentUser.phoneNumber.isNotEmpty) {
      phoneController.text = currentUser.phoneNumber;
    }else{
      setState(() {
        varifyphone = true;
      });
    }
  }

  @override
  void initState() { 
    super.initState();
    ini();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: mainBground,
      body: Container(
        alignment: Alignment.center,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowGlow();
            return;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: startEllipse(),
                ),
                _formForAddInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _saveData() async{
    if(_fbKey.currentState.saveAndValidate()) {
      var newUser = User(
        favoritesId: [],
        deviceTokens: [],
        id: currentUser.uid,
        phone: varifyphone ? _fbKey.currentState.value['Phone'] : phoneController.text,
        name: _fbKey.currentState.value['Name'],
        surname: _fbKey.currentState.value['Surname'],
        city: _fbKey.currentState.value['City'],
        urlAvatar: avatarController.text
      );
      DatabaseService().updateUserInfo(newUser.id, newUser);
    }else {
      print('error');
    }
  }
  errorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(
        color: Colors.red,
        width: 1
      ),
    );
  }

  focusedErrorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(
        color: Colors.red,
        width: 2
      )
    );
  }

  enableBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(
        color: Colors.white54,
        width: 1
      )
    );
  }

  focusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(
        color: Colors.white54,
        width: 2
      )
    );
  }

  Widget _formForAddInfo() {
    return Container(
      margin: EdgeInsets.only(left:45, right: 45, top: 41, bottom: 40),
      child: Column(
        children: [
          FormBuilder(
            key: _fbKey,
            autovalidate: false,
            readOnly: false,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 7.5),
                  child: FormBuilderTextField(
                    attribute: 'Name',
                    controller: nameController,
                    style: TextStyle(
                      color: textColor,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 21),
                        hintText: 'Ім\'я',
                        hintStyle: TextStyle(
                          color: textColor.withOpacity(0.5),
                          fontSize: 16
                        ),
                        errorBorder: errorBorder(),
                        focusedErrorBorder: focusedErrorBorder(),
                        enabledBorder: enableBorder(), 
                        focusedBorder: focusedBorder() 
                      ),
                    onChanged: (dynamic val){},
                    validators: [
                      FormBuilderValidators.required(errorText: 'Поле не повине бути порожнім'),
                      FormBuilderValidators.maxLength(50),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 7.5),
                  child: FormBuilderTextField(
                    attribute: 'Surname',
                    controller: surnameController,
                    style: TextStyle(
                      color: textColor
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 21),
                        hintText: 'Призвіще',
                        hintStyle: TextStyle(
                          color: textColor.withOpacity(0.5),
                          fontSize: 16
                        ),
                        errorBorder: errorBorder(),
                        focusedErrorBorder: focusedErrorBorder(),
                        enabledBorder: enableBorder(), 
                        focusedBorder: focusedBorder() 
                      ),
                    onChanged: (dynamic val){},
                    validators: [
                      FormBuilderValidators.required(errorText: 'Поле не повине бути порожнім'),
                      FormBuilderValidators.maxLength(50)
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 7.5),
                  child: FormBuilderTextField(
                    attribute: 'City',
                    controller: cityController,
                    style: TextStyle(
                      color: textColor,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 21),
                      hintText: 'Місто',
                      hintStyle: TextStyle(
                        color: textColor.withOpacity(0.5),
                        fontSize: 16
                      ),
                      errorBorder: errorBorder(),
                      focusedErrorBorder: focusedErrorBorder(),
                      enabledBorder: enableBorder(), 
                      focusedBorder: focusedBorder() 
                    ),
                    onChanged: (dynamic val){},
                    validators: [
                      FormBuilderValidators.required(errorText: 'Поле не повине бути порожнім'),
                      FormBuilderValidators.maxLength(50)
                    ],
                  ),
                ),
                Visibility(
                  visible: varifyphone,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 7.5),
                    child: FormBuilderTextField(
                      attribute: 'Phone',
                      controller: phoneController,
                      style: TextStyle(
                        color: textColor,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 21),
                        hintText: 'Телефон',
                        hintStyle: TextStyle(
                          color: textColor.withOpacity(0.5),
                          fontSize: 16
                        ),
                        errorBorder: errorBorder(),
                        focusedErrorBorder: focusedErrorBorder(),
                        enabledBorder: enableBorder(), 
                        focusedBorder: focusedBorder() 
                      ),
                      onChanged: (dynamic val){},
                      validators: [
                        FormBuilderValidators.required(errorText: 'Поле не повине бути порожнім'),
                        FormBuilderValidators.numeric(errorText: 'Введіть коректно номер телефону'),
                        FormBuilderValidators.maxLength(50)
                      ],
                    ),
                  ),
                )
              ]
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: MainButton(
              insideText: 'Готово',
              func: () {
                _saveData();
              },
            )
          )
        ],
      ),
    );
  }
}