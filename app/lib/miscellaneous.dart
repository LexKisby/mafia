part of library;

class Alldata {
  List<dynamic> usernames = [];
  Map<String, dynamic> user_content = {};
  String admin = '';
  Map<String, int> votes = {};
  List<dynamic> settings = [true, false, 1];

}

final bwBG = BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.grey.shade300, Colors.black],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                      border: Border.all(color: Colors.grey));

final bwSmall = BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.grey.shade700, Colors.grey.shade300],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                      border: Border.all(color: Colors.grey));

class Admin extends ConsumerWidget {
  Admin(this.name);
  final String name;

  @override
  build(BuildContext context, ScopedReader watch) {
    final data = watch(myDataProvider);
    return data.checkAdmin(name) ? Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.red, Colors.amber]),
            border: Border.all(color: Colors.redAccent)),
        child: Container(
          decoration: BoxDecoration(color: Colors.blueGrey),
          child: Padding(
            padding: EdgeInsets.all(3),
            child: GradientText("ADMIN", gradient: LinearGradient(colors: [Colors.red, Colors.amber])),
          ),
        ),
      ),
    ) : Container(height: 0, width: 0);
  }
}

class Avatar extends ConsumerWidget {
  Avatar(this.name);
  final name;

  bool checkReady(data) {
    return (data.appdata.user_content?[name]?['avatar'] == null);
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
                painter: MyPainter(data.appdata.user_content[name]!['avatar'], Size(100.0, 100.0))),
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
  PCard(this.name, this.suit, this.value);


  final String name;
  final Suit suit;
  final CardValue value;

  @override
  build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    final w = s.width / 8;
    return Card(
      child: Container(
        height: min(1.6 * w, 300),
        child: PlayingCardView(
          card: PlayingCard(suit, value),
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

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}