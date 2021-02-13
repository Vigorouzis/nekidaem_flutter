import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nekidaem_flutter/blocs/kanban_bloc/kanban_event.dart';
import 'package:nekidaem_flutter/blocs/kanban_bloc/kanban_state.dart';
import 'package:http/http.dart' as http;
import 'package:nekidaem_flutter/models/card.dart';
import 'package:nekidaem_flutter/models/user.dart';
import 'package:nekidaem_flutter/services/shared_prefs.dart';

class KanbanBloc extends Bloc<KanbanEvent, KanbanState> {
  KanbanBloc() : super(InitKanbanState());

  List<TrelloCard> _cards;
  User _user;
  SharedPrefs _sharedPref = SharedPrefs();
  @override
  Stream<KanbanState> mapEventToState(KanbanEvent event) async* {
    if (event is GetCardsFromTrello) {
      yield KanbanLoading();
    _user = User.fromJson(await _sharedPref.read('user'));
      var token = _user.token;
      final response = await http.get(
          'https://trello.backend.tests.nekidaem.ru/api/v1/cards?row=${event.rowNumber}',
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'JWT $token'
          });

      if (response.statusCode == 200) {
        final List<dynamic> userJson = json.decode(utf8convert(response.body));
        _cards = userJson.map((json) => TrelloCard.fromJson(json)).toList();
        yield KanbanLoaded(_cards);
      } else {
        yield KanbanFailed('Error fetching cards');
      }
    }
  }

  static String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
  }
}
