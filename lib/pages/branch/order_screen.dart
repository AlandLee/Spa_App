import 'package:flutter/material.dart';
import 'package:spa_app/pages/branch/order_dialog.dart';
import 'package:spa_app/services/order_local_service.dart';

class OrderScreen extends StatefulWidget {
  final Map<String, dynamic> branch;
  final Map<String, dynamic>? userData;

  const OrderScreen({
    Key? key,
    required this.branch,
    required this.userData,
  }) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _orderDateController = TextEditingController();
  final _completionDateController = TextEditingController();
  final _poNumberController = TextEditingController();
  final _branchController = TextEditingController();
  final _statusController = TextEditingController();
  final _totalAmountController = TextEditingController();
  final _noteController = TextEditingController();

  List<Map<String, dynamic>> orders = [
  {
    'id': '1',
    'branch_id': '',
    'order_date': '2025-04-10',
    'completion_date': '2025-04-15',
    'po_number': 'PO001',
    'voucher_number': 'VP001',
    'branch': 'Chi nhánh A',
    'status': 'Đang xử lý',
    'total_amount': '1,000,000',
    'note': 'Ghi chú đơn hàng 1',
    'products': [
      {
        'code': '001',
        'name': 'Sản phẩm A',
        'unit': 'Cái',
        'supplier': 'Nhà cung cấp X',
        'quantity': '10',
        'unit_price': '50000',
        'total_price': '500000',
      },
      {
        'code': '002',
        'name': 'Sản phẩm B',
        'unit': 'Cái',
        'supplier': 'Nhà cung cấp Y',
        'quantity': '10',
        'unit_price': '50000',
        'total_price': '500000',
      }
    ]
  },
  {
    'id': '2',
    'branch_id': '',
    'order_date': '2025-04-10',
    'completion_date': '2025-04-15',
    'po_number': 'PO002',
    'voucher_number': 'VP001',
    'branch': 'Chi nhánh A',
    'status': 'Đang xử lý',
    'total_amount': '1,000,000',
    'note': 'Ghi chú đơn hàng 1',
    'products': [
      {
        'code': '001',
        'name': 'Sản phẩm A',
        'unit': 'Cái',
        'supplier': 'Nhà cung cấp X',
        'quantity': '10',
        'unit_price': '50000',
        'total_price': '500000',
      },
      {
        'code': '002',
        'name': 'Sản phẩm B',
        'unit': 'Cái',
        'supplier': 'Nhà cung cấp Y',
        'quantity': '10',
        'unit_price': '50000',
        'total_price': '500000',
      }
    ]
  },
  {
    'id': '3',
    'branch_id': '',
    'order_date': '2025-04-10',
    'completion_date': '2025-04-15',
    'po_number': 'PO002',
    'voucher_number': 'VP001',
    'branch': 'Chi nhánh A',
    'status': 'Đang xử lý',
    'total_amount': '1,000,000',
    'note': 'Ghi chú đơn hàng 1',
    'products': [
      {
        'code': '001',
        'name': 'Sản phẩm A',
        'unit': 'Cái',
        'supplier': 'Nhà cung cấp X',
        'quantity': '10',
        'unit_price': '50000',
        'total_price': '500000',
      },
      {
        'code': '002',
        'name': 'Sản phẩm B',
        'unit': 'Cái',
        'supplier': 'Nhà cung cấp Y',
        'quantity': '10',
        'unit_price': '50000',
        'total_price': '500000',
      }
    ]
  },
  // Các đơn hàng khác...
];


  @override
  void initState() {
    super.initState();
    final po = generatePO(widget.branch);
  print('Mã PO được tạo là: $po');
  _loadOrders();
  }

  String generatePO(Map<String, dynamic> branch) {
  final branchId = branch['id'].toString().padLeft(3, '0');
  return 'PO$branchId';
}

void _loadOrders() async {
  final branchId = widget.branch['branch_id'].toString(); // Thay bằng branch_id thực tế
  final result = await OrderLocalService.getOrdersByBranchId(branchId);
  setState(() {
    orders = result;
  });
}

  @override
  void dispose() {
    _orderDateController.dispose();
    _completionDateController.dispose();
    _poNumberController.dispose();
    _branchController.dispose();
    _statusController.dispose();
    _totalAmountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  final screenSize = MediaQuery.of(context).size;
  return Scaffold(

    // === Nút Thêm ===
    floatingActionButton: FloatingActionButton(
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
                                      maxHeight: MediaQuery.of(context).size.height * 0.8, // 🧠 KHÔNG thể thiếu dòng này
                                    ),
                                    child: OrderFormDialog(
                                      branch: widget.branch,
                                      userData: widget.userData,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
      },
      backgroundColor: Colors.blueAccent,
      child: const Icon(Icons.add),
    ),

    // === Nền và nội dung chính nếu có thể bổ sung sau ===
    body: Stack(
      children: [
        Container(
          color: const Color(0xFFE8F9FB), // Nền
        ),
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
        // Nội dung khác nếu cần
        Padding(
          padding: const EdgeInsets.only(top: 20), // đẩy bảng xuống dưới appbar
          child: _buildOrderTable(context),
        ),
      ],
    ),
  );
}

Widget _buildOrderTable(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
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
                _buildTableHeaderCell('Số PO'),
                _buildTableHeaderCell('Ngày đặt'),
                _buildTableHeaderCell('Trạng thái'),
              ],
            ),
          ],
        ),
        // Sử dụng 'order' thay vì 'orders[index]'
        ...orders.map((order) {
          return GestureDetector(
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
                        child: OrderFormDialog(
                          branch: widget.branch,
                          userData: widget.userData,
                          order: order,  // Sử dụng 'order' ở đây
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
              },
              border: TableBorder.symmetric(
                inside: BorderSide(color: Colors.black12, width: 0.5),
                outside: BorderSide.none,
              ),
              children: [
                TableRow(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  children: [
                    _buildTableCell(order['po_number']!),
                    _buildTableCell(order['order_date']!),
                    _buildTableCell(order['status']!),
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
    decoration: BoxDecoration(
      color: Colors.blueAccent.withOpacity(0.1),
    ),
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
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black26),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: Colors.black87,
      ),
    ),
  );
}

void showOrderDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24), // Padding thoáng hơn
        child: UnconstrainedBox(
          constrainedAxis: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 2 / 3,
              maxHeight: MediaQuery.of(context).size.height * 0.8, // Giới hạn chiều cao
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Container(
                    color: const Color(0xFFE8F9FB),
                  ),
                  Positioned.fill(
                    child: Image.asset(
                      'images/bg_spa_none.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 48, left: 16, right: 16, bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hàng 1
                        Row(
                          children: [
                            Expanded(child: _buildTextField(_orderDateController, 'Ngày đặt hàng')),
                            const SizedBox(width: 8),
                            Expanded(child: _buildTextField(_completionDateController, 'Ngày hoàn thành')),
                            const SizedBox(width: 8),
                            Expanded(child: _buildTextField(_poNumberController, 'Số PO')),
                            const SizedBox(width: 8),
                            _buildIconButton(Icons.search, () {}),
                            _buildIconButton(Icons.save, () {}),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Hàng 2
                        Row(
                          children: [
                            Expanded(child: _buildTextField(_branchController, 'Chi nhánh')),
                            const SizedBox(width: 8),
                            Expanded(child: _buildTextField(_statusController, 'Trạng thái')),
                            const SizedBox(width: 8),
                            Expanded(child: _buildTextField(_totalAmountController, 'Tổng tiền')),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Hàng 3
                        _buildTextField(_noteController, 'Ghi chú', maxLines: 2),
                        const SizedBox(height: 12),

                        // Bảng
                        Expanded(
                          child: SingleChildScrollView(
                            child: _buildScheduleTable(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Tiêu đề và nút đóng
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 48,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Stack(
                        children: [
                          const Center(
                            child: Text(
                              'Thêm đơn đặt hàng',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Icon(Icons.close, size: 24),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}


  Widget _buildTextField(TextEditingController controller, String hint,
    {int maxLines = 1}) {
  return TextField(
    controller: controller,
    maxLines: maxLines,
    decoration: InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black54),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(width: 1.5), // Tăng độ dày viền
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(width: 1.5, color: Colors.grey), // Viền khi không focus
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(width: 2, color: Colors.blue), // Viền khi focus
      ),
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
}


Widget _buildScheduleTable() {
  final headers = ['Mã', 'Tên', 'ĐVT', 'NCC', 'Số lượng', 'Đơn giá', 'Thành tiền'];
  final data = [
    ['Mẫu 1', 'Mẫu 1', '', '', '', '', ''],
    ['Mẫu 2', 'Mẫu 2', '', '', '', '', ''],
    ['Mẫu 3', 'Mẫu 3', '', '', '', '', ''],
    ['Mẫu 4', 'Mẫu 4', '', '', '', '', ''],
  ];

  return Table(
    border: TableBorder.all(color: Colors.grey),
    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    columnWidths: const {
      0: FlexColumnWidth(1),
      1: FlexColumnWidth(2),
      2: FlexColumnWidth(1),
      3: FlexColumnWidth(1.5),
      4: FlexColumnWidth(1),
      5: FlexColumnWidth(2),
      6: FlexColumnWidth(1),
    },
    children: [
      // Header row
      TableRow(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 216, 243, 247)),
        children: headers.map((h) => _tableHeader(h)).toList(),
      ),
      // Data rows with alternating colors
      for (int i = 0; i < data.length; i++)
        TableRow(
          decoration: BoxDecoration(
            color: i % 2 == 0 ? const Color(0xFFF0F0F0) : const Color(0xFFFAFAFA), // xám và xám nhạt
          ),
          children: data[i].map((cell) => _tableCell(cell)).toList(),
        ),
    ],
  );
}


Widget _tableHeader(String header) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      header,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}

Widget _tableCell(String cell) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
      controller: TextEditingController(text: cell),
      decoration: const InputDecoration(
        border: InputBorder.none, // Bỏ viền của TextField
        isDense: true, // Cải thiện chiều cao của TextField
      ),
    ),
  );
}
