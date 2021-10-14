import 'package:flutter/material.dart';
import 'package:multiavatar/multiavatar.dart';
import 'package:avatars/avatars.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:playing_cards/playing_cards.dart';
import 'dart:math';
import 'dart:core';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

final myDataProvider = ChangeNotifierProvider<DataChangeNotifier>((ref) {
  return DataChangeNotifier();
});

class Roles {}

class DataChangeNotifier extends ChangeNotifier {
  bool newRoom = false;
  String myUsername = '';
  bool isAdmin = false;
  String roomCode = '';
  DateTime date = DateTime.now();

  final db = FirebaseFirestore.instance;
  List<bool> settings = [true, false, false];
  List<Roles> roles = [];
  List<int> votes = [];
  var users = <String, List>{
    'me': ['me', 'joker', 1, 'you']
  };
  String rawSvg = multiavatar('cry');
  List<DrawableRoot> roots = [];
  

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  void findRoom(context) {
    isAdmin = false;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('finding Room: ' + roomCode)));
  }

  void generateRoom(context) {
    test();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Processing')));
    roomCode = getRandomString(5);
    db.collection('rooms').doc(roomCode).get().then((docSnapshot) {
      if (docSnapshot.exists) {
        //clean
        //setup
      } else {
        db.collection('rooms').doc(roomCode).set({
          'users': [
            {
              'name': myUsername,
              'role': 'Villager',
              'card': [0, 0]
            }
          ],
          'settings': settings,
          'votes': [],
          'expiry': Timestamp.fromDate(date.add(Duration(days: 1)))
        });
        isAdmin = true;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Success')));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );
      }
    });
  }

  void updateSettings(int index, bool b) {
    settings[index] = b;
    db
        .collection('rooms')
        .doc(roomCode)
        .update({'settings': settings}).then((_) {
      print('settings update');
      print(settings);
    });
    notifyListeners();
  }

  void startGame(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GamePage()),
    );
  }

  void test() async {
    roots = [];
    rawSvg = multiavatar(myUsername);
    var root = await svg.fromSvgString(rawSvg, rawSvg);
    roots.add(root);
    notifyListeners();
  }
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
          colorScheme: ColorScheme(
            background: Colors.purple,
            primary: Colors.amber,
            primaryVariant: Colors.amber,
            onBackground: Colors.grey,
            onError: Colors.white,
            onPrimary: Colors.grey,
            onSecondary: Colors.grey,
            onSurface: Colors.amber,
            secondary: Colors.amber,
            secondaryVariant: Colors.amber,
            surface: Colors.blueGrey,
            brightness: Brightness.light,
            error: Colors.red,
          ),
          primarySwatch: Colors.amber,
          textTheme: TextTheme(
                  bodyText1: TextStyle(color: Colors.grey),
                  bodyText2: TextStyle(color: Colors.grey))
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
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                Gap(),
                Title("ROOM: " + data.roomCode),
                Gap(),
                Avatar(),
                Spacer()
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            data.startGame(context);
          },
          child: Icon(Icons.play_arrow)),
    );
  }
}

class Avatar extends ConsumerWidget {
  bool checkReady(data) {
    print(data.roots);
    return (data.roots.length == 0);
  }
  
  @override
  build(BuildContext context, ScopedReader watch) {
    final data = watch(myDataProvider);
    final bool flag = checkReady(data);
    
    return flag
        ? SizedBox.shrink()
        : Container(
          height: 50,
          width: 50,
          child: CustomPaint(
              child: Container(),
              painter: MyPainter(data.roots[0], Size(100.0, 100.0))),
        );
  }
}

class MyPainter extends CustomPainter {
  MyPainter(this.svg, this.size);

  final DrawableRoot svg;
  final Size size;
  @override
  void paint(Canvas canvas, Size size) {
    svg.scaleCanvasToViewBox(canvas, size);
    svg.clipCanvasToViewBox(canvas);
    svg.draw(canvas, Rect.zero);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
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
        child: Center(child: RoomFinderContent()),
      ))),
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

                    print(value);
                    return null;
                  },
                ),
              ),
              Container(height: 20),
              OutlineGradientButton(
                onTap: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  data.newRoom = true;
                  if (_formKey.currentState!.validate()) {
                    data.generateRoom(context);
                  }
                  data.newRoom = false;
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
                      if (data.newRoom) {
                        return null;
                      }
                      return 'Please enter some text';
                    }
                    data.roomCode = value;

                    return null;
                  },
                ),
              ),
              Container(height: 20),
              OutlineGradientButton(
                onTap: () {
                  data.newRoom = false;
                  if (_formKey.currentState!.validate()) {
                    data.findRoom(context);
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
      Title("C A R D S   I N   P L A Y"),
      Row(
        children: [
          Spacer(),
          PCard('JOKER'),
          Gap(),
          PCard('DOCTOR'),
          Gap(),
          PCard('DETECTIVE'),
          Gap(),
          PCard('GUNSLINGER'),
          Spacer()
        ],
      ),
      Title("E X T R A   C A R D S"),
    ]);
  }
}

class GamePage extends StatelessWidget {
  @override
  build(BuildContext context) {
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
                    child: GamePageContent()))),
        appBar: GameBarContent());
  }
}

class GameBarContent extends ConsumerWidget with PreferredSizeWidget {
  @override
  build(BuildContext context, ScopedReader watch) {
    final data = watch(myDataProvider);

    return AppBar(title: Title('D A Y'), actions: [
      Card(
          child:
              Container(width: 150, child: Center(child: Text(data.roomCode)))),
      Gap(),
      Card(
          child: Container(
              width: 150, child: Center(child: Text('Votes in 00:00')))),
      Gap(),
    ]);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class GamePageContent extends ConsumerWidget {
  @override
  build(BuildContext context, ScopedReader watch) {
    final data = watch(myDataProvider);

    return Column(
      children: [
        Row(children: [Title(data.myUsername), Spacer()]),
        GameCharacters(),
        Gap(),
        GameChat(),
      ],
    );
  }
}

class GameCharacters extends ConsumerWidget {
  @override
  build(BuildContext context, ScopedReader watch) {
    final data = watch(myDataProvider);
    return Card(
        child: Container(height: 20, width: 20),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)));
  }
}

class GameChat extends ConsumerWidget {
  @override
  build(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;
    final data = watch(myDataProvider);
    return Container(
        width: size.width * 0.7, height: 300, color: Colors.deepPurple);
  }
}

class Title extends StatelessWidget {
  Title(
    this.text,
  );

  final String text;

  @override
  build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: min(w / 10, 90),
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
  PCard(this.name);

  final String name;

  @override
  build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    final w = s.width / 8;
    return Card(
      child: Container(
        height: min(1.6 * w, 300),
        child: PlayingCardView(
          card: PlayingCard(Suit.clubs, CardValue.ace),
        ),
      ),
    );
  }
}

class Gap extends StatelessWidget {
  @override
  build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    final w = s.width / 30;
    return Container(width: w, height: w);
  }
}
