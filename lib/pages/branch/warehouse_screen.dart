import 'package:flutter/material.dart';

class WarehouseScreen extends StatelessWidget {
  final Map<String, dynamic> branch;
  final Map<String, dynamic>? userData;

  const WarehouseScreen({
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
                        hintText: 'Chi nhánh',
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
                        hintText: 'Mã hàng hoá, dịch vụ',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          
        ),
        Padding(
          padding: const EdgeInsets.only(top: 110), // đẩy bảng xuống dưới một chút
          child: _buildStockTable(context),
        ),
      ],
    ),
  );
}

Widget _buildStockTable(BuildContext context) {
  final List<Map<String, String>> stocks = [
    {
      'code': 'SP001',
      'name': 'Sản phẩm A',
      'unit': 'Cái',
      'type': 'Hàng hóa',
      'size': 'M',
      'brand': 'BrandX',
      'begin_price': '50,000',
      'imported': '100',
      'exported': '30',
      'theory_end': '70',
      'actual_end': '68',
      'diff': '-2',
      'min_stock': '50',
    },
    {
      'code': 'SP002',
      'name': 'Sản phẩm B',
      'unit': 'Hộp',
      'type': 'Nguyên liệu',
      'size': 'L',
      'brand': 'BrandY',
      'begin_price': '75,000',
      'imported': '50',
      'exported': '20',
      'theory_end': '30',
      'actual_end': '30',
      'diff': '0',
      'min_stock': '20',
    },
    {
      'code': 'SP003',
      'name': 'Sản phẩm C',
      'unit': 'Thùng',
      'type': 'Hàng hóa',
      'size': 'XL',
      'brand': 'BrandZ',
      'begin_price': '120,000',
      'imported': '80',
      'exported': '70',
      'theory_end': '10',
      'actual_end': '8',
      'diff': '-2',
      'min_stock': '15',
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
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(3),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(2),
            4: FlexColumnWidth(2),
            5: FlexColumnWidth(2),
            6: FlexColumnWidth(2),
            7: FlexColumnWidth(2),
            8: FlexColumnWidth(2),
            9: FlexColumnWidth(2),
            10: FlexColumnWidth(2),
            11: FlexColumnWidth(2),
            12: FlexColumnWidth(2), // Định mức tồn
          },
          children: [
            TableRow(
              decoration: const BoxDecoration(
                color: Color(0xFFCCE5FF),
              ),
              children: [
                _buildTableHeaderCell('Mã'),
                _buildTableHeaderCell('Tên'),
                _buildTableHeaderCell('ĐVT'),
                _buildTableHeaderCell('Loại'),
                _buildTableHeaderCell('Size'),
                _buildTableHeaderCell('Brand'),
                _buildTableHeaderCell('Giá tồn đầu'),
                _buildTableHeaderCell('Nhập'),
                _buildTableHeaderCell('Xuất'),
                _buildTableHeaderCell('Tồn LT'),
                _buildTableHeaderCell('Tồn TT'),
                _buildTableHeaderCell('Lệch tồn'),
                _buildTableHeaderCell('Định mức tồn'),
              ],
            ),
          ],
        ),
        ...stocks.map((item) {
          return Table(
            border: TableBorder.all(
              color: Colors.black26,
              width: 0.5,
            ),
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(3),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(2),
              4: FlexColumnWidth(2),
              5: FlexColumnWidth(2),
              6: FlexColumnWidth(2),
              7: FlexColumnWidth(2),
              8: FlexColumnWidth(2),
              9: FlexColumnWidth(2),
              10: FlexColumnWidth(2),
              11: FlexColumnWidth(2),
              12: FlexColumnWidth(2),
            },
            children: [
              TableRow(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                children: [
                  _buildTableCell(item['code']!),
                  _buildTableCell(item['name']!),
                  _buildTableCell(item['unit']!),
                  _buildTableCell(item['type']!),
                  _buildTableCell(item['size']!),
                  _buildTableCell(item['brand']!),
                  _buildTableCell(item['begin_price']!),
                  _buildTableCell(item['imported']!),
                  _buildTableCell(item['exported']!),
                  _buildTableCell(item['theory_end']!),
                  _buildTableCell(item['actual_end']!),
                  _buildTableCell(item['diff']!),
                  _buildTableCell(item['min_stock']!),
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
