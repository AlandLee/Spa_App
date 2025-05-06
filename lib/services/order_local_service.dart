import 'dart:convert';
import 'package:spa_app/services/db_helper.dart';

class OrderLocalService {
  static const String table = 'purchase_orders';  // Sửa ở đây

  static Future<void> insertOrderWithProducts(
    Map<String, dynamic> order, List<Map<String, String>> products) async {
  final db = await DatabaseHelper.database;

  await db.transaction((txn) async {
    final orderId = await txn.insert('purchase_orders', {
      ...order,
    });

    for (final product in products) {
      await txn.insert('purchase_order_products', {
        'order_id': orderId,
        ...product,
      });
    }
  });
}


  static Future<void> updateOrder(int id, Map<String, dynamic> order) async {
    final db = await DatabaseHelper.database;
    await db.update(
      table,
      {
        ...order,
        'products': jsonEncode(order['products']),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteOrder(int id) async {
    final db = await DatabaseHelper.database;
    await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getAllOrders() async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> result = await db.query(table);
    return result.map((order) {
      final products = jsonDecode(order['products'] ?? '[]');
      return {
        ...order,
        'products': List<Map<String, dynamic>>.from(products),
      };
    }).toList();
  }

  static Future<List<Map<String, dynamic>>> getOrdersByBranchId(String branchId) async {
  final db = await DatabaseHelper.database;
  
  // Truy vấn bảng purchase_orders và kết hợp với bảng purchase_order_products
  final List<Map<String, dynamic>> orders = await db.rawQuery('''
    SELECT po.*, pop.*
    FROM purchase_orders po
    LEFT JOIN purchase_order_products pop ON po.id = pop.order_id
    WHERE po.branch_id = ?
  ''', [branchId]);

  // Bước tiếp theo là nhóm các sản phẩm theo order_id
  Map<int, Map<String, dynamic>> ordersWithProducts = {};

  for (var order in orders) {
    int orderId = order['id'];
    
    // Nếu chưa có orderId trong ordersWithProducts, tạo mới
    if (!ordersWithProducts.containsKey(orderId)) {
      ordersWithProducts[orderId] = {
        'id': order['id'],
        'branch_id': order['branch_id'],
        'order_date': order['order_date'],
        'completion_date': order['completion_date'],
        'po_number': order['po_number'],
        'voucher_number': order['voucher_number'],
        'branch': order['branch'],
        'status': order['status'],
        'total_amount': order['total_amount'],
        'note': order['note'],
        'products': [],
      };
    }

    // Thêm sản phẩm vào danh sách products của đơn hàng
    ordersWithProducts[orderId]?['products'].add({
      'code': order['code'],
      'name': order['name'],
      'unit': order['unit'],
      'supplier': order['supplier'],
      'quantity': order['quantity'],
      'unit_price': order['unit_price'],
      'total_price': order['total_price'],
    });
  }

  // Trả về danh sách các đơn hàng có sản phẩm đi kèm
  return ordersWithProducts.values.toList();
}


}

