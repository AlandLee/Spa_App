import 'package:flutter/material.dart';

class StructureTypeScreen extends StatelessWidget {
  final Map<String, dynamic> branch;
  final Map<String, dynamic>? userData;

  const StructureTypeScreen({
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
          padding: const EdgeInsets.only(top: 20, left: 6, right: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bảng khách hàng bên trái
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Cơ cấu xếp hạng khách hàng',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildCustomerTable(context),
                  ],
                ),
              ),

              const SizedBox(width: 10), // Khoảng cách giữa hai bảng

              // Bảng học viên bên phải
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Cơ cấu xếp loại học viên',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildStudentTable(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}




Widget _buildCustomerTable(BuildContext context) {
  final List<Map<String, String>> customers = [
    {
      'rank': 'vàng',
      'revenue_from': '1000000',
      'revenue_to': '5000000',
    },
    {
      'rank': 'vàng',
      'revenue_from': '1000000',
      'revenue_to': '5000000',
    },
    {
      'rank': 'vàng',
      'revenue_from': '1000000',
      'revenue_to': '5000000',
    },
  ];

  return Padding(
    padding: const EdgeInsets.all(0.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
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
                _buildTableHeaderCell('Hạng'),
                _buildTableHeaderCell('Doanh thu từ'),
                _buildTableHeaderCell('Doanh thu đến'),
              ],
            ),
          ],
        ),
        ...customers.map((customer) {
          return GestureDetector(
            onTap: () {
              //
            },
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
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
                    _buildTableCell(customer['rank']!),
                    _buildTableCell(customer['revenue_from']!),
                    _buildTableCell(customer['revenue_to']!),
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

Widget _buildStudentTable(BuildContext context) {
  final List<Map<String, String>> students = [
    {
      'rank': 'Giỏi',
      'total': '15',
      'point': '10',
    },
    {
      'rank': 'Giỏi',
      'total': '15',
      'point': '10',
    },
    {
      'rank': 'Giỏi',
      'total': '15',
      'point': '10',
    },
  ];

  return Padding(
    padding: const EdgeInsets.all(0.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
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
                _buildTableHeaderCell('Xếp loại học viên'),
                _buildTableHeaderCell('Tổng số buổi học'),
                _buildTableHeaderCell('Điểm'),
              ],
            ),
          ],
        ),
        ...students.map((student) {
          return GestureDetector(
            onTap: () {
              //
            },
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
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
                    _buildTableCell(student['rank']!),
                    _buildTableCell(student['total']!),
                    _buildTableCell(student['point']!),
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
