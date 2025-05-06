import 'package:flutter/material.dart';
import 'package:spa_app/widgets/diagonal_line_painter.dart';


class IncomeStructureScreen extends StatelessWidget {
  final Map<String, dynamic> branch;
  final Map<String, dynamic>? userData;

  const IncomeStructureScreen({
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
        SingleChildScrollView( // Bọc phần này để có thể cuộn
          padding: const EdgeInsets.only(top: 20, left: 6, right: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hoa hồng',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildCommissionTable(context),

              const SizedBox(height: 20), // Khoảng cách giữa hai bảng

              const Text(
                'Lương',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildSalaryTable(context),

              const SizedBox(height: 20), // Khoảng cách giữa hai bảng
            ],
          ),
        ),
      ],
    ),
  );
}


Widget _buildCommissionTable(BuildContext context) {
  final List<Map<String, String>> commissions = [
    {
      'branch': 'Chi nhánh A',
      'hh0': '400000000',
      'hh1': '550000000',
      'hh2': '750000000',
      'hh3': '850000000',
    },
    {
      'branch': 'Chi nhánh B',
      'hh0': '300000000',
      'hh1': '400000000',
      'hh2': '500000000',
      'hh3': '700000000',
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
            3: FlexColumnWidth(2),
            4: FlexColumnWidth(2),
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
                _buildDiagonalHeaderCell('%HH\n%CN'),
                _buildTableHeaderCell('0.00%'),
                _buildTableHeaderCell('1.00%'),
                _buildTableHeaderCell('1.50%'),
                _buildTableHeaderCell('2.00%'),
              ],
            ),
          ],
        ),
        ...commissions.map((item) {
          return Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(2),
              4: FlexColumnWidth(2),
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
                  _buildTableCell(item['branch']!),
                  _buildTableCell(item['hh0']!),
                  _buildTableCell(item['hh1']!),
                  _buildTableCell(item['hh2']!),
                  _buildTableCell(item['hh3']!),
                ],
              ),
            ],
          );
        }).toList(),
      ],
    ),
  );
}

Widget _buildSalaryTable(BuildContext context) {
  final List<Map<String, String>> salaryData = [
    {
      'position': 'Mẫu 1',
      'base_salary': '',
      'commission': '',
      'team_target': '',
      'excellent': '',
      'meal': '',
      'parking': '',
      'fuel': '',
      'attendance': '',
      'birthday': '',
      'wedding': '',
      'feedback': '',
    },
    {
      'position': 'Mẫu 1',
      'base_salary': '',
      'commission': '',
      'team_target': '',
      'excellent': '',
      'meal': '',
      'parking': '',
      'fuel': '',
      'attendance': '',
      'birthday': '',
      'wedding': '',
      'feedback': '',
    },
    {
      'position': 'Mẫu 1',
      'base_salary': '',
      'commission': '',
      'team_target': '',
      'excellent': '',
      'meal': '',
      'parking': '',
      'fuel': '',
      'attendance': '',
      'birthday': '',
      'wedding': '',
      'feedback': '',
    },
    {
      'position': 'Mẫu 1',
      'base_salary': '',
      'commission': '',
      'team_target': '',
      'excellent': '',
      'meal': '',
      'parking': '',
      'fuel': '',
      'attendance': '',
      'birthday': '',
      'wedding': '',
      'feedback': '',
    },
  ];

  final headers = [
    'Chức vụ',
    'Lương cơ bản',
    'Commission',
    'Team vượt Target',
    'NV xuất sắc',
    'Ăn',
    'Gửi xe',
    'Xăng xe',
    'Chuyên cần',
    'Sinh nhật',
    'Cưới',
    'Feedback KH',
  ];

  return Padding(
    padding: const EdgeInsets.all(0.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          columnWidths: {
            for (int i = 0; i < headers.length; i++)
              i: FlexColumnWidth(1), // Cái này giúp cột tự động điều chỉnh
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
              children: headers
                  .map((header) => _buildTableHeaderCell(header))
                  .toList(),
            ),
          ],
        ),
        ...salaryData.map((salary) {
          return GestureDetector(
            onTap: () {
              // Handle tap action
            },
            child: Table(
              columnWidths: {
                for (int i = 0; i < headers.length; i++)
                  i: FlexColumnWidth(1), // Tự động thu hẹp
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
                    _buildTableCell(salary['position']!),
                    _buildTableCell(salary['base_salary']!),
                    _buildTableCell(salary['commission']!),
                    _buildTableCell(salary['team_target']!),
                    _buildTableCell(salary['excellent']!),
                    _buildTableCell(salary['meal']!),
                    _buildTableCell(salary['parking']!),
                    _buildTableCell(salary['fuel']!),
                    _buildTableCell(salary['attendance']!),
                    _buildTableCell(salary['birthday']!),
                    _buildTableCell(salary['wedding']!),
                    _buildTableCell(salary['feedback']!),
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

Widget _buildDiagonalHeaderCell(String text) {
  return Container(
    height: 50,
    child: CustomPaint(
      painter: DiagonalLinePainter(),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
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
