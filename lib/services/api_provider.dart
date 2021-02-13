import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nekidaem_flutter/models/card.dart';

class ApiProvider {
  final String cardsURL =
      'https://trello.backend.tests.nekidaem.ru/api/v1/cards/seq_num=0';

  Future<List<TrelloCard>> getCards() async {
    final response = await http.get(cardsURL);

    print(response.statusCode);

    if (response.statusCode == 200) {
      final List<dynamic> userJson = json.decode(response.body);
      return userJson.map((json) => TrelloCard.fromJson(json)).toList();
    } else {
      throw Exception('Error fetching posts');
    }
  }
}
