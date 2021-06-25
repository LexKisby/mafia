import 'package:flutter/material.dart';
//import './library.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';

void main() {
  runApp(MyApp());
}

final myDataProvider = ChangeNotifierProvider<DataChangeNotifier>((ref) {
  return DataChangeNotifier();
});

class DataChangeNotifier extends ChangeNotifier {
  String myUsername = '';

  //Future<bool> updateUsername(String value) async {
  // Future<bool> res = database.collections.addname();
  //return res;
  //}
}

class Data extends ChangeNotifier {}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.amber,
        ),
        home: RoomFinder(),
      ),
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
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Processing Data')));
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
                    print(value);
                    return null;
                  },
                ),
              ),
              Container(height: 20),
              OutlineGradientButton(
                onTap: () {
                  print('join room');
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
