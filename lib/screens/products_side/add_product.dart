import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mybusiness/models/product_model.dart';
import 'package:mybusiness/screens/components.dart';
import 'package:velocity_x/velocity_x.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String _code = '',
      _name = '',
      _description = '',
      _cp = '',
      _sp = '',
      _quantity = '';

  _addProduct() {
    if (_code.isNotBlank) {
      Components.showLoading(context);
      Product product = Product(
          code: _code,
          cp: int.parse((_cp.isNotBlank) ? _cp : '0'),
          description: _description,
          name: _name,
          sp: int.parse((_sp.isNotBlank) ? _sp : '0'),
          quantity: int.parse((_quantity.isNotBlank) ? _quantity : '0'));
      FirebaseFirestore.instance
          .collection('products')
          .doc(_code)
          .set(product.toJson)
          .then((value) {
        context.pop();
        context.pop();
      });
    } else {
      Fluttertoast.showToast(msg: 'Code cannot be empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: "Add Product".text.make(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addProduct(),
          child: Icon(Icons.check),
        ),
        body: VStack([
          "Code *".text.size(16).make(),
          SizedBox(
            height: 10,
          ),
          VxTextField(
            borderRadius: 10,
            borderType: VxTextFieldBorderType.roundLine,
            onChanged: (value) => _code = value.trim(),
            hint: "Code",
            autofocus: true,
          ),
          SizedBox(
            height: 10,
          ),
          "Name".text.size(16).make(),
          SizedBox(
            height: 10,
          ),
          VxTextField(
            borderRadius: 10,
            borderType: VxTextFieldBorderType.roundLine,
            onChanged: (value) => _name = value.trim(),
            hint: "Name",
          ),
          SizedBox(
            height: 10,
          ),
          "Description".text.size(16).make(),
          SizedBox(
            height: 10,
          ),
          VxTextField(
            borderRadius: 10,
            borderType: VxTextFieldBorderType.roundLine,
            onChanged: (value) => _description = value.trim(),
            hint: "Description",
            maxLine: null,
          ),
          SizedBox(
            height: 10,
          ),
          "Cost Price".text.size(16).make(),
          SizedBox(
            height: 10,
          ),
          VxTextField(
            keyboardType: TextInputType.number,
            borderRadius: 10,
            borderType: VxTextFieldBorderType.roundLine,
            onChanged: (value) => _cp = value.trim(),
            hint: "Cost Price",
          ),
          SizedBox(
            height: 10,
          ),
          "Selling Price".text.size(16).make(),
          SizedBox(
            height: 10,
          ),
          VxTextField(
            keyboardType: TextInputType.number,
            borderRadius: 10,
            borderType: VxTextFieldBorderType.roundLine,
            onChanged: (value) => _sp = value.trim(),
            hint: "Selling Price",
          ),
          SizedBox(
            height: 10,
          ),
          "Quantity".text.size(16).make(),
          SizedBox(
            height: 10,
          ),
          VxTextField(
            keyboardType: TextInputType.number,
            borderRadius: 10,
            borderType: VxTextFieldBorderType.roundLine,
            onChanged: (value) => _quantity = value.trim(),
            hint: "Quantity",
          ),
          SizedBox(
            height: 20,
          )
        ]).scrollVertical().pOnly(left: 15, top: 15, right: 15));
  }
}
