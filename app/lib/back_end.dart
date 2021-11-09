part of library;

final myDataProvider = ChangeNotifierProvider<DataChangeNotifier>((ref) {
  return DataChangeNotifier();
});

class DataChangeNotifier extends ChangeNotifier {
  bool newRoom = false;
  String myUsername = '';
  bool isAdmin = false;
  String roomCode = '';
  DateTime date = DateTime.now();

  final db = FirebaseFirestore.instance;
  List<dynamic> settings = [true, false, 1];
  List<Roles> roles = [];
  List<int> votes = [];
  var cloud;
  String rawSvg = multiavatar('cry');
  List<DrawableRoot> roots = [];


  StreamBuilder listener(context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: db.collection('rooms').doc(roomCode).snapshots(),
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) return Text('...Loading');
        
        return Text(snapshot.data!['users'].toString());
      }
    );
  }

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  void findRoom(context) {
    cleanRoots();
    generateAvatar();
    isAdmin = false;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('finding Room: ' + roomCode)));
    db.collection('rooms').doc(roomCode).get().then((docSnapshot) {
      if (docSnapshot.exists) {
        db.collection('rooms').doc(roomCode).update({
          'users': FieldValue.arrayUnion([
            {
              'name': myUsername,
              'role': 'Villager',
              'card': [0, 0]
            }
          ])
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Can't join room: " + roomCode)));
      }
    });
  }

  void generateRoom(context) {
    cleanRoots();
    generateAvatar();
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

  void updateSettings(int index, b, context) {
    if (index == 2) {
      settings[2] = settings[2] + b;
      if (settings[2] < 1) {
        settings[2] = 1;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Mafioso cannot be less than 1')));
      }
    } else {
      settings[index] = b;
    }
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

  void cleanRoots() {
    roots = [];
  }

  void generateAvatar() async {
    rawSvg = multiavatar(myUsername);
    var root = await svg.fromSvgString(rawSvg, rawSvg);
    roots.add(root);
    notifyListeners();
  }
}
