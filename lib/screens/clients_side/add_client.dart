import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mybusiness/models/client_modal.dart';
import 'package:mybusiness/screens/components.dart';
import 'package:velocity_x/velocity_x.dart';

class AddClient extends StatefulWidget {
  @override
  _AddClientState createState() => _AddClientState();
}

class _AddClientState extends State<AddClient> {
  String _name = '', _phoneNumber = '', _email = '', _address = '';

  _addClient() {
    if (_name.isNotBlank) {
      if (_phoneNumber.length != 10) {
        Fluttertoast.showToast(msg: 'Phone Number is Invalid');
        return;
      }
      Client client = Client(
          address: _address,
          email: _email,
          name: _name,
          phoneNumber: _phoneNumber,
          transactions: [],
          createdAt: Timestamp.now());
      Components.showLoading(context);
      FirebaseFirestore.instance
          .collection('clients')
          .doc(_name)
          .set(client.toJson)
          .then((value) {
        context.pop();
        context.pop();
      });
    } else {
      Fluttertoast.showToast(msg: 'Name cannot be empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Add Client".text.make(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addClient(),
        child: Icon(Icons.check),
      ),
      body: VStack([
        "Name".text.size(16).make(),
        SizedBox(
          height: 10,
        ),
        VxTextField(
          borderType: VxTextFieldBorderType.roundLine,
          borderRadius: 10,
          hint: "Name",
          autofocus: true,
          onChanged: (value) => _name = value,
        ),
        SizedBox(
          height: 10,
        ),
        "Phone Number".text.size(16).make(),
        SizedBox(
          height: 10,
        ),
        VxTextField(
          hint: "Phone Number",
          keyboardType: TextInputType.phone,
          borderType: VxTextFieldBorderType.roundLine,
          borderRadius: 10,
          onChanged: (value) => _phoneNumber = value,
        ),
        SizedBox(
          height: 10,
        ),
        "Email".text.size(16).make(),
        SizedBox(
          height: 10,
        ),
        VxTextField(
          borderType: VxTextFieldBorderType.roundLine,
          borderRadius: 10,
          hint: "Email",
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) => _email = value,
        ),
        SizedBox(
          height: 10,
        ),
        "Address".text.size(16).make(),
        SizedBox(
          height: 10,
        ),
        VxTextField(
          maxLine: null,
          borderType: VxTextFieldBorderType.roundLine,
          borderRadius: 10,
          hint: "Address",
          onChanged: (value) => _address = value,
        )
      ]).scrollVertical().pOnly(top: 15, right: 15, left: 15).scrollVertical(),
    );
  }
}
