import 'dart:math';

import 'package:flutter/material.dart';
import 'package:word_sort/models/word.dart';
import 'package:word_sort/repository/database_creator.dart';
import 'package:word_sort/repository/word_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseCreator().initDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WordSort(title: 'Flutter Demo Home Page'),
    );
  }
}

class WordSort extends StatefulWidget {
  WordSort({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WordSortState createState() => _WordSortState();
}

class _WordSortState extends State<WordSort> {
  final _formKey = GlobalKey<FormState>();
  Future<List<Word>> future;
  String actualWord;
  int id;

  @override
  initState() {
    super.initState();
    future = WordRepository.getAllWords();
  }

  void readData() async {
    final word = await WordRepository.getWord(id);
    print(word.word);
  }

  updateWord(Word word) async {
    word.word = 'please 🤫';
    await WordRepository.updateWord(word);
    setState(() {
      future = WordRepository.getAllWords();
    });
  }

  deleteWord(Word word) async {
    await WordRepository.deleteWord(word);
    setState(() {
      id = null;
      future = WordRepository.getAllWords();
    });
  }

  Card buildItem(Word word) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'word: ${word.word}',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'description: ${word.description}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'level: ${word.level}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  onPressed: () => updateWord(word),
                  child: Text('Update word', style: TextStyle(color: Colors.white)),
                  color: Colors.green,
                ),
                SizedBox(width: 8),
                FlatButton(
                  onPressed: () => deleteWord(word),
                  child: Text('Delete'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  TextFormField buildTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'name',
        fillColor: Colors.grey[300],
        filled: true,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
      },
      onSaved: (value) => actualWord = value,
    );
  }

  void createWord() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      int count = await WordRepository.wordCount();
      // final word = Word(count, word, randomWord(), false);
      final word = Word(count, actualWord, "Hello world!", 17,  false);
      await WordRepository.addWord(word);
      setState(() {
        id = word.id;
        future = WordRepository.getAllWords();
      });
      print(word.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('sqfLite CRUD'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          Form(
            key: _formKey,
            child: buildTextFormField(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: createWord,
                child: Text('Create', style: TextStyle(color: Colors.white)),
                color: Colors.green,
              ),
              RaisedButton(
                onPressed: id != null ? readData : null,
                child: Text('Read', style: TextStyle(color: Colors.white)),
                color: Colors.blue,
              ),
            ],
          ),
          FutureBuilder<List<Word>>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(children: snapshot.data.map((word) => buildItem(word)).toList());
              } else {
                return SizedBox();
              }
            },
          )
        ],
      ),
    );
  }

  String randomWord() {
    final randomNumber = Random().nextInt(4);
    String word;
    switch (randomNumber) {
      case 1:
        word = 'Like and subscribe 💩';
        break;
      case 2:
        word = 'Twitter @robertbrunhage 🤣';
        break;
      case 3:
        word = 'Patreon in the description 🤗';
        break;
      default:
        word = 'Leave a comment 🤓';
        break;
    }
    return word;
  }
}