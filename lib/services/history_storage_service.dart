import 'dart:convert';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/search_history_item.dart';
import '../models/search_result_item.dart';

class HistoryStorageService {
  static const _dbName = 'question_search.db';
  static const _dbVersion = 1;
  static const _table = 'search_history';
  static const _historyLimit = 20;

  Database? _db;

  Future<Database> _database() async {
    if (_db != null) {
      return _db!;
    }

    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, _dbName);
    _db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_table (
            id TEXT PRIMARY KEY,
            created_at INTEGER NOT NULL,
            ocr_text TEXT NOT NULL,
            results_json TEXT NOT NULL
          )
        ''');
      },
    );

    return _db!;
  }

  Future<void> insertHistory(SearchHistoryItem item) async {
    final db = await _database();
    await db.insert(
      _table,
      {
        'id': item.id,
        'created_at': item.createdAt.millisecondsSinceEpoch,
        'ocr_text': item.ocrText,
        'results_json': jsonEncode(item.results.map((result) => result.toJson()).toList()),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await _pruneOldRows(db);
  }

  Future<List<SearchHistoryItem>> loadHistory({int limit = _historyLimit}) async {
    final db = await _database();
    final rows = await db.query(
      _table,
      orderBy: 'created_at DESC',
      limit: limit,
    );

    final items = <SearchHistoryItem>[];
    for (final row in rows) {
      try {
        final payload = jsonDecode((row['results_json'] ?? '[]').toString());
        final results = <SearchResultItem>[];
        if (payload is List) {
          for (final result in payload) {
            if (result is Map) {
              results.add(SearchResultItem.fromJson(Map<String, dynamic>.from(result)));
            }
          }
        }

        items.add(
          SearchHistoryItem(
            id: (row['id'] ?? '').toString(),
            createdAt: DateTime.fromMillisecondsSinceEpoch((row['created_at'] as int?) ?? 0),
            ocrText: (row['ocr_text'] ?? '').toString(),
            results: results,
          ),
        );
      } catch (_) {
        // Skip malformed row and continue loading valid history items.
      }
    }

    return items;
  }

  Future<void> _pruneOldRows(Database db) async {
    await db.rawDelete('''
      DELETE FROM $_table
      WHERE id IN (
        SELECT id FROM $_table
        ORDER BY created_at DESC
        LIMIT -1 OFFSET $_historyLimit
      )
    ''');
  }

  Future<void> clearHistory() async {
    final db = await _database();
    await db.delete(_table);
  }
}
