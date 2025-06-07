import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gastos_app/base/navigation_utils.dart';
import 'package:gastos_app/domain/category/category_model.dart';
import 'package:gastos_app/domain/product/product_model.dart';
import 'package:gastos_app/domain/subcategory/subcategory_model.dart';
import 'package:gastos_app/domain/transaction/transaction_model.dart';
import 'package:intl/intl.dart';

class AddProductPage extends StatefulWidget {
  final TransactionModel? transaction;
  final List<ProductModel>? productList;
  final List<CategoryModel>? categoryList;
  final List<SubcategoryModel>? subcategoryList;

  const AddProductPage({super.key,
    this.transaction,
    required this.productList,
    required this.categoryList,
    required this.subcategoryList,
  });

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  late final TransactionModel newTransaction;
  List<ProductModel> products = [];

  int? _selectedProduct;
  bool _isCalculating = false;

  @override
  void initState() {
    super.initState();
    newTransaction = widget.transaction!;
    products = widget.productList ?? [];
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  @override
  void dispose() {
    _priceController.dispose();
    _quantityController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _calculateTotal() async {
    if (_isCalculating) return;

    _isCalculating = true;

    try {
      final price = double.tryParse(_priceController.text.replaceAll(',', '')) ?? 0;
      final quantity = double.tryParse(_quantityController.text.replaceAll(',', '')) ?? 0;
      final amount = double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;

      if (_priceController.text.isNotEmpty && _quantityController.text.isNotEmpty) {
        final calculatedTotal = price * quantity;
        _amountController.text = _formatNumber(calculatedTotal);
      } else if (_priceController.text.isNotEmpty && _amountController.text.isNotEmpty) {
        final calculatedQuantity = amount / price;
        _quantityController.text = _formatNumber(calculatedQuantity);
      } else if (_quantityController.text.isNotEmpty && _amountController.text.isNotEmpty) {
        final calculatedPrice = amount / quantity;
        _priceController.text = _formatNumber(calculatedPrice);
      }
      newTransaction.quantity = double.tryParse(_quantityController.text) ?? 0.0;
      newTransaction.amount = double.tryParse(_amountController.text) ?? 0.0;
    } finally {
      _isCalculating = false;
    }
  }

  String _formatNumber(double value) {
    return NumberFormat("#,##0.00", "en_US").format(value);
  }

  Future<DateTime?> _selectDate(BuildContext context, DateTime? dateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateSelected ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
      return picked;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close,
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text('Add a product',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_outlined,
              size: 30,
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Save logic here
                NavigationUtils.pop(context, result: newTransaction);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Product',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _selectedProduct,
                items: products.map((ProductModel value) {
                  return DropdownMenuItem<int>(
                    value: value.id,
                    child: Text(value.name),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedProduct = newValue;
                    newTransaction.productId = newValue;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a product';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildNumberField(
                      label: 'Price',
                      controller: _priceController,
                      onChanged: (_) async {
                        await _calculateTotal();
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildNumberField(
                      label: 'Quantity',
                      controller: _quantityController,
                      onChanged: (_) async {
                        await _calculateTotal();

                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildNumberField(
                      label: 'Total',
                      controller: _amountController,
                      onChanged: (_) async {
                        await _calculateTotal();
                      },
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Text(
                    'Bought on:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_month_outlined),
                          onPressed: () async {
                            final DateTime? newDate = await _selectDate(context, null);
                            if(newDate != null){
                              newTransaction.date = newDate;
                            }
                          }
                        ),
                      ),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Where',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value){
                  newTransaction.place = _locationController.text;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Add note',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                onChanged: (value) {
                  newTransaction.notes = _noteController.text;
                },
                maxLines: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField({
    required String label,
    required TextEditingController controller,
    required void Function(String) onChanged,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          onChanged: onChanged,
          readOnly: readOnly,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a value';
            }
            return null;
          },
        ),
      ],
    );
  }
}