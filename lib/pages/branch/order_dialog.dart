import 'package:flutter/material.dart';
import 'package:spa_app/services/order_local_service.dart';

class OrderFormDialog extends StatefulWidget {
  final Map<String, dynamic> branch;
  final Map<String, dynamic>? userData;
  final Map<String, dynamic>? order; // <- thêm dòng này

  OrderFormDialog({
    super.key,
    required this.branch,
    required this.userData,
    this.order, // <- thêm dòng này
  });

  @override
  State<OrderFormDialog> createState() => _OrderFormDialogState();
}

class _OrderFormDialogState extends State<OrderFormDialog> {
  final TextEditingController _orderDateController = TextEditingController();       // Ngày đặt hàng
  final TextEditingController _completionDateController = TextEditingController(); // Ngày hoàn thành
  final TextEditingController _poNumberController = TextEditingController();       // Số PO
  final TextEditingController _voucherNumberController = TextEditingController();       // Số phiếu
  final TextEditingController _branchNameController = TextEditingController();     // Chi nhánh
  final TextEditingController _statusController = TextEditingController();         // Trạng thái
  final TextEditingController _totalAmountController = TextEditingController();    // Tổng tiền
  final TextEditingController _noteController = TextEditingController();           // Ghi chú

  List<List<TextEditingController>> _controllers = [];

  List<Map<String, String>> products = [
    {
      'code': '',
      'name': '',
      'unit': '',
      'supplier': '',
      'quantity': '',
      'unit_price': '',
      'total_price': '',
    },
    // có thể thêm bao nhiêu đơn hàng tùy ý
  ];
  bool isDeleteMode = false;
  bool selectAll = false;
  Set<int> selectedRows = {};
  bool isNewOrder = false;

  @override
void initState() {
  super.initState();

  if (widget.order != null) {
    // Nếu order có danh sách hàng hóa, cập nhật products
    var rawProducts = widget.order?['products'];
    if (rawProducts != null && rawProducts is List) {
      products = rawProducts.map((e) => Map<String, String>.from(e as Map)).toList();
    }


    // Cập nhật các trường khác
    _orderDateController.text = widget.order?['order_date'] ?? '';
    _completionDateController.text = widget.order?['completion_date'] ?? '';
    _poNumberController.text = widget.order?['po_number'] ?? '';
    _voucherNumberController.text = widget.order?['voucher_number'] ?? '';
    _branchNameController.text = widget.order?['branch'] ?? '';
    _statusController.text = widget.order?['status'] ?? '';
    _totalAmountController.text = widget.order?['total_amount'] ?? '';
    _noteController.text = widget.order?['note'] ?? '';
    isNewOrder = false;
  }else{
    isNewOrder = true;
  }

  // Khởi tạo controller từ products (sau khi cập nhật từ widget.order)
  _syncControllersFromProducts();
  //print('Branch: ${widget.branch}');
}

void _syncControllersFromProducts() {
  _controllers = List.generate(products.length, (index) {
    final product = products[index];
    return [
      TextEditingController(text: product['code']),
      TextEditingController(text: product['name']),
      TextEditingController(text: product['unit']),
      TextEditingController(text: product['supplier']),
      TextEditingController(text: product['quantity']),
      TextEditingController(text: product['unit_price']),
      TextEditingController(text: product['total_price']),
    ];
  });
}


  @override
  void dispose() {
    _orderDateController.dispose();
    _completionDateController.dispose();
    _poNumberController.dispose();
    _branchNameController.dispose();  // Sửa thành _branchNameController
    _statusController.dispose();
    _totalAmountController.dispose();
    _noteController.dispose();
    for (var row in _controllers) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    super.dispose();
  }


  @override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;

  return Center(
    child: SizedBox(
      width: screenWidth * 2 / 3, // Chiều ngang chỉ chiếm 2/3 màn hình
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
                      Expanded(child: _buildDateField(_orderDateController, 'Ngày đặt hàng')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildDateField(_completionDateController, 'Ngày hoàn thành')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTextField(_poNumberController, 'Số PO')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTextField(_voucherNumberController, 'Số phiếu')),
                      const SizedBox(width: 8),
                      _buildIconButton(Icons.save, () {
                        //_printOrderData();
                        _saveOrder();
                      }),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Hàng 2
                  Row(
                    children: [
                      if (widget.branch['type'] == 'kho tổng') 
                      ...[
                        Expanded(child: _buildTextField(_branchNameController, 'Chi nhánh')),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: _buildDropdownField(
                          _statusController,
                          'Trạng thái',
                          widget.branch['type'] == 'kho tổng'
                              ? ['Chờ xác nhận', 'Đã xác nhận', 'Từ chối', 'Đang giao', 'Hoàn thành']
                              : ['Chờ xác nhận'], // Kho thường chỉ có 1 lựa chọn
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTextField(_totalAmountController, 'Tổng tiền')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildTextField(_noteController, 'Ghi chú')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _addOrderRow,
                        icon: const Icon(Icons.add),
                        label: const Text('Thêm hàng'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                        setState(() {
                          if (!isDeleteMode) {
                            isDeleteMode = true;
                          } else {
                            if (selectedRows.isNotEmpty) {
                              final toRemove = selectedRows.toList()..sort((a, b) => b.compareTo(a));
                              for (final index in toRemove) {
                                products.removeAt(index);
                                _controllers.removeAt(index); // 👈 xoá controller tương ứng
                              }
                              selectedRows.clear();
                              isDeleteMode = false;
                              selectAll = false;
                              // ✅ Không cần gọi _syncControllersFromProducts()
                            } else {
                              isDeleteMode = false;
                              selectAll = false;
                            }
                          }
                        });
                      },
                        icon: const Icon(Icons.delete),
                        label: Text(isDeleteMode ? 'Xác nhận xoá' : 'Xoá hàng'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Bảng
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildProductTable(context),
                    ),
                  ),
                ],
              ),
            ),

            // === TIÊU ĐỀ VÀ NÚT ĐÓNG ===
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
                    Center(
                      child: Text(
                        widget.order != null ? 'Sửa phiếu đặt hàng' : 'Thêm phiếu đặt hàng',
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
                        onTap: () {
                          Navigator.of(context).pop(); // Đóng dialog
                        },
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
  );
}

 void _saveOrder() {
    _syncControllersToOrders();  // Đồng bộ dữ liệu từ controllers vào order

    if (isNewOrder) {
      _addNewOrder();
    } else {
      _updateOrder();
    }
  }

   void _addNewOrder() async {
  // Tạo map đơn hàng với snake_case key đúng theo schema
  Map<String, dynamic> newOrder = {
    'order_date': _orderDateController.text,
    'completion_date': _completionDateController.text,
    'po_number': _poNumberController.text,
    'voucher_number': _voucherNumberController.text,
    'branch_id': widget.branch['branch_id'],
    'branch': widget.branch['name'],
    'status': _statusController.text,
    'total_amount': _totalAmountController.text,
    'note': _noteController.text,
  };

  print('🌟 Đơn hàng mới: $newOrder');
  print('📦 Danh sách sản phẩm: $products');

  try {
    await OrderLocalService.insertOrderWithProducts(newOrder, products);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đơn hàng đã được thêm mới!'),
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.of(context).pop(); // đóng dialog nếu cần
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lỗi khi thêm đơn hàng: $e'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}

  // Cập nhật đơn hàng
  void _updateOrder() {
    // Logic cập nhật đơn hàng vào database hoặc backend
    print('Cập nhật đơn hàng: ${widget.order}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đơn hàng đã được cập nhật!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

void _syncControllersToOrders() {
  // Cập nhật lại dữ liệu bảng sản phẩm từ các TextEditingController
  for (int i = 0; i < _controllers.length; i++) {
    if (i < products.length) {
      products[i] = {
        'code': _controllers[i][0].text,
        'name': _controllers[i][1].text,
        'unit': _controllers[i][2].text,
        'supplier': _controllers[i][3].text,
        'quantity': _controllers[i][4].text,
        'unit_price': _controllers[i][5].text,
        'total_price': _controllers[i][6].text,
      };
    }
  }

  // Cập nhật lại các thông tin khác nếu bạn muốn dùng biến order nội bộ
  // (chỉ nếu cần lưu các dữ liệu chung, không bắt buộc nếu bạn chỉ quan tâm products)
  widget.order?['order_date'] = _orderDateController.text;
  widget.order?['completion_date'] = _completionDateController.text;
  widget.order?['po_number'] = _poNumberController.text;
  widget.order?['voucher_number'] = _voucherNumberController.text;
  widget.order?['branch'] = _branchNameController.text;
  widget.order?['status'] = _statusController.text;
  widget.order?['total_amount'] = _totalAmountController.text;
  widget.order?['note'] = _noteController.text;
  widget.order?['products'] = products;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Dữ liệu đã được lưu thành công!'),
      duration: Duration(seconds: 2),
    ),
  );
}

void _printOrderData() {
  _syncControllersToOrders(); // Đồng bộ dữ liệu trước đã
  print('🧾 Toàn bộ order:');
  print(widget.order);
}



void _addOrderRow() {
  setState(() {
    products.add({
      'code': '',
      'name': '',
      'unit': '',
      'supplier': '',
      'quantity': '',
      'unit_price': '',
      'total_price': '',
    });
    _controllers.add([
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
    ]);
  });
}


  // Các controller, hàm _buildTextField, _buildIconButton, _buildScheduleTable bạn tự thêm vào file này nhé.
  Widget _buildTextField(TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
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

  Widget _buildDateField(TextEditingController controller, String hint) {
  return GestureDetector(
    onTap: () async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        setState(() {
          controller.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
        });
      }
    },
    child: AbsorbPointer(
      child: _buildTextField(controller, hint),
    ),
  );
}

Widget _buildDropdownField(TextEditingController controller, String label, List<String> options) {
  String initialValue = options.contains(controller.text) ? controller.text : options.first;
  controller.text = initialValue; // Gán giá trị mặc định nếu chưa có

  return DropdownButtonFormField<String>(
    value: controller.text,
    decoration: InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
      hintText: label,
      hintStyle: const TextStyle(color: Colors.black54),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(width: 1.5),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(width: 1.5, color: Colors.grey),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(width: 2, color: Colors.blue),
      ),
    ),
    items: options.map((status) {
      return DropdownMenuItem<String>(
        value: status,
        child: Text(status),
      );
    }).toList(),
    onChanged: (value) {
      if (value != null) {
        controller.text = value;
      }
    },
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

  Widget _buildProductTable(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề bảng
        Table(
          columnWidths: {
            if (isDeleteMode) 0: const FlexColumnWidth(1),
            for (int i = 0; i < 7; i++) (isDeleteMode ? i + 1 : i): const FlexColumnWidth(2),
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
                if (isDeleteMode)
                  Checkbox(
                    value: selectAll,
                    onChanged: (value) {
                      setState(() {
                        selectAll = value!;
                        if (selectAll) {
                          selectedRows = Set<int>.from(List.generate(products.length, (index) => index));
                        } else {
                          selectedRows.clear();
                        }
                      });
                    },
                  ),
                _buildTableHeaderCell('Mã'),
                _buildTableHeaderCell('Tên'),
                _buildTableHeaderCell('ĐVT'),
                _buildTableHeaderCell('NCC'),
                _buildTableHeaderCell('Số lượng'),
                _buildTableHeaderCell('Đơn giá'),
                _buildTableHeaderCell('Thành tiền'),
              ],
            ),
          ],
        ),

        // Dữ liệu bảng
        ...List.generate(products.length, (index) {
          return Table(
            columnWidths: {
              if (isDeleteMode) 0: const FlexColumnWidth(1),
              for (int i = 0; i < 7; i++) (isDeleteMode ? i + 1 : i): const FlexColumnWidth(2),
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
                  if (isDeleteMode)
                    Checkbox(
                      value: selectedRows.contains(index),
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            selectedRows.add(index);
                          } else {
                            selectedRows.remove(index);
                            selectAll = false;
                          }
                        });
                      },
                    ),
                  _buildTableCell(_controllers[index][0], text: products[index]['code']!),
                  _buildTableCell(_controllers[index][1], text: products[index]['name']!),
                  _buildTableCell(_controllers[index][2], text: products[index]['unit']!),
                  _buildTableCell(_controllers[index][3], text: products[index]['supplier']!),
                  _buildTableCell(_controllers[index][4], text: products[index]['quantity']!),
                  _buildTableCell(_controllers[index][5], text: products[index]['unit_price']!),
                  _buildTableCell(_controllers[index][6], text: products[index]['total_price']!),
                ],
              ),
            ],
          );
        }),
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


Widget _buildTableCell(TextEditingController controller, {String text = ""}) {
  if (controller.text.isEmpty) {
    controller.text = text;
  }

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
    child: TextField(
      controller: controller,
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
    ),
  );
}



}
