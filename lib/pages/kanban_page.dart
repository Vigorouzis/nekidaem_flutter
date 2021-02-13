import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nekidaem_flutter/blocs/kanban_bloc/kanban.dart';
import 'package:nekidaem_flutter/models/card.dart';

class KanbanPage extends StatefulWidget {
  @override
  _KanbanPageState createState() => _KanbanPageState();
}

class _KanbanPageState extends State<KanbanPage>
    with SingleTickerProviderStateMixin {
  KanbanBloc _kanbanBloc;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _kanbanBloc = BlocProvider.of<KanbanBloc>(context);

    _tabController = TabController(vsync: this, length: 4, initialIndex: 0);

    _kanbanBloc.add(GetCardsFromTrello(0));

    _tabController.animation.addListener(() {
      if (_tabController.indexIsChanging) {
        _kanbanBloc.add(GetCardsFromTrello(_tabController.index));
      }
    });

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _kanbanBloc.add(GetCardsFromTrello(_tabController.index));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: 'On hold'),
            Tab(text: 'In progress'),
            Tab(text: 'Needs review'),
            Tab(text: 'Approved'),
          ],
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<KanbanBloc, KanbanState>(
          builder: (context, state) {
            if (state is KanbanLoaded) {
              return TabBarView(children: [
                cardList(state.cards.length, state.cards),
                cardList(state.cards.length, state.cards),
                cardList(state.cards.length, state.cards),
                cardList(state.cards.length, state.cards),
              ], controller: _tabController);
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget cardList(int count, List<TrelloCard> cards) {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.grey[600],
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ID: ${cards[index].id}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.0,
                    ),
                  ),
                  SizedBox(height: 3.0),
                  Text(
                    cards[index].text,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
