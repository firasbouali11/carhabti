import 'dart:convert';
import 'dart:io';
import 'package:car_app_2/constants.dart';
import 'package:http/http.dart';
class Cars{

  late Map brands;
  late List colors;
  late Map _data;
  late Map prediction;
  Map? classification;

  Future<void> getData() async{
    String uri = ENDPOINT+"data";
    var url = Uri.parse(uri);
    await get(url).then((value) {
      this._data = jsonDecode(value.body);
      this.brands = _data["brands"];
      this.colors = _data["colors"];
    });
  }

  Future<Map> predict(String brand, String model, String color, String reservoir) async{
    String uri = ENDPOINT+"predict";
    var url = Uri.parse(uri);
    await post(url, body: {
      "brand": brand,
      "model":model,
      "color":color,
      "reservoir":reservoir
    }).then((value) => prediction = jsonDecode(value.body));
    return this.prediction;
  }

  Future<Map> classify(File? image)async {
    String uri = ENDPOINT+"classify";
    var url = Uri.parse(uri);
    var request = MultipartRequest("POST", url);
    print(url);
    request.files.add(await MultipartFile.fromPath("image", image!.path));
    var response = await request.send();
    print(response.stream.bytesToString().then((value){
      classification= jsonDecode(value);
    }));
    return this.classification!;

  }

}