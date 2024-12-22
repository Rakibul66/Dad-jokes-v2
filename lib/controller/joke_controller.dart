import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../model/joke_model.dart';

class JokeController extends GetxController {
  final RxList<Joke> jokes = <Joke>[].obs;
  final RxInt currentIndex = 0.obs;
  final Random _random = Random();  // Create an instance of Random
  @override
  void onInit() {
    super.onInit();
    loadJokes();
  }

  Future<void> loadJokes() async {
    try {
      final String response = await rootBundle.loadString('assets/jokes_data.json');
      final List<dynamic> data = json.decode(response);

      jokes.value = data.map((joke) => Joke(joke: joke['joke'])).toList();
      if (jokes.isNotEmpty) {
        joke.value = jokes[currentIndex.value];
      } else {
        throw Exception('No jokes found in the JSON file.');
      }
    } catch (e) {
      throw Exception('Failed to load jokes: $e');
    }
  }

  void showRandomJoke() {
    if (jokes.isNotEmpty) {
      currentIndex.value = _random.nextInt(jokes.length);  // Get a random index
      joke.value = jokes[currentIndex.value];
    }
  }

  final Rx<Joke> joke = Joke(joke: '').obs;
}
