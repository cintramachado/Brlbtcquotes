import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import "dart:core";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bitquote',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.black),
      home: const MyHomePage(title: 'BitQuote'),
    );
  }
}

Future getquotes() async {
  var uriquote = Uri.parse("https://cointradermonitor.com/api/pbb/v1/ticker");
  final response = await http.get(uriquote);

  return response.body;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final realcontroller = TextEditingController();
  final btccontroller = TextEditingController();
  final satoshicontroller = TextEditingController();
  final current = getquotes();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title,
              style: const TextStyle(
                fontSize: 25.0,
              )),
          toolbarHeight: 50.0,
          //insert a button to refresh the quote in the appbar
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    getquotes();
                  });
                },
                icon: const Icon(Icons.refresh))
          ],
        ),
        body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                  future: getquotes(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      final Map data = json.decode(snapshot.data.toString());
                      return Text("Btc/Brl ${data["last"].toString()}",
                          style: const TextStyle(
                              fontSize: 15.0, color: Colors.amberAccent));
                    } else if (snapshot.hasError) {
                      return const Text("Erro ao carregar a cotação",
                          style: TextStyle(
                              fontSize: 15.0, color: Colors.amberAccent));
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
              const Divider(
                color: Colors.black12,
              ),
              entrarmoeda("Reais", "R\$", realcontroller),
              const Divider(
                color: Colors.black,
              ),
              entrarmoeda("Btc", "btc", btccontroller),
              const Divider(
                color: Colors.black,
              ),
              entrarmoeda("Satoshis", "sat", satoshicontroller)
            ],
          ),
        )));
  }
}

Widget entrarmoeda(moeda, hinttext, TextEditingController textcontroller) {
  return Container(
      padding: const EdgeInsets.all(20.0),
      child: TextFormField(
        style: const TextStyle(color: Colors.amberAccent),
        decoration: InputDecoration(
          focusColor: Colors.amberAccent,
          label: Text(moeda),
          labelStyle:
              const TextStyle(fontSize: 25.0, color: Colors.amberAccent),
          hintStyle: const TextStyle(color: Colors.amberAccent),
          hintText: hinttext,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.amberAccent)),
        ),
        keyboardType: TextInputType.number,
        cursorColor: Colors.amberAccent,
        onChanged: (value) {},
        controller: textcontroller,
      ));
}
