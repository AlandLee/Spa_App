import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:spa_app/services/db_helper.dart';

class EntityLocalService {
  static Future<Database> get _database async {
    // Thay vì gọi _initDB ở đây, chúng ta sẽ lấy database từ DatabaseHelper
    return await DatabaseHelper.database;
  }

 /// Thêm entity mới
static Future<int> addEntity(Map<String, dynamic> entity) async {
  final db = await _database;

  // Chuẩn hóa type nếu là tiếng Việt
  entity['type'] = _normalizeType(entity['type']);

  // Encode position nếu là List<String>
  if (entity['position'] is List<String>) {
    entity['position'] = jsonEncode(entity['position']);
  }

  return await db.insert('entities', entity);
}

/// Sửa entity theo id
static Future<int> updateEntity(int id, Map<String, dynamic> entity) async {
  final db = await _database;

  // Chuẩn hóa type nếu là tiếng Việt
  entity['type'] = _normalizeType(entity['type']);

  // Encode position nếu là List<String>
  if (entity['position'] is List<String>) {
    entity['position'] = jsonEncode(entity['position']);
  }

  return await db.update(
    'entities',
    entity,
    where: 'id = ?',
    whereArgs: [id],
  );
}

/// Hàm chuẩn hóa type từ tiếng Việt sang mã chuẩn
static String _normalizeType(dynamic value) {
  final Map<String, String> typeMap = {
    'Khách hàng': 'customer',
    'Học viên': 'student',
    'Giáo viên': 'teacher',
    'Nhân viên': 'staff',
  };

  if (value is String) {
    return typeMap[value] ?? value.toLowerCase().trim();
  }
  return '';
}


  /// Xoá entity theo id
  static Future<int> deleteEntity(int id) async {
    final db = await _database;
    return await db.delete(
      'entities',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Lấy tất cả entity và decode lại position
  static Future<List<Map<String, dynamic>>> getAllEntities() async {
    final db = await _database;
    final result = await db.query('entities');

    // Giải mã position từ JSON
    return result.map((e) {
      if (e['position'] != null) {
        try {
          e['position'] = List<String>.from(jsonDecode(e['position'] as String));
        } catch (_) {
          e['position'] = [];
        }
      }
      return e;
    }).toList();
  }

  static Future<List<Map<String, dynamic>>> getEntitiesByBranch(String branchId) async {
  final db = await _database;

  final result = await db.query(
    'entities',
    where: 'branch_id = ?',
    whereArgs: [branchId],
  );

  return result.map((e) {
    // Clone the map to allow modification
    var clonedEntity = Map<String, dynamic>.from(e);

    // Chuẩn hóa type từ tiếng Anh về tiếng Việt
    if (clonedEntity['type'] != null) {
      clonedEntity['type'] = _normalizeTypeBack(clonedEntity['type']);
    }

    // Chuẩn hóa position nếu cần (List<String>)
    if (clonedEntity['position'] != null) {
      try {
        clonedEntity['position'] = List<String>.from(jsonDecode(clonedEntity['position'] as String));
      } catch (_) {
        clonedEntity['position'] = <String>[];
      }
    } else {
      clonedEntity['position'] = <String>[];
    }

    return clonedEntity;
  }).toList();
}

/// Hàm chuẩn hóa type từ tiếng Anh sang tiếng Việt
static String _normalizeTypeBack(dynamic value) {
  final Map<String, String> typeMapBack = {
    'customer': 'Khách hàng',
    'student': 'Học viên',
    'teacher': 'Giáo viên',
    'staff': 'Nhân viên',
  };

  if (value is String) {
    return typeMapBack[value.toLowerCase()] ?? value; // Nếu không có thì giữ nguyên
  }
  return '';
}


static Future<String> generateEntityCode(String type, {String? branchId}) async {
  final db = await _database;

  String prefix;
  switch (type) {
    case 'customer': prefix = 'KH'; break;
    case 'student':  prefix = 'HV'; break;
    case 'teacher':  prefix = 'GV'; break;
    case 'staff':    prefix = 'NV'; break;
    default:
      throw Exception('Loại đối tượng không hợp lệ');
  }

  String where = 'type = ?';
  List<dynamic> args = [type];

  if (type != 'customer' && branchId != null) {
    where += ' AND branch_id = ?';
    args.add(branchId);
  }

  final result = await db.query(
    'entities',
    columns: ['code'],
    where: where,
    whereArgs: args,
    orderBy: 'id DESC',
    limit: 1,
  );

  int nextNumber = 1;

  if (result.isNotEmpty && result.first['code'] != null) {
    final lastCode = result.first['code'] as String;
    final numberPart = int.tryParse(lastCode.substring(2)) ?? 0;
    nextNumber = numberPart + 1;
  }

  final newCode = '$prefix${nextNumber.toString().padLeft(3, '0')}';
  return newCode;
}


}

