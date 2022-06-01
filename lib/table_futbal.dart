import 'dart:ui';

import 'package:flutter/material.dart';

import 'person.dart';

List<AssetImage> images = [];

const TextStyle headerStyle = TextStyle(
  fontSize: 40.0,
  fontWeight: FontWeight.bold,
);

const TextStyle namesStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);

class TableFutbalGame extends StatefulWidget {
  const TableFutbalGame({Key? key, required this.teams}) : super(key: key);

  final Map<AssetImage, List<Person>> teams;

  @override
  _TableFutbalGame createState() => _TableFutbalGame();
}

class _TableFutbalGame extends State<TableFutbalGame> {
  createScoreTable() {
    List<List<int>> ret = [];
    for (int i = 0; i < widget.teams.length; i++) {
      List<int> row = [];
      for (int j = 0; j < widget.teams.length; j++) {
        row.add(-1);
      }
      ret.add(row);
    }

    return ret;
  }

  generateMatches() {
    int teamsCount = widget.teams.length;

    List<List<int>> ret = [];

    for (int j = 1; j < teamsCount; j++) {
      int i = 0;
      while (i < teamsCount - 1) {
        if (i + j < teamsCount) {
          ret.add([i, i + j]);
        }
        i += 1;
      }
    }

    return ret;
  }

  createFirstRow() {
    List<Container> ret = widget.teams.keys.map((key) {
      return Container(
        color: Colors.blue[100],
        height: 48.0,
        child: Image(
          image: key,
          height: 48.0,
          width: 48.0,
        ),
      );
    }).toList();

    ret.insert(0, Container(height: 48.0));

    return ret;
  }

  createTableRow(i) {
    List<Container> ret = [];

    ret.add(Container(
      color: Colors.blue[100],
      child: Image(
        image: images[i],
        height: 48.0,
        width: 48.0,
      ),
    ));

    for (int j = 0; j < widget.teams.length; j++) {
      if ((j == i) || (tableScores[i][j] < 0)) {
        ret.add(Container(
          child: const Center(
            child: Text('-'),
          ),
          width: 48.0,
          height: 48.0,
        ));
      } else {
        ret.add(Container(
          child: Image(image: images[tableScores[i][j]]),
          width: 48.0,
          height: 48.0,
        ));
      }
    }

    return ret;
  }

  createTableRows() {
    List<TableRow> ret = [];
    for (int i = 0; i < widget.teams.length; i++) {
      ret.add(TableRow(children: createTableRow(i)));
    }

    ret.insert(0, TableRow(children: createFirstRow()));

    return ret;
  }

  void _startMatchAndReturnWinner(BuildContext context, int i, int j) async {
    final winner = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GameInProgress(
                teams: [i, j],
              )),
    );

    setState(() {
      tableScores[i][j] = winner;
      tableScores[j][i] = winner;
      tableScores = List.castFrom(tableScores);

      wins[winner] += 1;
      wins = List.castFrom(wins);

      List<List<int>> newMatches = [];
      for (var e in matches) {
        if (!(e.first == i && e.last == j)) newMatches.add(e);
      }
      matches = newMatches;
    });
  }

  List<List<int>> tableScores = [];
  List<int> wins = [];
  List<List<int>> matches = [];

  @override
  initState() {
    super.initState();
    images = widget.teams.keys.toList();
    tableScores = createScoreTable();
    matches = generateMatches();
    wins = List.filled(widget.teams.length, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(children: <Widget>[
            const Text(
              'Tímy',
              style: headerStyle,
            ),
            Column(
              children: widget.teams.keys.map((key) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(5.0),
                  child: Row(
                    children: <Widget>[
                      Image(
                        image: key,
                        width: 48.0,
                        height: 48.0,
                      ),
                      const Spacer(),
                      Column(
                        children: <Widget>[
                          Text(
                            widget.teams[key]!.first.toString(),
                            style: namesStyle,
                          ),
                          Text(
                            widget.teams[key]!.last.toString(),
                            style: namesStyle,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        wins[widget.teams.keys.toList().indexOf(key)]
                            .toString(),
                        style: headerStyle,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const Text(
              'Tabuľka',
              style: headerStyle,
            ),
            Table(
              border: TableBorder.all(width: 2),
              children: createTableRows(),
            ),
            const Text(
              'Zápasy',
              style: headerStyle,
            ),
            Column(
                children: matches.map((key) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.all(5.0),
                child: GestureDetector(
                  child: Row(
                    children: <Widget>[
                      Image(
                        image: images[key.first],
                        width: 80.0,
                        height: 80.0,
                      ),
                      const Spacer(),
                      const Text(
                        'VS',
                        style: headerStyle,
                      ),
                      const Spacer(),
                      Image(
                        image: images[key.last],
                        width: 80.0,
                        height: 80.0,
                      )
                    ],
                  ),
                  onTap: () {
                    _startMatchAndReturnWinner(context, key.first, key.last);
                  },
                ),
              );
            }).toList()),
          ]),
        ),
      ),
    );
  }
}

class GameInProgress extends StatelessWidget {
  GameInProgress({Key? key, required this.teams}) : super(key: key);

  final List<int> teams;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Označte víťaza',
              style: headerStyle,
            ),
            Row(
              children: [
                GestureDetector(
                  child: Image(
                    image: images[teams.first],
                    width: 96.0,
                    height: 96.0,
                  ),
                  onTap: () {
                    Navigator.pop(context, teams.first);
                  },
                ),
                const Spacer(),
                const Text(
                  'VS',
                  style: headerStyle,
                ),
                const Spacer(),
                GestureDetector(
                  child: Image(
                    image: images[teams.last],
                    width: 96.0,
                    height: 96.0,
                  ),
                  onTap: () {
                    Navigator.pop(context, teams.last);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
