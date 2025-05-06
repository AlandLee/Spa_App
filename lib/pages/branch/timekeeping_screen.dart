import 'package:flutter/material.dart';

class TimekeepingScreen extends StatelessWidget {
  final Map<String, dynamic> branch;
  final Map<String, dynamic>? userData;

  const TimekeepingScreen({
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
          child: _buildAttendanceTable(context),
        ),
      ],
    ),
  );
}


Widget _buildAttendanceTable(BuildContext context) {
  // Cột tiêu đề: Tháng, NV, CV, ngày 1 đến 31
  final headers = ['Tháng', 'NV', 'CV', ...List.generate(31, (index) => '${index + 1}')];

  // Tạo 12 hàng trống với cột "Tháng" hiển thị số tháng
  final rows = List.generate(12, (monthIndex) {
    final row = List<String>.filled(34, '');
    row[0] = 'Tháng ${monthIndex + 1}'; // Cột "Tháng"
    // row[1] = ''; // NV
    // row[2] = ''; // CV
    return row;
  });

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Column(
      children: [
        // Header
        Table(
          columnWidths: {
            for (int i = 0; i < headers.length; i++) i: const FixedColumnWidth(80),
          },
          border: TableBorder.all(color: Colors.black26),
          children: [
            TableRow(
              decoration: const BoxDecoration(color: Color(0xFFCCE5FF)),
              children: headers.map((header) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    header,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                );
              }).toList(),
            ),
          ],
        ),

        // Rows
        Table(
          columnWidths: {
            for (int i = 0; i < headers.length; i++) i: const FixedColumnWidth(80),
          },
          border: TableBorder.symmetric(
            inside: const BorderSide(color: Colors.black12, width: 0.5),
            outside: BorderSide.none,
          ),
          children: rows.map((rowData) {
            return TableRow(
              decoration: const BoxDecoration(color: Colors.white),
              children: rowData.map((cell) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    cell,
                    textAlign: TextAlign.center,
                  ),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ],
    ),
  );
}
}
