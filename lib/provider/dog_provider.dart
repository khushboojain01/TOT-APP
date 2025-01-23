import 'package:flutter/foundation.dart';
import 'package:tot_app/dog_model.dart';
import 'package:tot_app/services/dog_api.dart';
import 'package:tot_app/services/db_helper.dart';

class DogProvider with ChangeNotifier {
  List<Dog> _dogs = [];
  List<Dog> _searchResults = [];
  List<Dog> _savedDogs = [];
  bool _isLoading = false;

  List<Dog> get dogs => _dogs;
  List<Dog> get searchResults => _searchResults;
  List<Dog> get savedDogs => _savedDogs;
  bool get isLoading => _isLoading;

  final DogApiService _apiService = DogApiService();
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<void> fetchDogs() async {
    _isLoading = true;
    notifyListeners();
    try {
      _dogs = await _apiService.fetchDogs();
    } catch (e) {
      _dogs = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchDogs(String query) async {
    _isLoading = true;
    notifyListeners();
    try {
      _searchResults = await _apiService.searchDogs(query);
    } catch (e) {
      _searchResults = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveDog(Dog dog) async {
    await _databaseHelper.saveDog(dog);
    await loadSavedDogs();
  }

  Future<void> loadSavedDogs() async {
    _savedDogs = await _databaseHelper.getSavedDogs();
    notifyListeners();
  }

  Future<void> removeSavedDog(int id) async {
    await _databaseHelper.removeSavedDog(id);
    await loadSavedDogs();
  }
}