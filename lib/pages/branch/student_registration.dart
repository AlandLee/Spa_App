import 'package:flutter/material.dart';

class StudentRegistrationScreen extends StatelessWidget {
  final Map<String, dynamic> branch;
  final Map<String, dynamic>? userData;

  const StudentRegistrationScreen({
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
                    width: 250,
                    child: TextField(
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Ngày',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16), // Khoảng cách giữa 2 ô
                  SizedBox(
                    width: 250,
                    child: TextField(
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Giờ',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildIconButton(Icons.search, () {}),
                  _buildIconButton(Icons.save, () {}),
                ],
              ),
              const SizedBox(height: 10), 
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
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
                  const SizedBox(width: 16), // Khoảng cách giữa 2 ô
                  Expanded(
                    child: SizedBox(
                      child: TextField(
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Trạng thái',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      child: TextField(
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Tổng tiền',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              const SizedBox(height: 10), 
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: TextField(
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Mã học viên',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16), // Khoảng cách giữa 2 ô
                  Expanded(
                    child: SizedBox(
                      child: TextField(
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Tên',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      child: TextField(
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Số điện thoại',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: TextField(
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Ghi chú',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              )
            ]),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 200), // đẩy bảng xuống dưới một chút
          child: _buildStudentRegistrationTable(context),
        ),
      ],
    ),
  );
}

Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        tooltip: icon == Icons.search
            ? 'Tìm kiếm'
            : 'Lưu',
      ),
    );
  }

Widget _buildStudentRegistrationTable(BuildContext context) {
  final List<Map<String, String>> registrations = [
    {
      'serial_number': '1',
      'class_name': 'Lớp A',
      'teacher': 'Thầy Nguyễn',
      'start_date': '01/05/2025',
      'end_date': '30/06/2025',
      'tuition_fee': '1,500,000',
    },
    {
      'serial_number': '2',
      'class_name': 'Lớp B',
      'teacher': 'Cô Lan',
      'start_date': '05/06/2025',
      'end_date': '05/07/2025',
      'tuition_fee': '1,200,000',
    },
    {
      'serial_number': '3',
      'class_name': 'Lớp C',
      'teacher': 'Thầy Hải',
      'start_date': '10/05/2025',
      'end_date': '10/06/2025',
      'tuition_fee': '1,000,000',
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
            0: FlexColumnWidth(1), // Số thứ tự
            1: FlexColumnWidth(3), // Tên lớp
            2: FlexColumnWidth(3), // Giáo viên
            3: FlexColumnWidth(2), // Ngày bắt đầu
            4: FlexColumnWidth(2), // Ngày kết thúc
            5: FlexColumnWidth(2), // Học phí
          },
          children: [
            TableRow(
              decoration: const BoxDecoration(
                color: Color(0xFFCCE5FF),
              ),
              children: [
                _buildTableHeaderCell('STT'),
                _buildTableHeaderCell('Tên lớp'),
                _buildTableHeaderCell('Giáo viên'),
                _buildTableHeaderCell('Ngày bắt đầu'),
                _buildTableHeaderCell('Ngày kết thúc'),
                _buildTableHeaderCell('Học phí'),
              ],
            ),
          ],
        ),
        ...registrations.map((registration) {
          return GestureDetector(
            onTap: () {
              // Handle onTap event if needed
            },
            child: Table(
              border: TableBorder.all(
                color: Colors.black26,
                width: 0.5,
              ),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(3),
                3: FlexColumnWidth(2),
                4: FlexColumnWidth(2),
                5: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  children: [
                    _buildTableCell(registration['serial_number']!),
                    _buildTableCell(registration['class_name']!),
                    _buildTableCell(registration['teacher']!),
                    _buildTableCell(registration['start_date']!),
                    _buildTableCell(registration['end_date']!),
                    _buildTableCell(registration['tuition_fee']!),
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
