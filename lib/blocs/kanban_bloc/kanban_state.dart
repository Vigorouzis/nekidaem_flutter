import 'package:equatable/equatable.dart';
import 'package:nekidaem_flutter/models/card.dart';

abstract class KanbanState extends Equatable {
  const KanbanState();

  @override
  List<Object> get props => [];
}

class InitKanbanState extends KanbanState {}

class KanbanLoading extends KanbanState {}

class KanbanLoaded extends KanbanState {
  final List<TrelloCard> cards;

  const KanbanLoaded(this.cards);

  @override
  List<Object> get props => [cards];
}

class KanbanFailed extends KanbanState {
  final String errorMessage;

  const KanbanFailed(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
