// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

//import 'dart:html';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashlight',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          backgroundColor: Colors.blueGrey),
      home: const RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
  bool pressed = true;

  final _buttonStyle1 = ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      alignment: Alignment.center,
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      minimumSize: MaterialStateProperty.all<Size>(const Size(130.0, 60.0)),
      textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(fontSize: 18.0)));

  final _buttonStyle2 = ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      alignment: Alignment.center,
      backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
      minimumSize: MaterialStateProperty.all<Size>(const Size(130.0, 60.0)),
      textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(fontSize: 18.0)));

  Widget _buildSuggestions() {
    return Center(
        child: TextButton(
            style: pressed ? _buttonStyle1 : _buttonStyle2,
            onPressed: () {
              setState(() {
                pressed = !pressed;
              });
            },
            child: const Text('lamp')));
    return ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return const Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.green : null,
        semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Settings'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  void _pressed() {
    _scrollController.jumpTo(0);
  }

  void _onpressed() {}

  @override
  Widget build(BuildContext context) {
    //final wordPair = WordPair.random();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashlight'),
        actions: [
          IconButton(
            icon: const Icon(Icons.miscellaneous_services_rounded),
            onPressed: _pushSaved,
            tooltip: 'Settings',
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _pressed,
      //   tooltip: 'Top level',
      //   child: const Icon(Icons.arrow_upward),
      // ),
      body: _buildSuggestions(),
    );
  }
}
