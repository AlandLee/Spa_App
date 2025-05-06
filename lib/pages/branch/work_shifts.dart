import 'package:flutter/material.dart';


class WorkShiftsScreen extends StatelessWidget {
  final Map<String, dynamic> branch;
  final Map<String, dynamic>? userData;

  const WorkShiftsScreen({
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bảng Quy ước
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quy ước',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildConventionTable(context),
                      ],
                    ),
                  ),

                  const SizedBox(width: 20), // Khoảng cách giữa hai bảng

                  // Bảng Danh sách ngày lễ
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Danh sách ngày lễ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildHolidayListTable(context),
                      ],
                    ),
                  ),
                ],
              ),


              const SizedBox(height: 20), // Khoảng cách giữa hai bảng

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bảng Giờ làm việc (ngắn hơn một chút)
                  Flexible(
                    flex: 3, // Tỷ lệ chiếm không gian của bảng Giờ làm việc
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Giờ làm việc',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildShiftScheduleTable(context),
                      ],
                    ),
                  ),

                  const SizedBox(width: 20), // Khoảng cách giữa hai bảng

                  // Bảng Phân ca (dài hơn một chút)
                  Flexible(
                    flex: 4, // Tỷ lệ chiếm không gian của bảng Phân ca
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Phân ca',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildEmployeeShiftTable(context),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildConventionTable(BuildContext context) {
  final List<Map<String, String>> conventionData = [
    {
      'symbol': 'Ký hiệu 1',
      'convention_work': 'Công 1',
      'description': 'Mô tả công 1',
    },
    {
      'symbol': 'Ký hiệu 2',
      'convention_work': 'Công 2',
      'description': 'Mô tả công 2',
    },
    {
      'symbol': 'Ký hiệu 3',
      'convention_work': 'Công 3',
      'description': 'Mô tả công 3',
    },
    {
      'symbol': 'Ký hiệu 4',
      'convention_work': 'Công 4',
      'description': 'Mô tả công 4',
    },
  ];

  final headers = [
    'Ký hiệu công',
    'Công quy ước',
    'Diễn giải',
  ];

  return Padding(
    padding: const EdgeInsets.all(0.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          columnWidths: {
            for (int i = 0; i < headers.length; i++)
              i: FlexColumnWidth(1), // Cột tự động điều chỉnh
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
        ...conventionData.map((data) {
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
                    _buildTableCell(data['symbol']!),
                    _buildTableCell(data['convention_work']!),
                    _buildTableCell(data['description']!),
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

Widget _buildHolidayListTable(BuildContext context) {
  final List<Map<String, String>> holidayData = [
    {
      'holiday_name': 'Tết Nguyên Đán',
      'holiday_date': '01/01/2025',
    },
    {
      'holiday_name': 'Giỗ Tổ Hùng Vương',
      'holiday_date': '10/03/2025',
    },
    {
      'holiday_name': 'Ngày Quốc Khánh',
      'holiday_date': '02/09/2025',
    },
    {
      'holiday_name': 'Tết Trung Thu',
      'holiday_date': '15/08/2025',
    },
  ];

  final headers = [
    'Tên ngày lễ',
    'Ngày tháng',
  ];

  return Padding(
    padding: const EdgeInsets.all(0.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          columnWidths: {
            0: FlexColumnWidth(2), // Cột tên ngày lễ
            1: FlexColumnWidth(1), // Cột ngày tháng
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
        ...holidayData.map((holiday) {
          return GestureDetector(
            onTap: () {
              // Handle tap action
            },
            child: Table(
              columnWidths: {
                0: FlexColumnWidth(2), // Cột tên ngày lễ
                1: FlexColumnWidth(1), // Cột ngày tháng
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
                    _buildTableCell(holiday['holiday_name']!),
                    _buildTableCell(holiday['holiday_date']!),
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

Widget _buildShiftScheduleTable(BuildContext context) {
  final List<Map<String, String>> shiftData = [
    {
      'shift_name': 'Sáng',
      'start_time': '08:00',
      'end_time': '12:00',
      'break_time': '10:00 - 10:15',
    },
    {
      'shift_name': 'Chiều',
      'start_time': '13:00',
      'end_time': '17:00',
      'break_time': '15:00 - 15:15',
    },
    {
      'shift_name': 'Tối',
      'start_time': '18:00',
      'end_time': '22:00',
      'break_time': '20:00 - 20:15',
    },
  ];

  final headers = [
    'Tên ca',
    'Giờ vào',
    'Giờ ra',
    'Nghỉ giữa giờ',
  ];

  return Padding(
    padding: const EdgeInsets.all(0.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          columnWidths: {
            0: FlexColumnWidth(2), // Tên ca
            1: FlexColumnWidth(2), // Giờ vào
            2: FlexColumnWidth(2), // Giờ ra
            3: FlexColumnWidth(3), // Nghỉ giữa giờ
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
        ...shiftData.map((shift) {
          return Table(
            columnWidths: {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(3),
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
                  _buildTableCell(shift['shift_name']!),
                  _buildTableCell(shift['start_time']!),
                  _buildTableCell(shift['end_time']!),
                  _buildTableCell(shift['break_time']!),
                ],
              ),
            ],
          );
        }).toList(),
      ],
    ),
  );
}

Widget _buildEmployeeShiftTable(BuildContext context) {
  final List<Map<String, String>> employeeShifts = [
    {
      'employee': 'Nguyễn Văn A',
      'position': 'Nhân viên',
      'shift': 'Sáng',
      'from_date': '01/04/2025',
      'to_date': '15/04/2025',
    },
    {
      'employee': 'Trần Thị B',
      'position': 'Quản lý',
      'shift': 'Chiều',
      'from_date': '05/04/2025',
      'to_date': '20/04/2025',
    },
    {
      'employee': 'Lê Văn C',
      'position': 'Giám sát',
      'shift': 'Tối',
      'from_date': '10/04/2025',
      'to_date': '30/04/2025',
    },
  ];

  final headers = [
    'Nhân viên',
    'Chức vụ', // Thêm cột chức vụ
    'Ca làm việc',
    'Từ ngày',
    'Đến ngày',
  ];

  return Padding(
    padding: const EdgeInsets.all(0.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          columnWidths: {
            0: FlexColumnWidth(2), // Nhân viên
            1: FlexColumnWidth(2), // Chức vụ
            2: FlexColumnWidth(2), // Ca làm việc
            3: FlexColumnWidth(2), // Từ ngày
            4: FlexColumnWidth(2), // Đến ngày
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
              children:
                  headers.map((header) => _buildTableHeaderCell(header)).toList(),
            ),
          ],
        ),
        ...employeeShifts.map((item) {
          return Table(
            columnWidths: {
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
                  _buildTableCell(item['employee']!),
                  _buildTableCell(item['position']!), // Hiển thị chức vụ
                  _buildTableCell(item['shift']!),
                  _buildTableCell(item['from_date']!),
                  _buildTableCell(item['to_date']!),
                ],
              ),
            ],
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
