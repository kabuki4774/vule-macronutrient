import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../../main.dart';
import '../../models/food.dart';

class NewFoodWidget extends StatefulWidget {
  const NewFoodWidget({Key? key}) : super(key: key);

  @override
  State<NewFoodWidget> createState() => NewFoodState();
}

class NewFoodState extends State<NewFoodWidget> {
  static ImageProvider image = const AssetImage("assets/blank.png");
  static late File imageFile;
  static late BuildContext buildContext;
  static bool imageInited = false;
  static TextEditingController proteinController = TextEditingController(),
      carbController = TextEditingController(),
      fatController = TextEditingController(),
      nameController = TextEditingController(),
      calorieController = TextEditingController();
  Widget getInputField(String label, TextEditingController controller,
      {bool isnumber = true}) {
    return TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
        ),
        keyboardType: isnumber ? TextInputType.number : TextInputType.text);
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return Stack(
      children: [
        Container(
          child: Column(
            children: [
              Positioned(
                  top: 50,
                  left: 10,
                  child: Image(
                      image: image, width: 150, height: 150, fit: BoxFit.fill)),
              Positioned(
                  top: 200,
                  left: 45,
                  child: TextButton(
                    onPressed: () => addImagePressed(),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.amber[900]!),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white)),
                    child: const Text("Add Image"),
                  )),
            ],
          ),
        ),
        Positioned(
          top: 60,
          left: 180,
          width: 140,
          height: 150,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Positioned(
                    top: 60,
                    left: 180,
                    width: 140,
                    height: 50,
                    child:
                        getInputField("Name", nameController, isnumber: false)),
                Positioned(
                    left: 180,
                    top: 120,
                    width: 100,
                    height: 50,
                    child: getInputField("Calories", calorieController)),
                Positioned(
                    left: 180,
                    top: 170,
                    width: 100,
                    height: 50,
                    child: getInputField("🥩", proteinController)),
                Positioned(
                    left: 180,
                    top: 220,
                    width: 100,
                    height: 50,
                    child: getInputField("🥔", carbController)),
                Positioned(
                    left: 180,
                    top: 270,
                    width: 100,
                    height: 50,
                    child: getInputField("🧀", fatController)),
              ],
            ),
          ),
        ),
        Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: FloatingActionButton(
                  onPressed: addFoodPressed, child: const Icon(Icons.check)),
            ))
      ],
    );
  }

  void addFoodPressed() async {
    final manager = ScaffoldMessenger.of(buildContext);
    if (proteinController.text == "" ||
        carbController.text == "" ||
        fatController.text == "" ||
        nameController.text == "" ||
        calorieController.text == "") {
      manager.showSnackBar(
          const SnackBar(content: Text("Please fill in all the inputs above")));
      return;
    }
    double? protein = double.tryParse(proteinController.text);
    double? carbs = double.tryParse(carbController.text);
    double? fat = double.tryParse(fatController.text);
    double? calories = double.tryParse(calorieController.text);
    if (calories == null || protein == null || fat == null || carbs == null) {
      manager.showSnackBar(const SnackBar(content: Text("Only numbers")));
      return;
    }
    String name = nameController.text;
    if (imageInited) {
      String path = await getFilePath(name + extension(imageFile.path));
      imageFile = await imageFile.copy(path);
    }
    Food newFood = Food(
        imagefile: (imageInited ? basename(imageFile.path) : "none"),
        name: name,
        macros: MacroNutrients(
            protein: protein,
            fat: fat,
            carbohidrates: carbs,
            calories: calories));
    for (int i = 0; i < Foods.length; i++) {
      if (Foods[i].name == name) {
        Foods.removeAt(i);
        break;
      }
    }
    Foods.add(newFood);
    saveFoods();
    manager.showSnackBar(const SnackBar(content: Text("Food added")));
  }

  void addImagePressed() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (photo != null) {
        imageFile = File(photo.path);
        image = FileImage(imageFile);
        imageInited = true;
      }
    });
  }
}
