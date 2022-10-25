import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image/image.dart' as ony;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Home2 extends StatefulWidget {
  Home2({Key? key}) : super(key: key);

  @override
  State<Home2> createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  File? _imagefike;
  FileImage? imagre;
  String dropdown = "White";
  double? kk;
  late int rr = 255, bb = 255, gg = 255;
  final ImagePicker _picker = ImagePicker();
  CroppedFile? _croppedFile;
  late final Path paths;
  double avg = 0;
  static const menuitmes = <String>["White", "Yellow", "Red", "Blue", "Orange"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext contex) {
                        return AlertDialog(
                          title: Text("Select an Image from "),
                          actions: [
                            GestureDetector(
                              child: Text("Cancel"),
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    _pickImageFromCamer();

                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Camera")),
                              ElevatedButton(
                                  onPressed: () {
                                    _pickimage();

                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Gallery"))
                            ],
                          ),
                        );
                      });
                },
                child: Text("Select An Image ")),
            if (_croppedFile != null)
              Image.file(
                File(_croppedFile!.path),
                width: 400,
                height: 400,
              ),
            DropdownButton(
              // Initial Value
              value: dropdown,

              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),

              // Array list of items
              items: menuitmes.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  if (value == "White") {
                    rr = 255;
                    gg = 255;
                    bb = 255;
                  } else if (value == "Yellow") {
                    rr = 255;
                    gg = 255;
                    bb = 0;
                  } else if (value == "Red") {
                    rr = 255;
                    gg = 255;
                    bb = 255;
                  } else if (value == "Blue") {
                    rr = 0;
                    bb = 255;
                    gg = 0;
                  } else if (value == "Orange") {
                    rr = 255;
                    gg = 165;
                    bb = 0;
                  }
                });
                dropdown = value!;
              },
              // After selecting the desired option,it will
              // change button value to selected value
            ),
            if (_imagefike != null)
              ElevatedButton(
                  onPressed: () {
                    bright();
                  },
                  child: Text("Get BrightNess")),
            // if (kk != null) Text("${kk}"),
            textttt(),
          ],
        ),
      )),
    );
  }

  Widget textttt() {
    if (kk != null) {
      if (kk!.toInt() >= 100000000) {
        return Text(
          "Light is on ",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        );
      } else {
        return Text(
          "Light is off",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        );
      }
    } else {
      return Text("Data not found or some error");
    }
  }

  coloee() => ColorPicker(
        pickerColor: Colors.red, //default color
        onColorChanged: (Color color) {
          //on color picked
          print(color);
        },
      );

  Future<void> _pickImageFromCamer() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        this._imagefike = File(pickedFile.path);
      });
      _cropImage();
    }
  }

  Future<void> _pickimage() async {
    final PickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (PickedFile != null) {
      setState(() {
        this._imagefike = File(PickedFile.path);
        this.imagre = FileImage(_imagefike!);
      });
      _cropImage();
    }
  }

  Future<void> _cropImage() async {
    if (_imagefike != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _imagefike!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
        });
      }
    }
  }

  Future<void> bright() async {
    setState(() {
      avg = (rr + gg + bb) / 3;
    });

    var img = ony.decodeImage(_imagefike!.readAsBytesSync());
    var pixels = img!.data;

    double colorsum = 0;
    for (var i = 0; i < pixels.length; i++) {
      int pixel = pixels[i];
      int b = (pixel & 0x00FF0000) >> 16;
      //print("${b}  ");
      int g = (pixel & 0x0000FF00) >> 8;
      int r = (pixel & 0x000000FF);

      if ((rr - 50 <= r || r >= rr + 50) &&
          (gg - 50 <= g || g >= gg + 50) &&
          (bb - 50 <= b || b >= bb + 50)) {
        double avggg = ((r + g + b) / 3);

        colorsum += avggg;
      }
    }
    print(colorsum);
    //  print(colorsum);
    setState(() {
      kk = colorsum;
    });
    kk = colorsum;
  }
}
