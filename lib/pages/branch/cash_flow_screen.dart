import 'package:flutter/material.dart';

class CashFlowScreen extends StatelessWidget {
  final Map<String, dynamic> branch;
  final Map<String, dynamic>? userData;

  const CashFlowScreen({
    Key? key,
    required this.branch,
    required this.userData,
  }) : super(key: key);

  @override
Widget build(BuildContext context) {
  final screenSize = MediaQuery.of(context).size;
  return Scaffold(
    body: Stack(
      children: [
        Container(
          color: const Color(0xFFE8F9FB),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: SizedBox(
            width: screenSize.width,
            height: screenSize.height,
            child: Image.asset(
              'images/bg_spa_none.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20),
          child: SizedBox(
            width: 300,
            child: TextField(
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Chi nhánh',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 60), // đẩy bảng xuống dưới một chút
          child: _buildCashFlowTable(context),
        ),
      ],
    ),
  );
}


Widget _buildCashFlowTable(BuildContext context) {
  final List<Map<String, String>> cashFlows = [
    {
      'date': '01/01/2025',
      'branch': 'Chi nhánh 1',
      'type': 'Thu',
      'income': '10,000,000',
      'expense': '',
      'payment_type': 'Chuyển khoản',
      'note': 'Tiền bán hàng',
    },
    {
      'date': '02/01/2025',
      'branch': 'Chi nhánh 2',
      'type': 'Chi',
      'income': '',
      'expense': '5,000,000',
      'payment_type': 'Tiền mặt',
      'note': 'Mua nguyên liệu',
    },
    {
      'date': '03/01/2025',
      'branch': 'Chi nhánh 1',
      'type': 'Thu',
      'income': '15,000,000',
      'expense': '',
      'payment_type': 'Chuyển khoản',
      'note': 'Tiền thanh toán khách hàng',
    },
  ];

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          columnWidths: const {
            0: FlexColumnWidth(2), // Ngày
            1: FlexColumnWidth(3), // Chi nhánh
            2: FlexColumnWidth(2), // Loại
            3: FlexColumnWidth(2), // Thu
            4: FlexColumnWidth(2), // Chi
            5: FlexColumnWidth(3), // Kiểu thanh toán
            6: FlexColumnWidth(3), // Ghi chú
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
                _buildTableHeaderCell('Ngày'),
                _buildTableHeaderCell('Chi nhánh'),
                _buildTableHeaderCell('Loại'),
                _buildTableHeaderCell('Thu'),
                _buildTableHeaderCell('Chi'),
                _buildTableHeaderCell('Kiểu thanh toán'),
                _buildTableHeaderCell('Ghi chú'),
              ],
            ),
          ],
        ),
        ...cashFlows.map((cashFlow) {
          return GestureDetector(
            onTap: () {
              // Handle onTap event if needed
            },
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
                4: FlexColumnWidth(2),
                5: FlexColumnWidth(3),
                6: FlexColumnWidth(3),
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
                    _buildTableCell(cashFlow['date']!),
                    _buildTableCell(cashFlow['branch']!),
                    _buildTableCell(cashFlow['type']!),
                    _buildTableCell(cashFlow['income']!),
                    _buildTableCell(cashFlow['expense']!),
                    _buildTableCell(cashFlow['payment_type']!),
                    _buildTableCell(cashFlow['note']!),
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
