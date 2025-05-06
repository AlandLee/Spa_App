import 'package:flutter/material.dart';

class SupplierDebtScreen extends StatelessWidget {
  final Map<String, dynamic> branch;
  final Map<String, dynamic>? userData;

  const SupplierDebtScreen({
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
          padding: const EdgeInsets.only(top: 20, left: 10),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 300,
                    child: TextField(
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Từ ngày',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16), // Khoảng cách giữa 2 ô
                  SizedBox(
                    width: 300,
                    child: TextField(
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Đến ngày',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16), 
              Row(
                children: [
                  SizedBox(
                    width: 300,
                    child: TextField(
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Mã nhà cung cấp',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16), // Khoảng cách giữa 2 ô
                  SizedBox(
                    width: 300,
                  ),
                ],
              ),
            ]),
          
        ),
        Padding(
          padding: const EdgeInsets.only(top: 110), // đẩy bảng xuống dưới một chút
          child: _buildDebtTable(context),
        ),
      ],
    ),
  );
}

Widget _buildDebtTable(BuildContext context) {
  final List<Map<String, String>> debts = [
    {
      'code': 'CN001',
      'name': 'Công ty A',
      'begin_debt': '10,000,000',
      'incurred': '5,000,000',
      'payment': '3,000,000',
      'end_debt': '12,000,000',
    },
    {
      'code': 'CN002',
      'name': 'Công ty B',
      'begin_debt': '8,000,000',
      'incurred': '2,000,000',
      'payment': '4,000,000',
      'end_debt': '6,000,000',
    },
    {
      'code': 'CN003',
      'name': 'Cửa hàng C',
      'begin_debt': '15,000,000',
      'incurred': '0',
      'payment': '5,000,000',
      'end_debt': '10,000,000',
    },
    {
      'code': 'CN004',
      'name': 'Khách lẻ D',
      'begin_debt': '2,000,000',
      'incurred': '1,000,000',
      'payment': '500,000',
      'end_debt': '2,500,000',
    },
  ];

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          border: TableBorder.all(
            color: Colors.black26,
            width: 1,
            borderRadius: BorderRadius.circular(4),
          ),
          columnWidths: const {
            0: FlexColumnWidth(2), // Mã
            1: FlexColumnWidth(3), // Tên
            2: FlexColumnWidth(3), // Nợ đầu kỳ
            3: FlexColumnWidth(3), // Phát sinh
            4: FlexColumnWidth(3), // Thanh toán
            5: FlexColumnWidth(3), // Nợ cuối kỳ
          },
          children: [
            TableRow(
              decoration: const BoxDecoration(
                color: Color(0xFFCCE5FF),
              ),
              children: [
                _buildTableHeaderCell('Mã'),
                _buildTableHeaderCell('Tên'),
                _buildTableHeaderCell('Nợ đầu kỳ'),
                _buildTableHeaderCell('Phát sinh trong kỳ'),
                _buildTableHeaderCell('Thanh toán trong kỳ'),
                _buildTableHeaderCell('Nợ cuối kỳ'),
              ],
            ),
          ],
        ),
        ...debts.map((item) {
          return Table(
            border: TableBorder.all(
              color: Colors.black26,
              width: 0.5,
            ),
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(3),
              2: FlexColumnWidth(3),
              3: FlexColumnWidth(3),
              4: FlexColumnWidth(3),
              5: FlexColumnWidth(3),
            },
            children: [
              TableRow(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                children: [
                  _buildTableCell(item['code']!),
                  _buildTableCell(item['name']!),
                  _buildTableCell(item['begin_debt']!),
                  _buildTableCell(item['incurred']!),
                  _buildTableCell(item['payment']!),
                  _buildTableCell(item['end_debt']!),
                ],
              ),
            ],
          );
        }).toList(),
      ],
    ),
  );
}



Widget _buildTableHeaderCell(String title) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}

Widget _buildTableCell(String content) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(content),
  );
}

}
