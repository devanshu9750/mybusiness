import 'package:flutter/material.dart';
import 'package:mybusiness/screens/clients_side/add_client.dart';
import 'package:mybusiness/screens/clients_side/clients_screen.dart';
import 'package:mybusiness/screens/products_side/add_product.dart';
import 'package:mybusiness/screens/products_side/products_screen.dart';
import 'package:mybusiness/screens/vendors_side/add_vendor.dart';
import 'package:mybusiness/screens/vendors_side/vendors_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _moduleTitles = ['Clients', 'Vendors', 'Products'];
  final List<Widget> _moduleWidgets = [
    ClientsScreen(),
    VendorScreen(),
    ProductsScreen()
  ];
  int _index = 0;

  Widget get _drawer => Drawer(
        child: SafeArea(
          child: VStack([
            SizedBox(
              height: 20,
            ),
            Divider(
              thickness: 2,
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: "Clients".text.size(16).make(),
              trailing: IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () {
                    context.pop();
                    setState(() {
                      _index = 0;
                    });
                    context.push((context) => AddClient());
                  }),
            ).onInkTap(() {
              context.pop();
              setState(() {
                _index = 0;
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
                      _index = 1;
                    });
                    context.push((context) => AddVendor());
                  }),
            ).onInkTap(() {
              context.pop();
              setState(() {
                _index = 1;
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
                      _index = 2;
                    });
                    context.push((context) => AddProduct());
                  }),
            ).onInkTap(() {
              context.pop();
              setState(() {
                _index = 2;
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
      ),
      drawer: _drawer,
      body: _moduleWidgets[_index],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_index == 0) context.push((context) => AddClient());
          if (_index == 1) context.push((context) => AddVendor());
          if (_index == 2) context.push((context) => AddProduct());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
