import 'package:flutter/material.dart';
import 'package:mybusiness/screens/clients_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _moduleTitles = ['Clients'];
  final List<Widget> _moduleWidgets = [ClientsScreen()];
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
            ).onInkTap(() {
              context.pop();
              setState(() {
                _index = 0;
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
