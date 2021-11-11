part of library;

class GamePage extends StatelessWidget {
  @override
  build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: Container(
                    constraints: BoxConstraints.expand(),
                    decoration: bwBG,
                    child: GamePageContent()))),
        appBar: GameBarContent());
  }
}

class GameBarContent extends ConsumerWidget with PreferredSizeWidget {
  @override
  build(BuildContext context, ScopedReader watch) {
    final data = watch(myDataProvider);
    if (data.appdata.game_running == false || data.appdata.room_destroyed) {
      Navigator.of(context).pop();
    }
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
        GameChips(),
        Gap(),
        //GameChat(),
      ],
    );
  }
}

class GameChips extends ConsumerWidget {
  @override
  build(BuildContext context, ScopedReader watch) {
    final data = watch(myDataProvider);
    return Center(
      child: Container(
        height: 400,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 5.5,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: data.appdata.usernames.length,
              itemBuilder: (BuildContext context, index) {
                String name = data.appdata.usernames[index];
                Color c = data.appdata.user_content[name]['is_dead'] == false
                    ? Colors.grey
                    : Colors.red;
                return Container(
                  alignment: Alignment.center,
                  child: ActionChip(
                    backgroundColor: c,
                    onPressed: () {},
                    avatar: Avatar(name),
                    label: Text(name),
                  ),
                );
              }),
        ),
      ),
    );
  }
}

class GameCharacters extends ConsumerWidget {
  @override
  build(BuildContext context, ScopedReader watch) {
    final data = watch(myDataProvider);
    return Container(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 3),
        itemCount: 1, //data.appdata.usernames.length,
        itemBuilder: (context, index) {
          String name = data.appdata.usernames[index];
          Color c = data.appdata.user_content[name]['is_dead'] == false
              ? Colors.grey
              : Colors.red;
          return (Container(
            child: ListTile(
              //onPressed: () {},
              //backgroundColor: c,
              leading: Avatar(name),
              title: Text(name),
            ),
          ));
        },
      ),
    );
  }
}

class GameChat extends ConsumerWidget {
  @override
  build(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;
    //final data = watch(myDataProvider);
    return Container(
        width: size.width * 0.7, height: 300, color: Colors.deepPurple);
  }
}
