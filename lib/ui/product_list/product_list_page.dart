import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gastos_app/app_globals/R.dart';
import 'package:gastos_app/base/bloc_state.dart';
import 'package:gastos_app/base/navigation_utils.dart';
import 'package:gastos_app/domain/category/category_model.dart';
import 'package:gastos_app/domain/product/product_model.dart';
import 'package:gastos_app/domain/subcategory/subcategory_model.dart';
import 'package:gastos_app/domain/transaction/transaction_model.dart';
import 'package:gastos_app/ui/add_product/add_product_page.dart';
import 'package:gastos_app/ui/product_list/product_list_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ProductListPage extends StatefulWidget {
  // final List<TransactionModel>? transactionList;
  final DateTime? date;

  const ProductListPage({
    super.key,
    // this.transactionList,
    this.date,
  });

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState
    extends StateWithBloC<ProductListPage, ProductListBloC> {
  @override
  void initState() {
    super.initState();
    bloc.init(widget.date!);
  }

  bool isSelectionMode = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget buildWidget(BuildContext context) {
    String date = DateFormat('EEEE, d MMMM yyyy').format(widget.date!);

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: R.color.whiteColor,
        onPressed: () async {
          AllTransactionDataModel newTransaction = AllTransactionDataModel(
              transaction: TransactionModel(
                  date: widget.date!, userId: "12", amount: 0));

          final TransactionModel? res = await NavigationUtils.push(
              context,
              AddProductPage(
                transaction: newTransaction.transaction,
                categoryList: bloc.categories,
                subcategoryList: bloc.subcategories,
                productList: bloc.products,
              ));
          if (res != null && res.productId != null) {
            newTransaction.transaction = res;
            await bloc.saveTransaction(newTransaction);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Icon(
            Icons.add,
            color: Colors.black,
            size: 30,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 5, top: 10),
                child: StreamBuilder<List<AllTransactionDataModel>>(
                    stream: bloc.transactionListStream,
                    initialData: [],
                    builder: (context, snapshot) {
                      final List<AllTransactionDataModel> transactionList =
                          snapshot.data ?? [];
                      return Column(
                        children: [
                          isSelectionMode
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 6),
                                      child: InkWell(
                                        child: Text("Select All",
                                            style: GoogleFonts.alkatra(
                                                fontSize: 20)),
                                        onTap: () {
                                          setState(() {
                                            bloc.checkAll();
                                          });
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 6),
                                      child: InkWell(
                                        child: Text("Cancel",
                                            style: GoogleFonts.alkatra(
                                                fontSize: 20)),
                                        onTap: () {
                                          setState(() {
                                            bloc.uncheckAll();
                                            isSelectionMode = false;
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      date,
                                      style: GoogleFonts.alkatra(fontSize: 22),
                                    ),
                                  ],
                                ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(),
                              transactionList.isNotEmpty
                                  ? ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: transactionList.length,
                                      itemBuilder: (context, index) {
                                        final AllTransactionDataModel
                                            transaction =
                                            transactionList[index];
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: ListTile(
                                                contentPadding: EdgeInsets.only(
                                                    left: 5, right: 25),
                                                title: Text(
                                                  transaction.product!.name
                                                      .toString(),
                                                  style: GoogleFonts.alkatra(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  "${transaction.transaction!.price.toString()}/unit = ${transaction.transaction!.amount.toString()}",
                                                  style: GoogleFonts.alkatra(
                                                    fontSize: 19,
                                                  ),
                                                ),
                                                onTap: () async {
                                                  final TransactionModel? res =
                                                      await NavigationUtils
                                                          .push(
                                                              context,
                                                              AddProductPage(
                                                                transaction:
                                                                    transaction
                                                                        .transaction,
                                                                categoryList: bloc
                                                                    .categories,
                                                                subcategoryList:
                                                                    bloc.subcategories,
                                                                productList: bloc
                                                                    .products,
                                                                isEditingMode:
                                                                    true,
                                                              ));
                                                  if (res != null &&
                                                      res.productId != null) {
                                                    transaction.transaction =
                                                        res;
                                                    await bloc
                                                        .updateTransaction(
                                                            transaction);
                                                  }
                                                },
                                                leading: isSelectionMode
                                                    ? Checkbox(
                                                        value: transaction
                                                                .transaction!
                                                                .selected ??
                                                            false,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            transaction
                                                                    .transaction!
                                                                    .selected =
                                                                value;
                                                          });
                                                        })
                                                    : null,
                                                 onLongPress: (){
                                                  setState(() {
                                                    transaction.transaction!.selected = true;
                                                    isSelectionMode = true;
                                                  });
                                                 },
                                                // trailing: Text("\$${transaction.transaction!.amount}"),
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                // Text("Quantity"),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            if (transaction
                                                                    .transaction!
                                                                    .quantity! >
                                                                1) {
                                                              transaction
                                                                  .transaction!
                                                                  .quantity = transaction
                                                                      .transaction!
                                                                      .quantity! -
                                                                  1;
                                                              transaction
                                                                  .transaction!
                                                                  .amount = (transaction
                                                                          .transaction!
                                                                          .price ??
                                                                      0) *
                                                                  transaction
                                                                      .transaction!
                                                                      .quantity!;
                                                              bloc.updateTransaction(
                                                                  transaction);
                                                            }
                                                          });
                                                        },
                                                        icon: Icon(
                                                          Icons.horizontal_rule,
                                                          size: 22,
                                                        )),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 3.0),
                                                      child: Text(
                                                        (transaction.transaction!
                                                                    .quantity ??
                                                                0)
                                                            .toStringAsFixed(0),
                                                        style:
                                                            GoogleFonts.alkatra(
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            transaction
                                                                .transaction!
                                                                .quantity = transaction
                                                                    .transaction!
                                                                    .quantity! +
                                                                1;
                                                            transaction
                                                                .transaction!
                                                                .amount = (transaction
                                                                        .transaction!
                                                                        .price ??
                                                                    0) *
                                                                transaction
                                                                    .transaction!
                                                                    .quantity!;
                                                          });
                                                          bloc.updateTransaction(
                                                              transaction);
                                                        },
                                                        icon: Icon(
                                                          Icons.add,
                                                          size: 22,
                                                        )),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        );
                                      })
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          left: 6, top: 10),
                                      child: Text(
                                        "List empty. Please add a new product",
                                        style: GoogleFonts.alkatra(
                                          fontSize: 16,
                                        ),
                                      ),
                                    )
                            ],
                          )
                        ],
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              NavigationUtils.pop(context);
            },
            icon: Icon(
              Icons.navigate_before_rounded,
              color: Colors.black,
              size: 35,
            )),
        title: Text(
          "Product list",
          style: GoogleFonts.alkatra(fontSize: 32, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: R.color.whiteColor,
        actions: [
          isSelectionMode
              ? IconButton(
                  onPressed: () async {
                    await bloc.deleteTransactions(widget.date!);
                    setState(() {
                      isSelectionMode = false;
                    });
                  },
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.black,
                    size: 34,
                  ))
              : InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.more_vert_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      isSelectionMode = true;
                    });
                  },
                )
        ],
      ),
      drawer: Drawer(),
    );
  }
}
