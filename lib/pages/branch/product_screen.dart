import 'package:flutter/material.dart';
import 'package:spa_app/services/product_local_service.dart';

class ProductScreen extends StatefulWidget {
  final Map<String, dynamic> branch;
  final Map<String, dynamic>? userData;

  const ProductScreen({
    Key? key,
    required this.branch,
    required this.userData,
  }) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Map<String, String>> products = [
    {
      'branch': 'Cầu Giấy',
      'code': '001',
      'name': 'Tên',
      'unit': 'kg',
      'type': '',
      'size': '',
      'brand': '',
      'unit_price': '',
      'inventory': '10',
    },
    {
      'branch': 'Cầu Giấy',
      'code': '002',
      'name': 'Tên',
      'unit': 'kg',
      'type': '',
      'size': '',
      'brand': '',
      'unit_price': '',
      'inventory': '10',
    },
    {
      'branch': 'Cầu Giấy',
      'code': '003',
      'name': 'Tên',
      'unit': 'kg',
      'type': '',
      'size': '',
      'brand': '',
      'unit_price': '',
      'inventory': '10',
    },
  ];
  bool isDeleteMode = false;
  bool selectAll = false;
  Set<int> selectedRows = {};

  @override
  void initState() {
    super.initState();
    _loadProducts(widget.branch['branch_id'].toString());
  }

  // Hàm tải danh sách sản phẩm
  Future<void> _loadProducts(String branchId) async {
  final fetchedProducts = await ProductLocalService.getProductsByBranch(branchId);
  setState(() {
    products = fetchedProducts;
  });
}


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
          padding: const EdgeInsets.only(top: 20, left: 20),
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
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.blue),
                tooltip: 'Thêm hàng hoá',
                onPressed: () {
                  _showProductDialog(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  if (isDeleteMode) {
                    final currentList = products;
                    final toDelete = selectedRows.map((i) => currentList[i]).toList();

                    // Xoá trong SQLite
                    for (final product in toDelete) {
                      final idStr = product['id'];
                      if (idStr != null) {
                        final id = int.tryParse(idStr);
                        if (id != null) {
                          await ProductLocalService.deleteProduct(id);
                        }
                      }
                    }

                    // Xoá trong giao diện
                    setState(() {
                      products.removeWhere((e) => toDelete.contains(e));
                      selectedRows.clear();
                      isDeleteMode = false;
                      selectAll = false;
                    });
                  } else {
                    setState(() {
                      isDeleteMode = true;
                      selectedRows.clear();
                    });
                  }
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 60), // đẩy bảng xuống dưới một chút
          child: _buildProductTable(context),
        ),
      ],
    ),
  );
}


 Widget _buildProductTable(BuildContext context) {
  final currentList = products;

  return Padding(
    padding: const EdgeInsets.all(10.0),
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
                if (isDeleteMode)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Checkbox(
                      value: selectAll,
                      onChanged: (value) {
                        setState(() {
                          selectAll = value ?? false;
                          if (selectAll) {
                            selectedRows = Set.from(currentList.asMap().keys);
                          } else {
                            selectedRows.clear();
                          }
                        });
                      },
                    ),
                  ),
                _buildTableHeaderCell('Mã'),
                _buildTableHeaderCell('Tên'),
                _buildTableHeaderCell('ĐVT'),
                _buildTableHeaderCell('Loại'),
                _buildTableHeaderCell('Size'),
                _buildTableHeaderCell('Brand'),
                _buildTableHeaderCell('Đơn giá'),
                _buildTableHeaderCell('Kho'),
              ],
            ),
          ],
        ),
        ...currentList.asMap().entries.map((entry) {
          final index = entry.key;
          final product = entry.value;

          return InkWell(
            onTap: () {
              final realIndex = products.indexOf(product);
              _showProductDialog(context, product: product, index: realIndex);
            },
            child: Table(
              border: TableBorder.all(
                color: Colors.black26,
                width: 0.5,
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: selectedRows.contains(index)
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.white,
                  ),
                  children: [
                    if (isDeleteMode)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Checkbox(
                          value: selectedRows.contains(index),
                          onChanged: (bool? selected) {
                            setState(() {
                              if (selected == true) {
                                selectedRows.add(index);
                              } else {
                                selectedRows.remove(index);
                              }
                              selectAll = selectedRows.length == currentList.length;
                            });
                          },
                        ),
                      ),
                    _buildTableCell(product['code'] ?? ''),
                    _buildTableCell(product['name'] ?? ''),
                    _buildTableCell(product['unit'] ?? ''),
                    _buildTableCell(product['type'] ?? ''),
                    _buildTableCell(product['size'] ?? ''),
                    _buildTableCell(product['brand'] ?? ''),
                    _buildTableCell(product['unit_price'] ?? ''),
                    _buildTableCell(product['inventory'] ?? ''),
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

void _showProductDialog(BuildContext context, {Map<String, String>? product, int? index}) {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> newProduct = product ?? {
    'branch_id': widget.branch['branch_id'],
    'code': '',
    'name': '', // Chỉ cần tên sản phẩm
    'unit': '',
    'type': 'Hàng hoá',
    'size': '',
    'brand': '',
    'unit_price': '',
    'inventory': '',
  };

  final Map<String, String> fieldLabels = {
    'code': 'Mã sản phẩm',
    'name': 'Tên sản phẩm', // Tên sản phẩm vẫn là trường bắt buộc
    'unit': 'Đơn vị tính',
    'type': 'Loại sản phẩm',
    'size': 'Kích thước',
    'brand': 'Thương hiệu',
    'unit_price': 'Đơn giá',
    'inventory': 'Tồn kho',
  };

  final fields = fieldLabels.keys.toList();


  showDialog(
  context: context,
  builder: (context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(40),
      child: SizedBox(
        width: 800,
        height: 600,
        child: StatefulBuilder(
          builder: (context, setStateDialog) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    product == null ? 'Thêm sản phẩm mới' : 'Chỉnh sửa sản phẩm',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            ...List.generate((fields.length / 2).floor(), (i) {
                              final leftKey = fields[i * 2];
                              final rightKey = fields[i * 2 + 1];

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Expanded(child: _buildTextField(leftKey, newProduct, fieldLabels, () => setStateDialog(() {}))),
                                    const SizedBox(width: 24),
                                    Expanded(child: _buildTextField(rightKey, newProduct, fieldLabels, () => setStateDialog(() {}))),
                                  ],
                                ),
                              );
                            }),

                            if (fields.length % 2 != 0)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Expanded(child: _buildTextField(fields.last, newProduct, fieldLabels, () => setStateDialog(() {}))),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.cancel),
                        label: const Text('Hủy'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('Lưu'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          if (newProduct['name']!.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Tên sản phẩm không được để trống')),
                            );
                          } else {
                            try {
                              setState(() {
                                if (product == null) {
                                  ProductLocalService.addProduct(newProduct);
                                  products.add(Map.from(newProduct));
                                } else {
                                  int productId = int.tryParse(product['id'] ?? '') ?? 0;
                                  ProductLocalService.updateProduct(productId, newProduct);
                                  products[index!] = Map.from(newProduct);
                                }
                              });
                              Navigator.pop(context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Có lỗi xảy ra: $e')),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  },
);

}


Widget _buildTextField(
  String key,
  Map<String, String> product,
  Map<String, String> labels,
  VoidCallback refresh,
) {
  final iconMap = {
    'code': Icons.tag,
    'name': Icons.shopping_bag,
    'unit': Icons.crop,
    'type': Icons.category,
    'size': Icons.dashboard,
    'brand': Icons.branding_watermark,
    'unit_price': Icons.attach_money,
    'inventory': Icons.store,
  };

  // Chỉ tạo controller cho 'code'
  TextEditingController? controller;
  if (key == 'code') {
    controller = TextEditingController(text: product[key]);
  }

  // Tạo mã sản phẩm ngay khi mở dialog (trước khi người dùng chọn type)
  if (key == 'type') {
    Future.microtask(() async {
      final type = product['type'] ?? 'Hàng hoá';
      final code = await ProductLocalService.generateNextProductCode(type);
      setState(() {
        product['code'] = code;
        if (controller != null) {
          controller.text = code;  // Cập nhật giá trị vào controller
        }
      });
      print('Mã sản phẩm đã được tạo: $code');
      refresh(); // Gọi refresh sau khi gán mã
    });
  }

  // Nếu là trường type, dùng DropdownButtonFormField
  if (key == 'type') {
    return DropdownButtonFormField<String>(
      value: product[key]?.isEmpty ?? true ? 'Hàng hoá' : product[key],
      items: ['Hàng hoá', 'Dịch vụ'].map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type, style: const TextStyle(color: Colors.black)),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            product[key] = value;

            // Cập nhật lại mã khi type thay đổi
            Future.microtask(() async {
              final code = await ProductLocalService.generateNextProductCode(value);
              setState(() {
                product['code'] = code;
                if (controller != null) {
                  controller.text = code;
                }
              });
              print('Mã sản phẩm đã được tạo: $code');
              refresh(); // Gọi refresh sau khi gán mã
            });
          });
        }
      },
      decoration: InputDecoration(
        labelText: labels[key],
        prefixIcon: const Icon(Icons.category, size: 20),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      style: const TextStyle(fontSize: 14, color: Colors.black),
      validator: (value) => (value ?? '').isEmpty ? 'Không được để trống' : null,
    );
  }

  // Các trường còn lại sử dụng TextFormField bình thường
  return TextFormField(
    controller: controller,  // Sử dụng controller chỉ khi cần (cho trường 'code')
    // Loại bỏ initialValue khi sử dụng controller
    readOnly: key == 'code', // Nếu là trường mã thì không cho sửa
    decoration: InputDecoration(
      labelText: labels[key],
      prefixIcon: Icon(iconMap[key], size: 20),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    style: const TextStyle(fontSize: 14),
    onChanged: (value) {
      setState(() {
        product[key] = value;
      });
    },
    validator: (value) => (value ?? '').isEmpty ? 'Không được để trống' : null,
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
