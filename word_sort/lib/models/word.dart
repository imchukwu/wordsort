import 'package:word_sort/repository/database_creator.dart';

class Word{
  int id;
  String word;
  String description;
  int level;
  bool isDeleted;

  Word(this.id, this.word, this.description, this.level, this.isDeleted);

  Word.fromJson(Map<String, dynamic> json){
    this.id = json[DatabaseCreator.id];
    this.word = json[DatabaseCreator.word];
    this.description = json[DatabaseCreator.description];
    this.level = json[DatabaseCreator.level];
    this.isDeleted = json[DatabaseCreator.isDeleted] == 1;
  }
}