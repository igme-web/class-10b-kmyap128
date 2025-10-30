import 'dart:convert';

import 'package:flutter/material.dart';

// 1) You need to install this so it works 'flutter pub add http'
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';

//This is where we will fetch some sample JSON (have a look at it please)
final String postURL = "https://jsonplaceholder.typicode.com/posts";

// 2) ADD your JItem class below (we'll do in class or grab from 10b notes)
class JItem {
  final int id;
  final String title;

  JItem({required this.id, required this.title});

}

class JItemsProvider extends ChangeNotifier {
  List<JItem> items = [];

  final String postURL = "https://jsonplaceholder.typicode.com/posts";

  Future<void> getData() async {

    var response = await http.get(Uri.parse(postURL));

    if(response.statusCode == 200) {
      var data = json.decode(response.body);

      for(var item in data) {
        items.add(
          JItem(
            id: item['id'],
            title: item['title'],
          )
        );
      }
    }
    notifyListeners();
  }

    void clear() {
    items.clear();
    notifyListeners();
  }
}


 
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(context) => JItemsProvider(),
      child: const MaterialApp(home: DemoPage())
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {

  //3 Add better type checking here use the <JList> we created
  //List data = [];
  List<JItem> data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Example'), backgroundColor: Colors.blue),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Get data logic here
                    context.read<JItemsProvider>().getData();
                  },
                  child: Text('Get Data'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Clear data logic here
                    context.read<JItemsProvider>().clear();
                  },
                  child: Text('Clear Data'),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: context.watch<JItemsProvider>().items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(context.watch<JItemsProvider>().items[index].id.toString()),
                    subtitle: Text(context.watch<JItemsProvider>().items[index].title),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//4) Create the getData Function here!
