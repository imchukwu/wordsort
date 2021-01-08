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
    final sql = '''SELECT * FROM ${DatabaseCreator.wordTable}
    WHERE ${DatabaseCreator.id} == $id''';
    final data = await db.rawQuery(sql);

    final word = Word.fromJson(data[0]);
    return word;
  }

  static Future<Word> addWord(Word word) async {
    final sql = '''INSERT * FROM ${DatabaseCreator.wordTable}
    (
      ${DatabaseCreator.id},
      ${DatabaseCreator.word},
      ${DatabaseCreator.description},
      ${DatabaseCreator.level},
      ${DatabaseCreator.isDeleted}
    )
    VALUES
    (
      ${word.id},
      "${word.word}",
      "${word.description}",
      ${word.level},
      ${word.isDeleted ? 1 : 0}
    )''';

    final result = await db.rawInsert(sql);
    DatabaseCreator.databaseLog('Add Word', sql, null, result);
  }

  static Future<Word> deleteWord(Word word) async {
    final sql = '''UPDATE * FROM ${DatabaseCreator.wordTable}
    SET ${DatabaseCreator.isDeleted} = 1
    WHERE ${DatabaseCreator.id} == ${word.id}
    ''';

    final result = await db.rawUpdate(sql);

    DatabaseCreator.databaseLog('Delete word', sql, null, result);
  }

  static Future<Word> updateWord(Word word) async {
    final sql = '''UPDATE ${DatabaseCreator.wordTable}
    SET ${DatabaseCreator.word} = "${word.word}"
    WHERE ${DatabaseCreator.id} == ${word.id}
    ''';

    final result = await db.rawUpdate(sql);

    DatabaseCreator.databaseLog('Update word', sql, null, result);
  }

  static Future<int> wordCount() async {
    final data = await db.rawQuery
      ('''SELECT COUNT(*) FROM ${DatabaseCreator.wordTable}''');

    int count = data[0].values.elementAt(0);
    return count;
  }

}