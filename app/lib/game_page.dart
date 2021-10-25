part of library;


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

