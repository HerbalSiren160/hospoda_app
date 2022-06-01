import 'dart:math';

import 'package:flutter/material.dart';

import 'table_futbal.dart';
import 'person.dart';

List<AssetImage> teamNames = [
  const AssetImage('images/beaver.png'),
  const AssetImage('images/bee.png'),
  const AssetImage('images/frog.png'),
  const AssetImage('images/hippo.png'),
  const AssetImage('images/chicken.png'),
  const AssetImage('images/llama.png'),
  const AssetImage('images/pig.png'),
  const AssetImage('images/shark.png'),
  const AssetImage('images/snail.png'),
  const AssetImage('images/unicorn.png'),
];

class GamesPage extends StatelessWidget {
  const GamesPage({Key? key, required this.names}) : super(key: key);

  final List<Person> names;

  popRandomName(names) {
    Random rand = Random();

    Person name = names[rand.nextInt(names.length)];
    names.remove(name);

    return name;
  }

  generatePair(names) {
    List<Person> pair = [];
    pair.add(popRandomName(names));
    pair.add(popRandomName(names));
    return pair;
  }

  generateTeams() {
    List<List<Person>> pairs = [];

    List<Person> namesCpy = List.castFrom(names);

    var teamsCount = names.length / 2;

    for (int i = 0; i < teamsCount; i++) {
      pairs.add(generatePair(namesCpy));
    }

    Map<AssetImage, List<Person>> teams = {};

    teamNames.shuffle();

    for (int i = 0; i < teamsCount; i++) {
      teams[teamNames[i]] = pairs[i];
    }

    return teams;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text('Stolný futbal'),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TableFutbalGame(teams: generateTeams()))),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text('Biliard'),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
