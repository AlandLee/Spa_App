import 'package:flutter/material.dart';

class CashFlowScreen extends StatefulWidget {
  final Map<String, dynamic> branch;
  final Map<String, dynamic>? userData;

  const CashFlowScreen({Key? key, required this.branch, required this.userData})
    : super(key: key);

  @override
  State<CashFlowScreen> createState() => _CashFlowScreen();
}

class _CashFlowScreen extends State<CashFlowScreen> {

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
  // Các TextEditingController của bạn (giả sử đã tạo sẵn)
  final dateController = TextEditingController();
  final branchController = TextEditingController();
  final typeController = TextEditingController();
  final incomeController = TextEditingController();
  final expenseController = TextEditingController();
  final paymentTypeController = TextEditingController();
  final noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(color: const Color(0xFFE8F9FB)),
          Positioned(
            top: 0,
            left: 0,
            child: SizedBox(
              width: screenSize.width,
              height: screenSize.height,
              child: Image.asset('images/bg_spa_none.png', fit: BoxFit.contain),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Row(
              children: [
                // Ô tìm kiếm (TextField)
                Expanded(
                  flex: 2, // chiếm 2 phần trong tổng số 4 phần (tỷ lệ 2:1:1)
                  child: TextField(
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Chi nhánh',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 10), // khoảng cách giữa ô nhập và icon
                // Nút Thêm (dấu +)
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Thêm chi nhánh',
                  onPressed: () {
                    // Hiển thị hộp thoại nhập thông tin thu chi
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // Các TextEditingController để nhập thông tin
                        final TextEditingController dateController =
                            TextEditingController();
                        final TextEditingController branchController =
                            TextEditingController();
                        final TextEditingController typeController =
                            TextEditingController();
                        final TextEditingController incomeController =
                            TextEditingController();
                        final TextEditingController expenseController =
                            TextEditingController();
                        final TextEditingController paymentTypeController =
                            TextEditingController();
                        final TextEditingController noteController =
                            TextEditingController();

                        return AlertDialog(
                          title: const Text('Thêm Thu/Chi'),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                TextField(
                                  controller: dateController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: 'Ngày',
                                    suffixIcon: Icon(Icons.calendar_today),
                                  ),
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2101),
                                    );
                                    if (pickedDate != null) {
                                      String formattedDate =
                                          "${pickedDate.day.toString().padLeft(2, '0')}/"
                                          "${pickedDate.month.toString().padLeft(2, '0')}/"
                                          "${pickedDate.year}";
                                      dateController.text = formattedDate;
                                    }
                                  },
                                ),
                                TextField(
                                  controller: branchController,
                                  decoration: const InputDecoration(
                                    labelText: 'Chi nhánh',
                                  ),
                                ),
                                DropdownButtonFormField<String>(
                                  value: null,
                                  decoration: InputDecoration(
                                    labelText: 'Loại (Thu/Chi)',
                                  ),
                                  items:
                                      ['Thu', 'Chi']
                                          .map(
                                            (type) => DropdownMenuItem(
                                              value: type,
                                              child: Text(type),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (value) {
                                    typeController.text = value ?? '';
                                  },
                                ),
                                TextField(
                                  controller: incomeController,
                                  decoration: const InputDecoration(
                                    labelText: 'Thu (nếu có)',
                                  ),
                                ),
                                TextField(
                                  controller: expenseController,
                                  decoration: const InputDecoration(
                                    labelText: 'Chi (nếu có)',
                                  ),
                                ),
                                DropdownButtonFormField<String>(
                                  value: null,
                                  decoration: InputDecoration(
                                    labelText: 'Kiểu thanh toán',
                                  ),
                                  items:
                                      ['Tiền mặt', 'Chuyển khoản']
                                          .map(
                                            (type) => DropdownMenuItem(
                                              value: type,
                                              child: Text(type),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (value) {
                                    paymentTypeController.text = value ?? '';
                                  },
                                ),
                                TextField(
                                  controller: noteController,
                                  decoration: const InputDecoration(
                                    labelText: 'Ghi chú',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Đóng hộp thoại
                                Navigator.of(context).pop();
                              },
                              child: const Text('Hủy'),
                            ),
                            TextButton(
                              onPressed: () {
                                // TODO: Xử lý lưu thông tin thu chi
                                print('Ngày: ${dateController.text}');
                                print('Chi nhánh: ${branchController.text}');
                                print('Loại: ${typeController.text}');
                                print('Thu: ${incomeController.text}');
                                print('Chi: ${expenseController.text}');
                                print(
                                  'Kiểu thanh toán: ${paymentTypeController.text}',
                                );
                                print('Ghi chú: ${noteController.text}');
                                setState(() {
                                  // Thêm bản ghi mới vào danh sách cashFlows
                                  cashFlows.add({
                                    'date': dateController.text,
                                    'branch': branchController.text,
                                    'type': typeController.text,
                                    'income': incomeController.text,
                                    'expense': expenseController.text,
                                    'payment_type': paymentTypeController.text,
                                    'note': noteController.text,
                                  });
                                });
                                // In toàn bộ danh sách ra terminal để kiểm tra
                                print('--- Danh sách dòng tiền hiện tại ---');
                                for (var i = 0; i < cashFlows.length; i++) {
                                  print('[$i] ${cashFlows[i]}');
                                }

                                // Đóng dialog hoặc form sau khi thêm
                                Navigator.of(context).pop();
                              },
                              child: const Text('Lưu'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),

                // Nút Xóa (thùng rác)
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'Xóa chi nhánh',
                  onPressed: () {
                    // Hiển thị hộp thoại xác nhận xóa
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Xác nhận'),
                          content: const Text(
                            'Bạn có chắc chắn muốn xóa chi nhánh này?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Đóng hộp thoại nếu người dùng chọn "Hủy"
                                Navigator.of(context).pop();
                              },
                              child: const Text('Hủy'),
                            ),
                            TextButton(
                              onPressed: () {
                                // TODO: Thực hiện logic xóa chi nhánh
                                print('Chi nhánh đã được xóa');
                                Navigator.of(
                                  context,
                                ).pop(); // Đóng hộp thoại sau khi xóa
                              },
                              child: const Text('Xóa'),
                            ),
                          ],
                        );
                      },
                    );
                    // Xử lý xóa chi nhánh ở đây
                    // Ví dụ: gọi API để xóa chi nhánh hoặc cập nhật trạng thái trong ứng dụng
                    // Sau khi xóa, có thể hiển thị thông báo hoặc cập nhật giao diện
                    // Ví dụ: hiển thị thông báo
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(content: Text('Chi nhánh đã được xóa')));
                    // Hoặc cập nhật giao diện
                    // Ví dụ: gọi hàm để cập nhật danh sách chi nhánh
                    // Hoặc hiển thị thông báo
                    child:
                    const Text('Xóa');
                  },
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              top: 60,
            ), // đẩy bảng xuống dưới một chút
            child: _buildCashFlowTable(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCashFlowTable(BuildContext context) {
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
                decoration: const BoxDecoration(color: Color(0xFFCCE5FF)),
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
                border: TableBorder.all(color: Colors.black26, width: 0.5),
                children: [
                  TableRow(
                    decoration: const BoxDecoration(color: Colors.white),
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
      child: Text(text, style: TextStyle(fontSize: 14, color: Colors.black87)),
    );
  }
}
