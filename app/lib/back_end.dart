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

  //CARDS
  List<String> allCards = [
    'VILLAGER',
    'GODFATHER',
    'MAFIOSO',
    'DOCTOR',
    'DETECTIVE',
    'JESTER',
    'GUNSLINGER',
    'SHERIFF',
    'SEER'
  ];

  Map<String, String> cardInfo = {
    'VILLAGER': 'Standard Card. Participates in votes, and has no special abilities.',
    'GODFATHER': 'Special Card. Like MAFIOSO, but has the same card value as VILLAGER so cannot be found by DETECTIVE.',
    'MAFIOSO': 'Standard Card. Awakens at Night in order to kill a player, cannot kill other MAFIOSO/GODFATHER.',
    'DOCTOR': 'Special Card. Can choose someone to save during the Night. Saved player cannot be harmed during the same Night phase.',
    'DETECTIVE': "Special Card. Can infer a player's card number once per Night.",
    'JESTER': 'Special Card. Player objective is to die. Other win conditions take precedence in tie.',
    'GUNSLINGER': 'Special Card. Player can at any moment kill another player, ONCE per game.',
    'SHERIFF': 'Can imprison ONE player per Night. Imprisoned players cannot participate in Night phase. Players can only be imprisoned ONCE per game.',
    'SEER': "Special Card. Can infer the Suit of a player's Card ONCE per Night.",
  };

  void addCard(name) {
    appdata.inPlay.add(name);
    updateCards();
    notifyListeners();
  }

  void removeCard(name) {
    appdata.inPlay.remove(name);
    updateCards();
  }

  void updateCards() {
    db.collection('rooms').doc(roomCode).update({
      'in_play': appdata.inPlay,
    });
  }
  

  final db = FirebaseFirestore.instance;
  Alldata appdata = Alldata();
  var sub;
  bool initFlag = false;

  void init() {
    if (initFlag) return;
    initFlag = true;
    initSub();
    print('initialised listener');
  }

  void reset() {
    print('resetting');
    initFlag = false;
    sub.cancel();
  }

  void initSub() {
    sub = db.collection('rooms').doc(roomCode).snapshots().listen(
      (snapshot) {
        print('change');
        appdata
          ..admin = snapshot['admin']
          ..settings = snapshot['settings']
          ..usernames = snapshot['user_names']
          ..user_content = Map<String, dynamic>.from(snapshot['user_content'])
          ..inPlay = snapshot['in_play'];
        isAdmin = checkAdmin(myUsername);
        generateAvatars();
        notifyListeners();
      },
      onError: (err) {
        print(err);
      },
      cancelOnError: false,
    );
  }

  void deleteUser(name) {
    appdata.usernames.remove(name);
    db.collection('rooms').doc(roomCode).update({
      'user_content.${name}': FieldValue.delete(),
      'user_names': appdata.usernames
    });
  }

  bool checkAdmin(name) {
    if (name == appdata.admin) return true;
    return false;
  }

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  void findRoom(context) {
    isAdmin = false;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('finding Room: ' + roomCode)));
    db.collection('rooms').doc(roomCode).get().then((docSnapshot) {
      if (docSnapshot.exists) {
        db.collection('rooms').doc(roomCode).update({
          'user_names': FieldValue.arrayUnion([myUsername]),
          'user_content.${myUsername}': {
            'card': [0, 0],
            'role': 'Villager',
            'voted_for': [],
            'votes_avail': 1,
            'is_dead': false,
            'showing_card': false,
          }
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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Processing')));
    roomCode = getRandomString(5);
    db.collection('rooms').doc(roomCode).get().then((docSnapshot) {
      if (docSnapshot.exists) {
        //clean
        //setup
      } else {
        db.collection('rooms').doc(roomCode).set({
          'user_names': [myUsername],
          'user_content': {
            myUsername: {
              'card': [0, 0],
              'role': 'Villager',
              'voted_for': [],
              'votes_avail': 1,
              'is_dead': false,
              'showing_card': false,
            }
          },
          'settings': appdata.settings,
          'in_play': ['VILLAGER'],
          'admin': myUsername,
          'votes': {},
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
      appdata.settings[2] = appdata.settings[2] + b;
      if (appdata.settings[2] < 1) {
        appdata.settings[2] = 1;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Mafioso cannot be less than 1')));
      }
    } else {
      appdata.settings[index] = b;
    }
    db
        .collection('rooms')
        .doc(roomCode)
        .update({'settings': appdata.settings}).then((_) {
      print('settings update');
      print(appdata.settings);
    });
    notifyListeners();
  }

  void startGame(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GamePage()),
    );
  }

  void generateAvatar(String name) async {
    String rawSvg = multiavatar(name);
    var root = await svg.fromSvgString(rawSvg, rawSvg);
    appdata.user_content[name]!['avatar'] = root;
  }

  void generateAvatars() async {
    appdata.usernames.forEach((name) => generateAvatar(name));
    print('generated avatars');
  }
}
