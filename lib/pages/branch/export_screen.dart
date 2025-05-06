import 'package:flutter/material.dart';
import 'package:spa_app/pages/branch/export_dialog.dart';

class ExportScreen extends StatelessWidget {
  final Map<String, dynamic> branch;
  final Map<String, dynamic>? userData;

  const ExportScreen({
    Key? key,
    required this.branch,
    required this.userData,
  }) : super(key: key);

  @override
Widget build(BuildContext context) {
  final screenSize = MediaQuery.of(context).size;
  return Scaffold(

    // === Nút Thêm ===
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                insetPadding: const EdgeInsets.all(24),
                                backgroundColor: Colors.transparent,
                                child: UnconstrainedBox(
                                  constrainedAxis: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: MediaQuery.of(context).size.width * 2 / 3,
                                      maxHeight: MediaQuery.of(context).size.height * 0.8, // 🧠 KHÔNG thể thiếu dòng này
                                    ),
                                    child: ExportFormDialog(
                                      branch: branch,
                                      userData: userData,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
      },
      backgroundColor: Colors.blueAccent,
      child: const Icon(Icons.add),
    ),

    // === Nền và nội dung chính nếu có thể bổ sung sau ===
    body: Stack(
      children: [
        Container(
          color: const Color(0xFFE8F9FB), // Nền
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: screenSize.width,
            height: screenSize.height,
            child: Image.asset(
              'images/bg_spa_none.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        // Nội dung khác nếu cần
        Padding(
          padding: const EdgeInsets.only(top: 20), // đẩy bảng xuống dưới appbar
          child: _buildOrderTable(context),
        ),
      ],
    ),
  );
}

Widget _buildOrderTable(BuildContext context) {
  final List<Map<String, String>> orders = [
    {
      'orderDate': '2025-04-10',
      'completionDate': '2025-04-10',
      'poNumber': 'PO001',
      'noteNum': '1',
      'branch': 'Cầu Giấy',
      'ncc': 'Cầu Giấy',
      'total': '100',
      'pay': '100',
    },
    {
      'orderDate': '2025-04-10',
      'completionDate': '2025-04-10',
      'poNumber': 'PO001',
      'noteNum': '1',
      'branch': 'Cầu Giấy',
      'ncc': 'Cầu Giấy',
      'total': '100',
      'pay': '100',
    },
    {
      'orderDate': '2025-04-10',
      'completionDate': '2025-04-10',
      'poNumber': 'PO001',
      'noteNum': '1',
      'branch': 'Cầu Giấy',
      'ncc': 'Cầu Giấy',
      'total': '100',
      'pay': '100',
    },
  ];

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(2),
            4: FlexColumnWidth(2),
            5: FlexColumnWidth(2),
            6: FlexColumnWidth(2),
            7: FlexColumnWidth(2),
          },
          border: TableBorder.all(
            color: Colors.black26,
            width: 1,
            borderRadius: BorderRadius.circular(4),
          ),
          children: [
            TableRow(
              decoration: const BoxDecoration(
                color: Color(0xFFCCE5FF),
              ),
              children: [
                _buildTableHeaderCell('Ngày đặt hàng'),
                _buildTableHeaderCell('Ngày giao hàng'),
                _buildTableHeaderCell('Số PO'),
                _buildTableHeaderCell('Số phiếu'),
                _buildTableHeaderCell('Chi nhánh'),
                _buildTableHeaderCell('NCC'),
                _buildTableHeaderCell('Tổng tiền'),
                _buildTableHeaderCell('Thanh toán'),
              ],
            ),
          ],
        ),
        ...orders.map((order) {
          return GestureDetector(
            onTap: () {
              showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                insetPadding: const EdgeInsets.all(24),
                                backgroundColor: Colors.transparent,
                                child: UnconstrainedBox(
                                  constrainedAxis: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: MediaQuery.of(context).size.width * 2 / 3,
                                      maxHeight: MediaQuery.of(context).size.height * 0.8, // 🧠 KHÔNG thể thiếu dòng này
                                    ),
                                    child: ExportFormDialog(
                                      branch: branch,
                                      userData: userData,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
            },
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
                4: FlexColumnWidth(2),
                5: FlexColumnWidth(2),
                6: FlexColumnWidth(2),
                7: FlexColumnWidth(2),
              },
             border: TableBorder.all(
                color: Colors.black26,
                width: 0.5,
              ),
              children: [
                TableRow(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  children: [
                    _buildTableCell(order['orderDate']!),
                    _buildTableCell(order['completionDate']!),
                    _buildTableCell(order['poNumber']!),
                    _buildTableCell(order['noteNum']!),
                    _buildTableCell(order['branch']!),
                    _buildTableCell(order['ncc']!),
                    _buildTableCell(order['total']!),
                    _buildTableCell(order['pay']!),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ],
    ),
  );
}


Widget _buildTableHeaderCell(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.black87,
      ),
    ),
  );
}


Widget _buildTableCell(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: Colors.black87,
      ),
    ),
  );
}
}
