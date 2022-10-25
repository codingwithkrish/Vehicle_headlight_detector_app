import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_pixels/image_pixels.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? _imagefike;
  FileImage? imagre;
  double? kk;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  _pickimage();
                },
                child: Text("Select")),
            if (imagre != null)
              ImagePixels(
                  imageProvider: imagre,
                  builder: (context, img) =>
                      Text("Pixels vale = ${img.pixelColorAt!(40, 50)}")),
            if (_imagefike != null)
              ElevatedButton(
                  onPressed: () {
                    bright();
                  },
                  child: Text("get")),
            if (kk != null) Text("${kk}"),
          ],
        ),
      ),
    ));
  }

  Future<void> _pickimage() async {
    final PickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (PickedFile != null) {
      setState(() {
        this._imagefike = File(PickedFile.path);
        this.imagre = FileImage(_imagefike!);
      });
    }
  }

  // Future<void> pixelss() async {
  //   var img = I.decodeImage(_imagefike!.readAsBytesSync());
  //   for (var i = 0; i < img!.width; i++) {
  //     for (var j = 0; j < img.height; j++) {
  //       int pixels = img.getPixel(i, j);
  //       print(pixels);
  //     }
  //   }
  // }

  Future<void> bright() async {
    var img = decodeImage(_imagefike!.readAsBytesSync());
    var pixels = img!.data;
    print(pixels);
    double colorsum = 0;
    for (var i = 0; i < pixels.length; i++) {
      int pixel = pixels[i];
      int b = (pixel & 0x00FF0000) >> 16;
      // print(b);
      int g = (pixel & 0x0000FF00) >> 8;
      int r = (pixel & 0x000000FF);
      double avg = ((r + g + b) / 3);
      colorsum += avg;
    }
    print(colorsum);
    setState(() {
      kk = colorsum;
    });
    kk = colorsum;
  }
}
