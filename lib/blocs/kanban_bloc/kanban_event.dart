import 'package:equatable/equatable.dart';

abstract class KanbanEvent extends Equatable {
  const KanbanEvent();

  @override
  List<Object> get props => [];
}

class GetCardsFromTrello extends KanbanEvent {
  final int rowNumber;

  const GetCardsFromTrello(this.rowNumber);

  @override
  List<Object> get props => [rowNumber];
}
