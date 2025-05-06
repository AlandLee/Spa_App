import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    databaseFactory = databaseFactoryFfi;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Tạo bảng 'products'
        await db.execute('''
          CREATE TABLE IF NOT EXISTS products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            branch_id TEXT,
            code TEXT,
            name TEXT,
            unit TEXT,
            type TEXT,
            size TEXT,
            brand TEXT,
            unit_price TEXT,
            inventory TEXT
          )
        ''');

        // Tạo bảng 'entities'
        await db.execute('''
          CREATE TABLE IF NOT EXISTS entities (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            uid TEXT,
            branch_id TEXT,
            type TEXT,
            code TEXT,
            phone TEXT,
            email TEXT,
            name TEXT,
            gender TEXT,
            cccd TEXT,
            hometown TEXT,
            dob TEXT,
            start_date TEXT,
            end_date TEXT,
            position TEXT
          )
        ''');

        // Tạo bảng 'purchase_orders'
        await db.execute('''
          CREATE TABLE IF NOT EXISTS purchase_orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            branch_id TEXT,
            order_date TEXT,
            completion_date TEXT,
            po_number TEXT,
            voucher_number TEXT,
            branch TEXT,
            status TEXT,
            total_amount TEXT,
            note TEXT
          )
        ''');

        // Tạo bảng 'purchase_order_products'
        await db.execute('''
          CREATE TABLE IF NOT EXISTS purchase_order_products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            order_id INTEGER,
            code TEXT,
            name TEXT,
            unit TEXT,
            supplier TEXT,
            quantity TEXT,
            unit_price TEXT,
            total_price TEXT,
            FOREIGN KEY (order_id) REFERENCES purchase_orders(id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }
}
