import 'dart:io';
import 'package:car_app_2/Services/Cars.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import "package:car_app_2/constants.dart";

class CarDetection extends StatefulWidget {
  final Cars car;
  // Cars car;
  const CarDetection({Key? key,required this.car}) : super(key: key);

  @override
  _CarDetectionState createState() => _CarDetectionState({this.car});
}

class _CarDetectionState extends State<CarDetection> {

  Cars car = Cars();

  _CarDetectionState(Set<Cars> car);
  File? image;
  String carBrand = "";
  final ImagePicker imagePicker = ImagePicker();

  Future<void> getImage() async{
    final PickedFile? imagetaken = await imagePicker.getImage(source: ImageSource.camera);

    Map p = await car.classify(File(imagetaken!.path));

    setState(() {
      image = File(imagetaken.path);
      if(p["status"] == "success") carBrand = p["prediction"];
      else carBrand = p["error"];
    });

  }

  void goback() {
    setState(() {
      image = null;
    });
  }
  @override
  Widget build(BuildContext context) {

    Container? show = image==null ? CameraAccess() : ProcessImage();




    Future<void> _showMyDialog() async {
      return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Pas de connexion internet'),
              content: SingleChildScrollView(
                  child: Text('svp d\'activer votre connexion et redemarrez l\'applicaiton')
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK',style: TextStyle(color: BLUE),),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // exit(0);
                  },
                ),
              ],
            );
          }
      );}
    _checkConnectivity() async {
      var result = await Connectivity().checkConnectivity();
      if( result == ConnectivityResult.none) {
        _showMyDialog();
      }
    }
    _checkConnectivity();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 0),
            child: Text("Scanner votre voiture",style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              shadows: [
                Shadow(blurRadius: 20,color: Colors.black)
              ]
            ),),
          ),
          Container(child:show),
        ],
      ),
    );
  }

  Container ProcessImage() {
    return Container(
        child: Column(
          children: [
            Image.file(image!,width: 300),
            Text("this is a $carBrand",style: TextStyle(
              fontSize: 50,
              color: WHITE,
            ),),
            ElevatedButton.icon(
              onPressed: goback,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(BLUE),
              ),
              icon: Icon(Icons.arrow_back_outlined),
              label: Text("Back") ,)
          ],
        )
    );
  }

  Container CameraAccess() {
    return Container(
          width: 300,
          height: 300,
          // color: Colors.red,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(500)
          ),
          child: Center(
            child: Container(
              width: 250,
              height: 250,
              // color: Colors.red,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(500)
              ),
              child: Center(
                child: Container(
                  width: 200,
                  height: 200,
                  // color: Colors.red,
                  decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(500)
                  ),
                  child: IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: getImage,
                    iconSize: 120,
                    color: Color(0xff17C9D4),

                  ),
                ),
              ),
            )
          ) ,
        );
  }
}
