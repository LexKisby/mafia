import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

final myDataProvider = ChangeNotifierProvider<DataChangeNotifier>((ref) {
  return DataChangeNotifier();
});

class DataChangeNotifier extends ChangeNotifier {
  String myUsername = '';
  bool isAdmin = false;
  String roomCode = '';
  bool newRoom = false;
  final db = FirebaseFirestore.instance;
  List<bool> settings = [true, false, false];

  void updateSettings(int index, bool b) {
    settings[index] = b;
    notifyListeners();
  }

  void test() {
    db.collection('rooms').doc('hello').set(
      {
        'name': 'bossman'
      }).then((_){
        print('ye boi');
      });
    
  }

  //Future<bool> updateUsername(String value) async {
  // Future<bool> res = database.collections.addname();
  //return res;
  //}
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Mafia',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme(background: Colors.purple,
          primary: Colors.amber,
          primaryVariant: Colors.amber,
          onBackground: Colors.grey,
          onError: Colors.white,
          onPrimary: Colors.grey,
          onSecondary: Colors.grey,
          onSurface: Colors.white,
          secondary: Colors.amber,
          secondaryVariant: Colors.amber,
          surface: Colors.blueGrey,
          brightness: Brightness.light,
          error: Colors.red,
          ),
          primarySwatch: Colors.amber,
          textTheme: TextTheme(bodyText1: TextStyle(color: Colors.grey), bodyText2: TextStyle(color: Colors.grey))
              .apply(bodyColor: Colors.grey, displayColor: Colors.grey),
        ),
        home: RoomFinder(),
      ),
    );
  }
}

class SettingsPage extends ConsumerWidget {
  Widget build(BuildContext context, ScopedReader watch) {
    final data = watch(myDataProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.white, Colors.black],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          )),
          child: SettingsPageContent(),
        )),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueGrey,
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                Spacer()
              ],
            )),
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: () {data.test();}, child: Icon(Icons.play_arrow)),
    );
  }
}

class RoomFinder extends ConsumerWidget {
  Widget build(BuildContext context, ScopedReader myDataProvider) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Colors.white, Colors.black],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                )),
                child: Center(
                  child: RoomFinderContent(),
                ))),
      ),
    );
  }
}

class RoomFinderContent extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context, ScopedReader watch) {
    final data = watch(myDataProvider);
    return Expanded(
      flex: 1,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
              child: Column(
            children: [
              Card(
                child: Image.asset("lib/assets/mafia.jpg"),
                elevation: 20,
              ),
              Container(
                width: 250,
                child: TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'What do people call you?',
                    labelText: 'Username *',
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    data.myUsername = value;
                    //data.updateUsername(value);
                    print(value);
                    return null;
                  },
                ),
              ),
              Container(height: 20),
              OutlineGradientButton(
                onTap: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    data.newRoom = true;
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Processing Data')));
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  }
                },
                child: Text("Create Room",
                    style: TextStyle(color: Colors.black, fontSize: 20)),
                strokeWidth: 4,
                gradient: LinearGradient(
                    colors: [Colors.red, Colors.amber],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft),
                radius: Radius.circular(4),
              ),
              Container(height: 20),
              Container(
                width: 250,
                child: TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.room),
                    hintText: 'e.g. alf48392',
                    labelText: 'Room Code *',
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    data.roomCode = value;
                    print(value);
                    return null;
                  },
                ),
              ),
              Container(height: 20),
              OutlineGradientButton(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  }
                },
                child: Text("Join Room",
                    style: TextStyle(color: Colors.black, fontSize: 20)),
                strokeWidth: 4,
                gradient: LinearGradient(
                    colors: [Colors.red, Colors.amber],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft),
                radius: Radius.circular(4),
              )
            ],
          )),
        ),
      ),
    );
  }
}

class SettingsPageContent extends ConsumerWidget {
  build(BuildContext context, ScopedReader watch) {
    final data = watch(myDataProvider);

    return ListView(padding: EdgeInsets.all(20), children: [
      Title("S E T T I N G S"),
      Padding(
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: Row(
          children: [
            Spacer(),
            Container(child: Text('Setting 1')),
            Checkbox(
                value: data.settings[0],
                onChanged: (value) {
                  data.updateSettings(0, value ?? false);
                }),
            Gap(),
            Container(child: Text('Setting 2')),
            Checkbox(
                value: data.settings[1],
                onChanged: (value) {
                  data.updateSettings(1, value ?? false);
                }),
            Gap(),
            Container(child: Text('Setting 3')),
            Checkbox(
                value: data.settings[2],
                onChanged: (value) {
                  data.updateSettings(2, value ?? false);
                }),
            Spacer()
          ],
        ),
      ),
      Container(height: 40),
      Title("C A R D S"),
      Row(
        children: [
          Spacer(),
          PCard(),
          Gap(),
          PCard(),
          Gap(),
          PCard(),
          Gap(),
          PCard(),
          Spacer()
        ],
      ),
    ]);
  }
}

class Title extends StatelessWidget {
  Title(
    this.text,
  );

  final String text;

  @override
  build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 50,
        child: Center(
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: Text(text,
                style: TextStyle(color: Colors.grey, fontSize: 400.0)),
          ),
        ),
      ),
    );
  }
}

class PCard extends StatelessWidget {
  @override
  build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    final w = s.width / 8;
    return Card(
        child: Container(height: 1.6 * w, width: w, child: Text("Card 1")));
  }
}

class Gap extends StatelessWidget {
  @override
  build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    final w = s.width / 30;
    return Container(width: w);
  }
}
