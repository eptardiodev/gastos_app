import 'package:flutter/material.dart';
import 'package:gastos_app/base/bloc_state.dart';
import 'package:gastos_app/domain/category/category_model.dart';
import 'package:gastos_app/domain/expense/expense_model.dart';
import 'package:gastos_app/domain/product/product_model.dart';
import 'package:gastos_app/domain/subcategory/subcategory_model.dart';
import 'package:gastos_app/domain/transaction/transaction_model.dart';
import 'package:gastos_app/ui/create_expense/create_transaction_bloc.dart';
import 'package:gastos_app/ui/tx_widgets/tx_main_app_bar_widget.dart';
import 'package:intl/intl.dart';

import '../../base/navigation_utils.dart';

class CreateTransactionWidget extends StatefulWidget {
  final TransactionModel? transaction;
  final List<ProductModel>? productList;
  final List<CategoryModel>? categoryList;
  final List<SubcategoryModel>? subcategoryList;

  const CreateTransactionWidget({
    this.transaction,
    this.productList,
    this.categoryList,
    this.subcategoryList,
    super.key,
  });

  @override
  State<CreateTransactionWidget> createState() =>
      _CreateTransactionWidgetState();
}

class _CreateTransactionWidgetState
    extends StateWithBloC<CreateTransactionWidget, CreateTransactionBloc> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  late final TransactionModel newTransaction;

  int? productSelected;
  // int? categorySelected;
  // int? subcategorySelected;

  List<ProductModel> products = [];
  // List<CategoryModel> categories = [];
  // List<SubcategoryModel> subcategories = [];

  late final List<DropdownMenuItem<int>> dropDProductItems;
  // late final List<DropdownMenuItem<int>> dropDCategoryItems;
  // late final List<DropdownMenuItem<int>> dropDSubcategoryItems;

  @override
  void initState() {
    super.initState();
    newTransaction = widget.transaction!;
    // categories = widget.categoryList ?? [];
    // subcategories = widget.subcategoryList ?? [];
    products = widget.productList ?? [];

    // dropDCategoryItems = categories
    //     .map(
    //       (CategoryModel value) => DropdownMenuItem<int>(
    //         value: value.id,
    //         child: Text(value.name),
    //       ),
    //     )
    //     .toList();
    //
    // dropDSubcategoryItems = subcategories
    //     .map(
    //       (SubcategoryModel value) => DropdownMenuItem<int>(
    //         value: value.id,
    //         child: Text(value.name),
    //       ),
    //     )
    //     .toList();
    //

    dropDProductItems = products
        .map(
          (ProductModel value) => DropdownMenuItem<int>(
            value: value.id,
            child: Text(value.name),
          ),
        )
        .toList();
  }

  @override
  void dispose() {
    super.dispose();
    _productController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _locationController.dispose();
  }

  @override
  Widget buildWidget(BuildContext context) {
    String formattedDate =
        DateFormat('dd/MM/yyyy  hh:mm a').format(newTransaction.date);

    return TXMainAppBarWidget(
      title: 'Create Transaction',
      centeredTitle: true,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton(
                                items: dropDProductItems,
                                value: productSelected,
                                onChanged: (int? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      newTransaction.productId = newValue;
                                      productSelected = newValue;
                                    });
                                  }
                                }),
                          ),
                        ),
                      ],
                    ),

                    /// Product
                    Text(
                      "Product",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _productController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                          // newTransaction.productId = 2;
                        },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a product name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    /// Price
                    Text(
                      'Price',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: '\$0.00',
                        prefixText: '\$',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    /// Quantity
                    Text(
                      'Quantity',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Quantity',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a quantity';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    /// Description
                    Text(
                      'Description',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Optional',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 16),

                    /// Bought on
                    Text(
                      'Bought on',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        hintText: 'Date',
                        border: OutlineInputBorder(),
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
                          _dateController.text =
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                        }
                      },
                    ),
                    SizedBox(height: 16),

                    /// Where
                    Text(
                      'Where',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        hintText: 'Location',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Form is valid, process the data
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Product added successfully')),
                            );
                            NavigationUtils.pop(context, result: newTransaction);
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          child: Text(
                            'Add Item',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Row(
//   children: [
//     Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Icon(
//         Icons.add_circle,
//         size: 22,
//         color: Colors.blue,
//       ),
//     ),
//     Expanded(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: DropdownButton(
//             items: dropDSubcategoryItems,
//             value: subcategorySelected,
//             onChanged: (int? newValue) {
//               if (newValue != null) {
//                 setState(() {
//                   subcategorySelected = newValue;
//                 });
//               }
//             }),
//       ),
//     )
//   ],
// ),
// Row(
//   children: [
//     Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Icon(
//         Icons.add_circle,
//         size: 22,
//         color: Colors.blue,
//       ),
//     ),
//     Expanded(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: DropdownButton(
//             items: dropDProductItems,
//             value: productSelected,
//             onChanged: (int? newValue) {
//               if (newValue != null) {
//                 setState(() {
//                   // newTransaction.productId = newValue;
//                   productSelected = newValue;
//                 });
//               }
//             }),
// TextField(
//   controller: productController,
//   onChanged: (value) {
//     // newTransaction.product = value;
//   },
//   decoration: InputDecoration(
//       labelText: 'Transaction Product',
//       border: const OutlineInputBorder(
//           borderRadius:
//           BorderRadius.all(Radius.circular(10.0)))),
// ),
// ),
// )
// ],
// ),
// Row(
//   children: [
//     Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Icon(
//         Icons.monetization_on_sharp,
//         size: 22,
//         color: Colors.blue,
//       ),
//     ),
//     Expanded(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: TextField(
//           controller: priceController,
//           onChanged: (value) {
//             double? doublePrice = double.tryParse(value);
//             if (doublePrice != null) {
//               newTransaction.price = doublePrice;
// }
// },
// keyboardType: TextInputType.number,
// decoration: InputDecoration(
//     labelText: 'Amount Spent',
//     border: const OutlineInputBorder(
//         borderRadius:
//             BorderRadius.all(Radius.circular(10.0)))),
// ),
// ),
// )
// ],
// ),
// Row(
//   children: [
//     Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Icon(
//         Icons.shopping_bag,
//         size: 22,
//         color: Colors.blue,
//       ),
//     ),
//     Expanded(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: TextField(
//           controller: amountController,
//           onChanged: (value) {
//             int? intAmount = int.tryParse(value);
//             if (intAmount != null) {
//               newTransaction.amount = intAmount;
// }
// },
// keyboardType: TextInputType.number,
// decoration: InputDecoration(
//     suffixIcon: DropdownButton(
//         items: dropDownMenuItems,
//         value: unidadSelected,
//         onChanged: (String? newValue) {
//           if (newValue != null) {
//             setState(() => unidadSelected = newValue);
//           }
//         }),
//     labelText: 'Product Quantity',
//     border: const OutlineInputBorder(
//         borderRadius:
//         BorderRadius.all(Radius.circular(10.0)))),
// ),
// ),
// ),
// ],
// ),
