part of library;


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
                Gap(),
                Admin(),
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