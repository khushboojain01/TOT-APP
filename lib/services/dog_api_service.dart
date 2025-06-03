  import 'dart:convert';
  import 'package:http/http.dart' as http;
  import 'package:tot_app/dog_model.dart';

  class DogApiService {
    static const String _baseUrl = 'https://freetestapi.com/api/v1/dogs';

    Future<List<Dog>> fetchDogs() async {
      try {
        final response = await http.get(Uri.parse(_baseUrl));
        if (response.statusCode == 200) {
          List<dynamic> jsonList = json.decode(response.body);
          return jsonList.map((json) => Dog.fromJson(json)).toList();
        } else {
          throw Exception('Failed to load dogs');
        }
      } catch (e) {
        throw Exception('Network error: $e');
      }
    }

    Future<List<Dog>> searchDogs(String query) async {
      try {
        final response = await http.get(Uri.parse(_baseUrl));
        if (response.statusCode == 200) {
          List<dynamic> jsonList = json.decode(response.body);
          return jsonList
              .map((json) => Dog.fromJson(json))
              .where((dog) => 
                dog.name.toLowerCase().contains(query.toLowerCase()) || 
                dog.breed.toLowerCase().contains(query.toLowerCase())
              )
              .toList();
        } else {
          throw Exception('Failed to search dogs');
        }
      } catch (e) {
        throw Exception('Network error: $e');
      }
    }
  }