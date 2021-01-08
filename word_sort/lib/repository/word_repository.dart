import 'package:word_sort/models/word.dart';
import 'package:word_sort/repository/database_creator.dart';

class WordRepository{
  static Future<List<Word>> getAllWords() async {
    final sql = '''SELECT * FROM ${DatabaseCreator.wordTable}
    WHERE ${DatabaseCreator.isDeleted} == 0''';
    final data = await db.rawQuery(sql);
    List<Word> words = List();

    for(final node in data){
       final word = Word.fromJson(node);
       words.add(word);
    }
    return words;
  }

  static Future<Word> getWord(int id) async {
    // final sql = '''SELECT * FROM ${DatabaseCreator.wordTable}
    // WHERE ${DatabaseCreator.id} == $id''';
    // final data = await db.rawQuery(sql);

    // final word = Word.fromJson(data[0]);
    // return word;
    final sql = '''SELECT * FROM ${DatabaseCreator.wordTable}
    WHERE ${DatabaseCreator.id} = ?''';

    List<dynamic> params = [id];
    final data = await db.rawQuery(sql, params);

    final todo = Word.fromJson(data.first);
    return todo;
  }

  static Future<Word> addWord(Word word) async {
    final sql = '''INSERT INTO ${DatabaseCreator.wordTable}
    (
      ${DatabaseCreator.id},
      ${DatabaseCreator.word},
      ${DatabaseCreator.description},
      ${DatabaseCreator.level},
      ${DatabaseCreator.isDeleted}
    )
    VALUES (?,?,?,?,?)''';
    List<dynamic> params = [word.id, word.word, word.description, word.level, word.isDeleted ? 1 : 0];
    final result = await db.rawInsert(sql, params);
    DatabaseCreator.databaseLog('Add word', sql, null, result, params);

  }

  static Future<Word> deleteWord(Word word) async {
    // final sql = '''UPDATE * FROM ${DatabaseCreator.wordTable}
    // SET ${DatabaseCreator.isDeleted} = 1
    // WHERE ${DatabaseCreator.id} == ${word.id}
    // ''';
    final sql = '''UPDATE ${DatabaseCreator.wordTable}
    SET ${DatabaseCreator.isDeleted} = 1
    WHERE ${DatabaseCreator.id} = ?
    ''';
    List<dynamic> params = [word.id];
    final result = await db.rawUpdate(sql, params);

    DatabaseCreator.databaseLog('Delete word', sql, null, result, params);

  }

  static Future<Word> updateWord(Word word) async {
    // final sql = '''UPDATE ${DatabaseCreator.wordTable}
    // SET ${DatabaseCreator.word} = "${word.word}"
    // WHERE ${DatabaseCreator.id} == ${word.id}
    // ''';

    final sql = '''UPDATE ${DatabaseCreator.wordTable}
    SET ${DatabaseCreator.word} = ?
    WHERE ${DatabaseCreator.id} = ?
    ''';

    List<dynamic> params = [word.word, word.id];
    final result = await db.rawUpdate(sql, params);

    DatabaseCreator.databaseLog('Update word', sql, null, result, params);
  }

  static Future<int> wordCount() async {
    final data = await db.rawQuery
      ('''SELECT COUNT(*) FROM ${DatabaseCreator.wordTable}''');

    int count = data[0].values.elementAt(0);
    int idForNewItem = count++;
    return idForNewItem;
  }

}