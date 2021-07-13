import 'package:car_app_2/Services/Cars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:car_app_2/constants.dart';

class CarPrediction extends StatefulWidget {
  final Cars car;
  const CarPrediction({Key? key,required this.car}) : super(key: key);

  @override
  _CarPredictionState createState() => _CarPredictionState();
}

class _CarPredictionState extends State<CarPrediction> {
  String brandDropDownValue = "Marque du voiture";
  String modelDropDownValue = "Modele du voiture";
  String colorDropDownValue = "Couleur du voiture";
  String reservoir = "0";
  List models = ["Modele du voiture"];
  String logoName = "bmw.png";


  void _onchangemodel(dynamic? value){
    setState(() {
      modelDropDownValue = value!;
    });
  }
  void _onchangecolor(dynamic? value){
    setState(() {
      colorDropDownValue = value!;
    });
  }


  // void predict(){
  //   car!.predict(brandDropDownValue, modelDropDownValue, colorDropDownValue, reservoir);
  // }
  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    List colors = widget.car.colors.toList();
    List brands = widget.car.brands.keys.toList();
    brands.insert(0, "Marque du voiture");
    colors.insert(0, "Couleur du voiture");

    Future<void> _showMyDialog() async {
      Map prediction = await widget.car.predict(brandDropDownValue, modelDropDownValue, colorDropDownValue, reservoir);
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Calculons ...'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Prix: ${prediction["status"] == "success" ? prediction['prediction'] : prediction["error"]}€",style: TextStyle(fontSize: 45),)
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK',style: TextStyle(color: BLUE),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    void _onchangebrand(dynamic? value ){
      models = ["Modele du voiture"];
      modelDropDownValue = "Modele du voiture";
      setState(() {
        brandDropDownValue = value!;
        logoName = value!.toString().toLowerCase()+".png";
        models.addAll(widget.car.brands[value!]);
      });
    }

    return SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 0),
              child: Text("Choisir les critères de votre voiture",style: TextStyle(
                  fontSize: 30,
                  color: WHITE,
                  shadows: [
                    Shadow(blurRadius: 20,color: Colors.black)
                  ]
              ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width *0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: BLUEA9,
                    ),
                    child: Center(
                      child: DropdownButton(
                          iconEnabledColor: Colors.white,
                          dropdownColor: BLUE,
                          style: TextStyle(color: WHITE,fontSize: 20),
                        onChanged: _onchangebrand,
                          value: brandDropDownValue,
                          items: brands.map((dynamic value){
                          return DropdownMenuItem(child: Text(value),value: value,);
                        }).toList()
                      ),
                    ),
                  ),
                  Container(
                      width: size.width *0.2,
                      height: size.width*0.2,
                      child: CircleAvatar(
                        backgroundImage: AssetImage("assets/images/logos/$logoName") ,
                        backgroundColor: Colors.transparent,
                      )
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: BLUEA9,
                ),
                child: Center(
                  child: DropdownButton(
                    iconEnabledColor: WHITE,
                      dropdownColor: BLUE,
                      style: TextStyle(color: WHITE,fontSize: 20),
                      onChanged: _onchangemodel,
                      // onTap: getModels,
                      value: modelDropDownValue,
                      items: models.map((dynamic value){
                        return DropdownMenuItem(child: Text(value),value: value,);
                      }).toList()
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: BLUEA9,
                ),
                child: Center(
                  child: DropdownButton(
                      iconEnabledColor: WHITE,
                      dropdownColor: BLUE,
                      style: TextStyle(color: WHITE,fontSize: 20),
                      onChanged: _onchangecolor,
                      value: colorDropDownValue,
                      items: colors.map((dynamic value){
                        return DropdownMenuItem(child: Text(value),value: value,);
                      }).toList()
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Container(
                  // color: Colors.red,
                  // padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: BLUEA9,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: TextField(
                    onChanged: (e){setState(() {
                      reservoir =  e.toUpperCase();
                    });},
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: "Reservoir (L : Litre)",
                      hintStyle: TextStyle(color: Colors.white,fontSize: 20),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color:Colors.transparent)
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50,),
            ElevatedButton(
                onPressed: _showMyDialog,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF17C9D4)),
                ),
                child: Text("Prix",style: TextStyle(fontSize: 18),)
            ),
          ],
        )
    );
  }
}


