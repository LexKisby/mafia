part of library;

class SettingsPage extends ConsumerWidget {
  Widget build(BuildContext context, ScopedReader watch) {
    final data = watch(myDataProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Container(
          constraints: BoxConstraints.expand(),
          decoration: bwBG,
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
                      data.reset();

                      Navigator.pop(context);
                    }),
                Gap(),
                Title("ROOM: " + data.roomCode),
                Gap(),
                Avatar(data.myUsername),
                Gap(),
                Admin(data.myUsername),
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
    final ScrollController _scrollControllerA = ScrollController();
    final ScrollController _scrollControllerB = ScrollController();

    return ListView(padding: EdgeInsets.all(20), children: [
      Title("S E T T I N G S"),
      Padding(
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: Row(
          children: [
            Spacer(),
            Container(child: Text('Card revealed on death')),
            Checkbox(
                value: data.appdata.settings[0],
                onChanged: (value) {
                  data.updateSettings(0, value ?? false, context);
                }),
            Gap(),
            Container(child: Text('Enable option to reveal card voluntarily')),
            Checkbox(
                value: data.appdata.settings[1],
                onChanged: (value) {
                  data.updateSettings(1, value ?? false, context);
                }),
            Gap(),
            Spacer()
          ],
        ),
      ),
      //Text(data.appdata.settings.toString()),

      Container(height: 40),
      Title("C A R D S   I N   P L A Y"),
      Container(
        height: 150,
        child: Scrollbar(
          isAlwaysShown: true,
          controller: _scrollControllerA,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            controller: _scrollControllerA,
            itemCount: data.appdata.inPlay.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return Gap();
              return CardSize(data.appdata.inPlay[index - 1], 0, 1);
            },
            separatorBuilder: (context, index) {
              return Gap();
            },
          ),
        ),
      ),
      Title("E X T R A   C A R D S"),
      Container(
        height: 150,
        child: Scrollbar(
          isAlwaysShown: true,
          controller: _scrollControllerB,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            controller: _scrollControllerB,
            itemCount: data.allCards.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return Gap();
              return PCard(data.allCards[index - 1], 0);
            },
            separatorBuilder: (context, index) {
              return Gap();
            },
          ),
        ),
      ),
      Title("P L A Y E R S"),
      SettingsPlayers(),
    ]);
  }
}

class SettingsPlayers extends ConsumerWidget {
  @override
  build(BuildContext context, ScopedReader watch) {
    final data = watch(myDataProvider);
    data.init();
    return Center(
      child: Container(
        height: 250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 4.5,
              ),
              itemCount: data.appdata.usernames.length,
              itemBuilder: (BuildContext context, index) {
                String name = data.appdata.usernames[index];
                return Container(
                  color: Colors.grey.shade400,
                  alignment: Alignment.center,
                  child: ListTile(
                    hoverColor: Colors.grey.shade400,
                    enabled: true,
                    leading: Avatar(name),
                    title: Row(children: [Text(name), Admin(name)]),
                    trailing: data.isAdmin
                        ? IconButton(
                            onPressed: () {
                              print('deleting: $name');
                              data.deleteUser(name);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Removed ${name}')));
                            },
                            icon: Icon(Icons.remove_circle))
                        : Container(height: 0, width: 0),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
