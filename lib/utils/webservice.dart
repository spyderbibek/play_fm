import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:play_fm/model/radio_model.dart';

class Webservice {
//  Future<T> load<T>(Resource<T> resource) async {
//    final response = await http.get(resource.url);
//    if (response.statusCode == 200) {
//      return resource.parse(response);
//    } else {
//      throw Exception('Failed to load data!');
//    }
//  }

  Future<List<RadioModel>> fetchStations() async {
    var response = await http.get("http://bkshah.com.np/play_fm/new.json");

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<RadioModel> listOfStations = items.map<RadioModel>((json) {
        return RadioModel.fromJson(json);
      }).toList();
      return listOfStations;
    } else {
      throw Exception('Failed to load internet');
    }
  }
}
