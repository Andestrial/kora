import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootServices;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kora/core/ui/stateLessWidgets.dart/inputText.dart';
import 'package:kora/domain/sneakers.dart';
import 'package:kora/domain/user.dart';
import 'package:kora/resources/colors/colors.dart';
import 'package:kora/resources/fonts/my_flutter_app_icons.dart';
import 'package:kora/resources/styles/adsLoader.dart';
import 'package:kora/resources/styles/pickers.dart';
import 'package:kora/services/database.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class AddAndUpdateAdScreen extends StatefulWidget {
  final Sneackers updateSneackers;
  AddAndUpdateAdScreen({Key key, this.updateSneackers}) : super(key: key);

  @override
  _AddAndUpdateAdScreenState createState() => _AddAndUpdateAdScreenState();
}

class _AddAndUpdateAdScreenState extends State<AddAndUpdateAdScreen> {
  User user;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  TextEditingController lengthController = TextEditingController(text: '30');
  TextEditingController widthController = TextEditingController(text: '30');
  TextEditingController sizeController = TextEditingController(text: '35');
  TextEditingController typeSizeController = TextEditingController(text: 'EU');
  TextEditingController descriprionController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController materialController = TextEditingController();
  List images = [];

  StreamController pickerController = StreamController();

  Sneackers update = Sneackers();
  bool isUpdate = false;
  String docId;
  
  @override
  void initState() {
    pickerController.stream.listen((event) { 
      setState(() {
        event[0].text = event[1];
      });
    }); 

    if (widget.updateSneackers != null) {
      update = widget.updateSneackers.copy();
      lengthController.text = update.length.toString();
      widthController.text = update.width.toString();
      sizeController.text = update.size.toString();
      typeSizeController.text = update.typeSize;
      update.images.forEach((element) async {
          var rng = new Random();
          Directory tempDir = await Directory.systemTemp.createTemp();
          String tempPath = tempDir.path;
          File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
          http.Response response = await http.get(element);
          await file.writeAsBytes(response.bodyBytes);
          setState(() {
            images.add(file);
          });
      });
      descriprionController.text = update.description;
      modelController.text = update.modelName;
      priceController.text = update.price.toString();
      materialController.text = update.material;
      isUpdate = true;
      docId = update.id;
    }
    super.initState();
  }
  
  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight:1000, maxWidth: 1000); 

    if(image != null)
    setState(() {
      images.add(image);
    });
  }

  _removeImage(index) {
    setState(() {
      images.removeAt(index);
    });
  }

  _saveData(Sneackers updateSneackers) async{
    if(_fbKey.currentState.saveAndValidate() && images.length > 0) {
      showDialog(
        context: context,
        builder: (context) => AdsLoader(),
      );
      var id = docId ?? await DatabaseService().createAd();
      List<String> url = [];
      for(var i = 0; i < (images.length); i++) { 
        var img = await DatabaseService().addImages(user, images[i], id);
        url.add(img);
      }
      var save = Sneackers(
        id: id,
        length: double.parse(lengthController.text),
        width: double.parse(widthController.text),
        size: double.parse(sizeController.text),
        typeSize: typeSizeController.text,
        material: _fbKey.currentState.value['material'],
        description: _fbKey.currentState.value['description'],
        price: double.parse(_fbKey.currentState.value['price']),
        modelName:  _fbKey.currentState.value['model'],
        images: url,
        authorId: user.id
      );
      DatabaseService().addAdInfo(save);
      Navigator.pop(context);
      Navigator.pop(context);

    }else{
      Toast.show(
        'Усі поля майють бути заповненні', 
        context,
        backgroundColor: Colors.red[400]
      );
    }
  }

  Widget sizeForm(String mainText, TextEditingController controller, [TextEditingController size]) {
    return Container(
      padding: const EdgeInsets.only(bottom: 11,),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: descriptionColor.withOpacity(0.3)
          )
        )
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 95,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    mainText,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16
                    ),
                  ),
                  size != null 
                    ? InkWell(
                        child: Text(
                          size.text,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16
                          ),
                        ),
                        onTap: (){
                          Pickers().sizePicker(context, pickerController, size);
                        }
                      )
                    : Container()
                ],
              ),
            ),
            Expanded(
              flex: 30,
              child: Center(
                child: VerticalDivider(
                  color: descriptionColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            Expanded(
                flex: 50,
                child: InkWell(
                  child: Text(
                    controller.text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16
                    ),
                  ),
                onTap: (){
                  controller == typeSizeController 
                    ? Pickers().typeSizePicker(context, pickerController, controller)
                    : Pickers().sizePicker(context, pickerController, controller);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget inputText(TextEditingController controller, String title, 
    String attribute, List validators) {
    return Padding(
      padding: EdgeInsets.only(left: 16, top: 10, bottom: 5),
      child: InputText(
        controller: controller,
        title: title,
        attribute: attribute,
        validators: validators,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    return Scaffold(
      backgroundColor: mainBground,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowGlow();
          return;
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 23),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          splashRadius: 20,
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        InkWell(
                          child: Text(
                            'Зберегти',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 13
                            ),  
                          ),
                          onTap: () {
                            _saveData(widget.updateSneackers);
                          },
                        )
                      ],
                    ),
                  ),
                  FormBuilder(
                    key: _fbKey,
                    autovalidate: false,
                    readOnly: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 5, bottom: 17),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: blueColor,
                                radius: 3,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Text(
                                  'Додати фото',
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 16
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          color: secondaryBground,
                          child: GridView.count(
                            crossAxisCount: 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            padding: EdgeInsets.all(18),
                            children: List.generate(8, (index) {
                              return images.length == index 
                                ? GestureDetector(
                                    onTap: _getImage,
                                    child: Container (
                                      decoration: BoxDecoration(
                                        color: blueColor,
                                        borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: Icon(
                                        CustomIcons.photo,
                                        color: textColor,  
                                      ),
                                    )
                                  )
                                : (images != null && images.length > index && 
                                    images[index] != null) 
                                  ? GestureDetector(
                                      child: Stack(
                                        children: [
                                          Container (
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: Image.file(images[index]).image,
                                              )
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Transform.translate(
                                              offset: Offset(5, -5),
                                              child: InkWell(
                                                onTap: () {
                                                  _removeImage(index);
                                                },
                                                child: Icon(
                                                  Icons.cancel,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    )
                                  : GestureDetector(
                                      child: Container (
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8)
                                        ),
                                      )
                                    );
                            })
                          )
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16, top: 15, bottom: 17,),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: blueColor,
                                radius: 3,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Text(
                                  'Розмір',
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 16
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 48, top: 22, bottom: 22, right: 20),
                          width: MediaQuery.of(context).size.width,
                          color: secondaryBground,
                          child: Row(
                            children: [
                              Image(
                                height: 160,
                                image: AssetImage('lib/resources/images/sizePicture.png'),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 40),
                                  child: Column(
                                    children: [
                                      sizeForm('Розмір', typeSizeController, sizeController),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 25),
                                        child: sizeForm('Довжина / см', lengthController),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 25),
                                        child: sizeForm('Ширина / см', widthController),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        inputText(
                          modelController, 
                          'Модель', 
                          'model', 
                          [ 
                            FormBuilderValidators.required(
                              errorText: 'Поле не повинне бути порожнім'
                            )
                          ].toList()
                        ),
                        inputText(
                          materialController,
                          'Матеріал',
                          'material',
                          [
                            FormBuilderValidators.required(
                              errorText: 'Поле не повинне бути порожнім'
                            )
                          ].toList()
                        ),
                        inputText(
                          descriprionController,
                          'Опис', 
                          'description', 
                          [
                            FormBuilderValidators.required(
                              errorText: 'Поле не повинне бути порожнім')
                          ].toList()
                        ),
                        inputText(
                          priceController, 
                          'Ціна', 
                          'price', 
                          [
                            FormBuilderValidators.required(
                              errorText: 'Поле не повинне бути порожнім'
                            ),
                            FormBuilderValidators.numeric(
                              errorText: 'Введіть коректну ціну'
                            )
                          ].toList()
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}