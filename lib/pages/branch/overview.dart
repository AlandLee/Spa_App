import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:spa_app/pages/branch/appointment_dialog.dart';

class MainContent extends StatefulWidget {
  final Map<String, dynamic> branch;
  final Map<String, dynamic>? userData;

  const MainContent({
    Key? key,
    required this.branch,
    required this.userData,
  }) : super(key: key);

  @override
  State<MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  List<Map<String, String>> schedules = [
    {
      'id': '1',
      'entity_id': 'kh1', // Mã đối tượng
      'name': 'Mẫu 1',
      'phone': '0909xxxx',
      'rank': 'Vàng',
      'date': '2025-04-10',
      'hour': '10:30 AM',
      'note': 'Khách yêu cầu giảm giá',
      'service': 'Dịch vụ 1',
      'status': 'Đã hoàn thành',
      'productList': '[{"productName": "Sản phẩm 1", "code": "1"}, {"productName": "Sản phẩm 2", "code": "2"}]',
    },
    {
      'id': '2',
      'entity_id': 'kh2', // Mã đối tượng
      'name': 'Mẫu 2',
      'phone': '0908yyyy',
      'rank': 'Bạc',
      'date': '2025-04-12',
      'hour': '02:00 PM',
      'note': 'Khách yêu cầu giao hàng nhanh',
      'service': 'Dịch vụ 2',
      'status': 'Chưa xác nhận',
      'productList': '[{"productName": "Sản phẩm 3", "code": "3"}, {"productName": "Sản phẩm 4", "code": "4"}]',
    },
    {
      'id': '3',
      'entity_id': 'kh3', // Mã đối tượng
      'name': 'Mẫu 3',
      'phone': '0907zzzz',
      'rank': 'Vàng',
      'date': '2025-04-15',
      'hour': '09:00 AM',
      'note': 'Khách yêu cầu thay đổi ngày',
      'service': 'Dịch vụ 3',
      'status': 'Đã hoàn thành',
      'productList': '[{"productName": "Sản phẩm 5", "code": "5"}, {"productName": "Sản phẩm 6", "code": "6"}]',
    },
    {
      'id': '4',
      'entity_id': 'kh4', // Mã đối tượng
      'name': 'Mẫu 4',
      'phone': '0906aaaa',
      'rank': 'Bạc',
      'date': '2025-04-20',
      'hour': '11:15 AM',
      'note': 'Khách yêu cầu thêm sản phẩm',
      'service': 'Dịch vụ 4',
      'status': 'Đang thực hiện',
      'productList': '[{"productName": "Sản phẩm 7", "code": "7"}, {"productName": "Sản phẩm 8", "code": "8"}]',
    },
  ];

  String searchScheduleName = '';
  String searchStudentName = '';
  Set<int> selectedRows = {}; // Dựa theo index
  List<Map<String, String>> filteredSchedules = [];

  List<Map<String, String>> students = [
  {
    'id': '1',
    'name': 'Nguyễn Văn A',
    'class': 'Yoga cơ bản',
    'date': '2025-04-20',
    'hour': '08:00 AM',
  },
  {
    'id': '2',
    'name': 'Trần Thị B',
    'class': 'Zumba nâng cao',
    'date': '2025-04-21',
    'hour': '09:30 AM',
  },
  {
    'id': '3',
    'name': 'Lê Văn C',
    'class': 'Kickfit',
    'date': '2025-04-22',
    'hour': '06:00 PM',
  },
  {
    'id': '4',
    'name': 'Lê Văn D',
    'class': 'Kickfit',
    'date': '2025-04-22',
    'hour': '06:00 PM',
  },
];

List<Map<String, String>> filteredStudents = [];

@override
void initState() {
  super.initState();
  print('📍 Branch data: ${widget.branch}');
}




  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
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
        Positioned(
          top: -24,
          right: -40,
          child: Image.asset(
            'images/logo_spa_none.png',
            width: screenSize.width * 0.55,
            height: screenSize.height * 0.55,
            fit: BoxFit.contain,
          ),
        ),
        Positioned.fill(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 530,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Từ ngày: 01/01/2025', style: TextStyle(fontSize: 16)),
                          Text('Đến ngày: 31/12/2025', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _statBox('12', 'Lớp học', Colors.orange, Icons.class_),
                          _statBox('100', 'Khách hàng', Colors.blue, Icons.people),
                          _statBox('140', 'Học viên', Colors.purple, Icons.school),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _summaryBox(
                            title: 'Tổng thu',
                            current: '+56.000.000',
                            previous: '+50.000.000',
                            growth: '+?',
                            color: Colors.green,
                            icon: Icons.attach_money,
                          ),
                          _summaryBox(
                            title: 'Tổng chi',
                            current: '-6.000.000',
                            previous: '-5.000.000',
                            growth: '-?',
                            color: Colors.red,
                            icon: Icons.money_off,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.branch['type'] == 'spa' || widget.branch['type'] == 'warehouse') // Spa và Tổng kho đều hiển thị lịch khách hàng
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'Lịch Khách Hàng',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            _buildScheduleTable(context),
                          ],
                        ),
                      ),
                    if (widget.branch['type'] == 'warehouse') const SizedBox(width: 16), // Khoảng cách nếu có cả 2 bảng
                    if (widget.branch['type'] == 'class' || widget.branch['type'] == 'warehouse') // Lớp học và Tổng kho đều hiển thị lịch học viên
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'Lịch Học Viên',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            _buildStudentTable(context),
                          ],
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _statBox(String value, String label, Color color, IconData icon) {
  return Container(
    width: 140,  // Tăng chiều rộng của container
    height: 100,  // Tăng chiều cao của container
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color, width: 2),  // Tăng độ dày của viền
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Thêm Row để kết hợp Icon và Text
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),  // Thêm icon
            const SizedBox(width: 8),  // Khoảng cách giữa icon và giá trị
            Text(
              value, 
              style: TextStyle(
                fontSize: 28,  // Tăng kích thước font của giá trị
                color: color, 
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        Text(
          label, 
          style: TextStyle(
            color: color, 
            fontSize: 16,  // Tăng kích thước font của nhãn
          ),
        ),
      ],
    ),
  );
}



  Widget _summaryBox({
  required String title,
  required String current,
  required String previous,
  required String growth,
  required Color color,
  required IconData icon, // Thêm icon
}) {
  return Container(
    width: 260,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color, width: 2),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Kì này: $current',
          style: TextStyle(color: color, fontSize: 18),
        ),
        Text(
          'Kì trước: $previous',
          style: TextStyle(color: color, fontSize: 18),
        ),
        Text(
          'Tăng trưởng: $growth',
          style: TextStyle(color: color, fontSize: 18),
        ),
      ],
    ),
  );
}




// Bảng lịch hẹn đơn giản
Widget _buildScheduleTable(BuildContext context) {
  final currentList = searchScheduleName.isEmpty ? schedules : filteredSchedules;
  final headers = ['Khách hàng', 'Dịch vụ', 'Ngày/Giờ', 'Tình trạng'];

  return Padding(
    padding: const EdgeInsets.all(0.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔘 Hàng nút bấm
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              // Ô tìm kiếm
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Tìm theo tên khách hàng...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      isDense: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchScheduleName = value;
                        filteredSchedules = schedules
                            .where((schedule) => (schedule['name'] ?? '')
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Nút "Thêm mới"
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('Thêm mới', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 5,
                    ),
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
                                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                                ),
                                child: AppointmentFormDialog(
                                  branch: widget.branch,
                                  userData: widget.userData,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Nút "Xuất Excel"
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.file_download, size: 20),
                    label: const Text('Xuất Excel', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 5,
                    ),
                    onPressed: () {
                      print('🧾 Đang xuất Excel...');
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Nút "Làm mới"
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.refresh, size: 20),
                    label: const Text('Làm mới', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 5,
                    ),
                    onPressed: () {
                      setState(() {
                        searchScheduleName = '';
                        filteredSchedules.clear();
                      });
                    },
                  ),
                ),
              ),
            ],
          ),

        ),

        // 📋 Tiêu đề bảng
        Table(
          columnWidths: {
            for (int i = 0; i < headers.length; i++) i: FlexColumnWidth(1),
          },
          border: TableBorder.all(
            color: Colors.black26,
            width: 1,
            borderRadius: BorderRadius.circular(0),
          ),
          children: [
            TableRow(
              decoration: const BoxDecoration(color: Color(0xFFCCE5FF)),
              children: headers.map((h) => _buildTableHeaderCell(h)).toList(),
            ),
          ],
        ),

        // 📦 Dữ liệu
        ...currentList.map((schedule) {
          final productListString = schedule['productList'] ?? '';
          String productNames = '';

          try {
            final decoded = jsonDecode(productListString);
            if (decoded is List) {
              productNames = decoded.map((e) => e['productName'] ?? '').join(' - ');
            }
          } catch (_) {}

          final dateTime = '${schedule['date'] ?? ''} - ${schedule['hour'] ?? ''}';

          return InkWell(
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
                          maxHeight: MediaQuery.of(context).size.height * 0.8,
                        ),
                        child: AppointmentFormDialog(
                          branch: widget.branch,
                          userData: widget.userData,
                          schedule: schedule,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Table(
              columnWidths: {
                for (int i = 0; i < headers.length; i++) i: FlexColumnWidth(1),
              },
              border: TableBorder.all(
                color: Colors.black26,
                width: 0.5,
              ),
              children: [
                TableRow(
                  decoration: const BoxDecoration(color: Colors.white),
                  children: [
                    _buildTableCell(schedule['name'] ?? ''),
                    _buildTableCell(productNames),
                    _buildTableCell(dateTime),
                    _buildTableCell(schedule['status'] ?? ''),
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
  final headers = ['Học viên', 'Lớp học', 'Ngày/Giờ'];
  final currentList = searchStudentName.isEmpty ? students : filteredStudents;

  return Padding(
    padding: const EdgeInsets.all(0.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔘 Hàng nút và tìm kiếm
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Tìm học viên...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      isDense: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchStudentName = value;
                        filteredStudents = students
                            .where((student) => (student['name'] ?? '')
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Nút "Thêm mới"
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('Thêm mới', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 5,
                    ),
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
                                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                                ),
                                child: AppointmentFormDialog(
                                  branch: widget.branch,
                                  userData: widget.userData,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Nút "Xuất Excel"
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.file_download, size: 20),
                    label: const Text('Xuất Excel', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 5,
                    ),
                    onPressed: () {
                      print('🧾 Đang xuất Excel học viên...');
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Nút "Làm mới"
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.refresh, size: 20),
                    label: const Text('Làm mới', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 5,
                    ),
                    onPressed: () {
                      setState(() {
                        searchStudentName = '';
                        filteredStudents.clear();
                      });
                    },
                  ),
                ),
              ),
            ],
          ),

        ),

        // 📋 Tiêu đề bảng
        Table(
          columnWidths: {
            for (int i = 0; i < headers.length; i++) i: const FlexColumnWidth(1),
          },
          border: TableBorder.all(
            color: Colors.black26,
            width: 1,
            borderRadius: BorderRadius.circular(0),
          ),
          children: [
            TableRow(
              decoration: const BoxDecoration(color: Color(0xFFCCE5FF)),
              children: headers.map((h) => _buildTableHeaderCell(h)).toList(),
            ),
          ],
        ),

        // 📦 Dữ liệu học viên
        ...currentList.map((student) {
          final dateTime = '${student['date'] ?? ''} - ${student['hour'] ?? ''}';

          return InkWell(
            onTap: () {
              // TODO: Dialog chi tiết học viên
            },
            child: Table(
              columnWidths: {
                for (int i = 0; i < headers.length; i++) i: const FlexColumnWidth(1),
              },
              border: TableBorder.all(
                color: Colors.black26,
                width: 0.5,
              ),
              children: [
                TableRow(
                  decoration: const BoxDecoration(color: Colors.white),
                  children: [
                    _buildTableCell(student['name'] ?? ''),
                    _buildTableCell(student['class'] ?? ''),
                    _buildTableCell(dateTime),
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
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
    ),
  );
}

Widget _buildTableCell(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    child: Text(
      text,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
    ),
  );
}
}
