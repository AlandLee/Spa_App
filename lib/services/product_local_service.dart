import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:spa_app/services/db_helper.dart';

class ProductLocalService {
  static Future<Database> get _database async {
    return await DatabaseHelper.database;
  }

  static Future<int> addProduct(Map<String, String> product) async {
    final db = await _database;
    return await db.insert('products', product);
  }

  static Future<int> updateProduct(int id, Map<String, String> product) async {
    final db = await _database;
    return await db.update(
      'products',
      product,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> deleteProduct(int id) async {
    final db = await _database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, String>>> getAllProducts() async {
  final db = await _database;
  final result = await db.query('products');

  // Trả về list rỗng thay vì throw
  return result.map((e) {
    return e.map((k, v) => MapEntry(k, v?.toString() ?? ''));
  }).toList();
}

  static Future<List<Map<String, String>>> getProductsByBranch(String branchId) async {
  final db = await _database;
  final result = await db.query(
    'products',
    where: 'branch_id = ?',
    whereArgs: [branchId],
  );
  return result.map((e) => e.map((k, v) => MapEntry(k, v?.toString() ?? ''))).toList();
}

  static Future<String> generateNextProductCode(String type) async {
  final db = await _database;

  // Xác định tiền tố mã dựa vào loại
  final prefix = type == 'Dịch vụ' ? 'DV' : 'HH';

  // Lấy mã lớn nhất với tiền tố tương ứng
  final result = await db.rawQuery(
    "SELECT code FROM products WHERE code LIKE '$prefix%' ORDER BY code DESC LIMIT 1",
  );

  // Nếu chưa có mã nào, bắt đầu từ 001
  if (result.isEmpty || result.first['code'] == null) {
    return '${prefix}001';
  }

  final latestCode = result.first['code'] as String;
  final numberPart = int.tryParse(latestCode.replaceAll(prefix, '')) ?? 0;
  final nextNumber = numberPart + 1;

  return '${prefix}${nextNumber.toString().padLeft(3, '0')}';
}


}
