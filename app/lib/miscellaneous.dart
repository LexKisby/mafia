part of library;


class Roles {}


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