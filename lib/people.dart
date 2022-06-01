import 'package:flutter/material.dart';

import 'games.dart';
import 'person.dart';
import 'personsDB.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({Key? key}) : super(key: key);

  @override
  _PeoplePageState createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  final TextEditingController _textFieldController = TextEditingController();

  List<Person> persons = [];
  int lastId = 0;

  @override
  initState() {
    getData();
    super.initState();
  }

  void getData() async {
    PersonsDB().persons().then((result) {
      persons = result;
      if (persons.isNotEmpty) {
        int maxId = persons[0].id;
        for (var p in persons) {
          if (p.id > maxId) maxId = p.id;
        }
        lastId = maxId + 1;
      }
      setState(() {});
    });
  }

  Future<void> _displayTextInputDialog(
      BuildContext context, String action, int id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Meno'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onChanged: (val) {
              setState(() {
                nameFromDialog = val;
              });
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('ZRUŠIŤ'),
            ),
            ElevatedButton(
              onPressed: () {
                if (action == 'add') {
                  PersonsDB()
                      .insertPerson(
                          Person(id: id, name: nameFromDialog, wins: 0))
                      .then((val) {
                    getData();
                  });
                  setState(() {
                    lastId += 1;
                  });
                } else if (action == 'update') {
                  PersonsDB()
                      .updatePerson(Person(
                          id: persons[id].id,
                          name: nameFromDialog,
                          wins: persons[id].wins))
                      .then((val) {
                    getData();
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('PRIDAŤ'),
            ),
          ],
        );
      },
    );
  }

  String nameFromDialog = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 40.0,
          ),
          onPressed: () {
            _displayTextInputDialog(context, 'add', lastId);
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: persons.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(persons[index].toString()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      _displayTextInputDialog(context, 'update', index);
                    },
                    icon: const Icon(
                      Icons.update,
                      color: Colors.black,
                      size: 20.0,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      PersonsDB().deltePerson(persons[index].id).then((val) {
                        getData();
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.black,
                      size: 20.0,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }
}

class SelectPeoplePage extends StatefulWidget {
  const SelectPeoplePage({Key? key}) : super(key: key);

  @override
  _SelectPeoplePageState createState() => _SelectPeoplePageState();
}

class _SelectPeoplePageState extends State<SelectPeoplePage> {
  Map<Person, bool> selectedNames = {};
  List<Person> persons = [];

  createNamesMap() {
    Map<Person, bool> ret = {};
    for (var e in persons) {
      ret[e] = true;
    }
    return ret;
  }

  @override
  initState() {
    getData();
    super.initState();
  }

  void getData() async {
    PersonsDB().persons().then((result) {
      persons = result;
      selectedNames = createNamesMap();
      setState(() {});
    });
  }

  getChecked() {
    List<Person> selected = [];
    selectedNames.forEach((key, val) {
      if (val == true) selected.add(key);
    });
    return selected;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GamesPage(names: getChecked()))),
            child: const Text('Vybrať'),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 28.0),
          child: ListView(
            shrinkWrap: true,
            children: selectedNames.keys.map((key) {
              return CheckboxListTile(
                title: Text(key.toString()),
                value: selectedNames[key],
                checkColor: Colors.white,
                onChanged: (val) {
                  setState(() {
                    selectedNames[key] = val!;
                  });
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
