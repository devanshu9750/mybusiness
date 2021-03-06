import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mybusiness/models/personal_expense_modal.dart';
import 'package:mybusiness/screens/clients_side/add_client.dart';
import 'package:mybusiness/screens/clients_side/clients_screen.dart';
import 'package:mybusiness/screens/components.dart';
import 'package:mybusiness/screens/dashboard_side/dashboard_screen.dart';
import 'package:mybusiness/screens/personal_expense/personal_expenses_screen.dart';
import 'package:mybusiness/screens/products_side/add_product.dart';
import 'package:mybusiness/screens/products_side/products_screen.dart';
import 'package:mybusiness/screens/reports_side/reports_screen.dart';
import 'package:mybusiness/screens/search.dart';
import 'package:mybusiness/screens/vendors_side/add_vendor.dart';
import 'package:mybusiness/screens/vendors_side/vendors_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _moduleTitles = [
    'Dashboard',
    'Reports',
    'Clients',
    'Vendors',
    'Products',
    'Personal Expense'
  ];
  final List<Widget> _moduleWidgets = [
    DashboardScreen(),
    ReportsScreen(),
    ClientsScreen(),
    VendorScreen(),
    ProductsScreen(),
    PersonalExpensesScreen()
  ];
  int _index = 0;

  Widget get _drawer => Drawer(
        child: SafeArea(
          child: VStack([
            SizedBox(
              height: 20,
            ),
            "My Business".text.bold.size(20).makeCentered(),
            SizedBox(
              height: 10,
            ),
            Divider(
              thickness: 5,
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: "Dashboard".text.size(16).make(),
            ).onInkTap(() {
              context.pop();
              setState(() {
                _index = 0;
              });
            }),
            ListTile(
              leading: Icon(Icons.analytics),
              title: "Reports".text.size(16).make(),
            ).onInkTap(() {
              context.pop();
              setState(() {
                _index = 1;
              });
            }),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: "Clients".text.size(16).make(),
              trailing: IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () {
                    context.pop();
                    setState(() {
                      _index = 2;
                    });
                    context.push((context) => AddClient());
                  }),
            ).onInkTap(() {
              context.pop();
              setState(() {
                _index = 2;
              });
            }),
            ListTile(
              leading: Icon(Icons.shopping_bag_rounded),
              title: "Vendors".text.size(16).make(),
              trailing: IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () {
                    context.pop();
                    setState(() {
                      _index = 3;
                    });
                    context.push((context) => AddVendor());
                  }),
            ).onInkTap(() {
              context.pop();
              setState(() {
                _index = 3;
              });
            }),
            ListTile(
              leading: Icon(Icons.inventory),
              title: "Products".text.size(16).make(),
              trailing: IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () {
                    context.pop();
                    setState(() {
                      _index = 4;
                    });
                    context.push((context) => AddProduct());
                  }),
            ).onInkTap(() {
              context.pop();
              setState(() {
                _index = 4;
              });
            }),
            ListTile(
              leading: Icon(Icons.monetization_on_sharp),
              title: "Personal Expenses".text.size(16).make(),
              trailing: IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () {
                    context.pop();
                    setState(() {
                      _index = 5;
                    });
                    String _amount = '', _message = '';
                    showModal(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Add Personal Expense"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                context.pop();
                              },
                              child: Text("Cancel")),
                          TextButton(
                              onPressed: () async {
                                if (_amount.isNotBlank) {
                                  PersonalExpense personalExpense =
                                      PersonalExpense(
                                          amount: int.parse(_amount),
                                          message: _message,
                                          time: Timestamp.now(),
                                          id: '');
                                  Components.showLoading(context);
                                  await FirebaseFirestore.instance
                                      .collection('personalexpense')
                                      .doc()
                                      .set(personalExpense.toJson);
                                  context.pop();
                                  context.pop();
                                }
                              },
                              child: Text("Confirm")),
                        ],
                        content: VStack([
                          Text('Amount *'),
                          SizedBox(
                            height: 10,
                          ),
                          VxTextField(
                            borderType: VxTextFieldBorderType.roundLine,
                            borderRadius: 10,
                            hint: 'Amount',
                            onChanged: (value) => _amount = value.trim(),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Message (optional)"),
                          SizedBox(
                            height: 10,
                          ),
                          VxTextField(
                            borderType: VxTextFieldBorderType.roundLine,
                            borderRadius: 10,
                            hint: 'Message',
                            onChanged: (value) => _message = value.trim(),
                          ),
                        ]),
                      ),
                    );
                  }),
            ).onInkTap(() {
              context.pop();
              setState(() {
                _index = 5;
              });
            })
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _moduleTitles[_index].text.make(),
        centerTitle: true,
        actions: _index == 0 || _index == 1
            ? []
            : [
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      if (_index == 2)
                        FirebaseFirestore.instance
                            .collection('clients')
                            .get()
                            .then((value) {
                          ClientSearch.data = value.docs;
                          showSearch(
                              context: context, delegate: ClientSearch());
                        });
                      else if (_index == 3)
                        FirebaseFirestore.instance
                            .collection('vendors')
                            .get()
                            .then((value) {
                          VendorSearch.data = value.docs;
                          showSearch(
                              context: context, delegate: VendorSearch());
                        });
                      else if (_index == 4)
                        FirebaseFirestore.instance
                            .collection('products')
                            .get()
                            .then((value) {
                          ProductSearch.data = value.docs;
                          showSearch(
                              context: context, delegate: ProductSearch());
                        });
                    })
              ],
      ),
      drawer: _drawer,
      body: _moduleWidgets[_index],
      floatingActionButton: _index == 0 || _index == 1
          ? null
          : FloatingActionButton(
              onPressed: () {
                if (_index == 2) context.push((context) => AddClient());
                if (_index == 3) context.push((context) => AddVendor());
                if (_index == 4) context.push((context) => AddProduct());
                if (_index == 5) {
                  String _amount = '', _message = '';
                  showModal(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Add Personal Expense"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: Text("Cancel")),
                        TextButton(
                            onPressed: () async {
                              if (_amount.isNotBlank) {
                                PersonalExpense personalExpense =
                                    PersonalExpense(
                                        amount: int.parse(_amount),
                                        message: _message,
                                        time: Timestamp.now(),
                                        id: '');
                                Components.showLoading(context);
                                await FirebaseFirestore.instance
                                    .collection('personalexpense')
                                    .doc()
                                    .set(personalExpense.toJson);
                                context.pop();
                                context.pop();
                              }
                            },
                            child: Text("Confirm")),
                      ],
                      content: VStack([
                        Text('Amount *'),
                        SizedBox(
                          height: 10,
                        ),
                        VxTextField(
                          borderType: VxTextFieldBorderType.roundLine,
                          borderRadius: 10,
                          hint: 'Amount',
                          onChanged: (value) => _amount = value.trim(),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Message (optional)"),
                        SizedBox(
                          height: 10,
                        ),
                        VxTextField(
                          borderType: VxTextFieldBorderType.roundLine,
                          borderRadius: 10,
                          hint: 'Message',
                          onChanged: (value) => _message = value.trim(),
                        ),
                      ]),
                    ),
                  );
                }
              },
              child: Icon(Icons.add),
            ),
    );
  }
}
