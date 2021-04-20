import 'package:flutter/material.dart';
import 'package:mybusiness/screens/clients_side/clients_screen.dart';
import 'package:mybusiness/screens/vendors_side/vendors_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _moduleTitles = ['Clients', 'Vendors'];
  final List<Widget> _moduleWidgets = [ClientsScreen(), VendorScreen()];
  int _index = 1;

  Widget get _drawer => Drawer(
        child: SafeArea(
          child: VStack([
            SizedBox(
              height: 50,
            ),
            Divider(
              thickness: 2,
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: "Clients".text.size(16).make(),
            ).onInkTap(() {
              context.pop();
              setState(() {
                _index = 0;
              });
            }),
            ListTile(
              leading: Icon(Icons.shopping_bag_rounded),
              title: "Vendors".text.size(16).make(),
            ).onInkTap(() {
              context.pop();
              setState(() {
                _index = 1;
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
    );
  }
}
