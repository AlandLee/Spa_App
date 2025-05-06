import 'package:flutter/material.dart';

class PayrollScreen extends StatelessWidget {
  final Map<String, dynamic> branch;
  final Map<String, dynamic>? userData;

  const PayrollScreen({
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
          child: Row(
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
                    hintText: 'Tên',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 70), // đẩy bảng xuống dưới một chút
          child: _buildSalaryTable(context),
        ),
      ],
    ),
  );
}

Widget _buildSalaryTable(BuildContext context) {
  final List<Map<String, String>> salaries = [
    {
      'code': '001',
      'name': 'Nguyễn Văn A',
      'position': 'Nhân viên',
      'branch': 'Chi nhánh 1',
      'work_days': '30',
      'actual_days': '28',
      'leave_days': '2',
      'basic_salary': '5,000,000',
      'allowance': '1,000,000',
      'bonus': '500,000',
      'net_salary': '6,500,000',
    },
    {
      'code': '002',
      'name': 'Trần Thị B',
      'position': 'Giám đốc',
      'branch': 'Chi nhánh 2',
      'work_days': '30',
      'actual_days': '30',
      'leave_days': '0',
      'basic_salary': '10,000,000',
      'allowance': '2,000,000',
      'bonus': '1,000,000',
      'net_salary': '13,000,000',
    },
    {
      'code': '003',
      'name': 'Lê Quang C',
      'position': 'Trưởng phòng',
      'branch': 'Chi nhánh 1',
      'work_days': '30',
      'actual_days': '25',
      'leave_days': '5',
      'basic_salary': '7,000,000',
      'allowance': '1,500,000',
      'bonus': '700,000',
      'net_salary': '9,200,000',
    },
    {
      'code': '004',
      'name': 'Phạm Thị D',
      'position': 'Nhân viên',
      'branch': 'Chi nhánh 3',
      'work_days': '30',
      'actual_days': '27',
      'leave_days': '3',
      'basic_salary': '5,500,000',
      'allowance': '1,200,000',
      'bonus': '600,000',
      'net_salary': '7,300,000',
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
          children: [
            TableRow(
              decoration: const BoxDecoration(
                color: Color(0xFFCCE5FF),
              ),
              children: [
                _buildTableHeaderCell('Mã'),
                _buildTableHeaderCell('Tên'),
                _buildTableHeaderCell('Chức vụ'),
                _buildTableHeaderCell('Chi nhánh'),
                _buildTableHeaderCell('Ngày công'),
                _buildTableHeaderCell('Ngày công thực tế'),
                _buildTableHeaderCell('Ngày nghỉ'),
                _buildTableHeaderCell('Lương cơ bản'),
                _buildTableHeaderCell('Phụ cấp'),
                _buildTableHeaderCell('Thưởng'),
                _buildTableHeaderCell('Lương thực nhận'),
              ],
            ),
          ],
        ),
        ...salaries.map((salary) {
          return Table(
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
                  _buildTableCell(salary['code']!),
                  _buildTableCell(salary['name']!),
                  _buildTableCell(salary['position']!),
                  _buildTableCell(salary['branch']!),
                  _buildTableCell(salary['work_days']!),
                  _buildTableCell(salary['actual_days']!),
                  _buildTableCell(salary['leave_days']!),
                  _buildTableCell(salary['basic_salary']!),
                  _buildTableCell(salary['allowance']!),
                  _buildTableCell(salary['bonus']!),
                  _buildTableCell(salary['net_salary']!),
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
