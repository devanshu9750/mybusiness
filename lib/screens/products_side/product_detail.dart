import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mybusiness/models/product_model.dart';
import 'package:mybusiness/screens/components.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductDetail extends StatefulWidget {
  final String productDocId;

  const ProductDetail({Key? key, required this.productDocId}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  bool _edit = false;
  String _code = '', _name = '', _description = '', _cp = '', _sp = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.productDocId.text.make(),
        actions: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _edit = true;
                });
              })
        ],
      ),
      floatingActionButton: (_edit)
          ? FloatingActionButton(
              onPressed: () {
                showModal(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Are you sure ?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _edit = false;
                          });
                          context.pop();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => context.pop(),
                        child: Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          Components.showLoading(context);
                          Product product = Product(
                              code: _code,
                              cp: _cp.isNotBlank ? int.parse(_cp) : 0,
                              description: _description,
                              name: _name,
                              sp: _sp.isNotBlank ? int.parse(_sp) : 0);
                          FirebaseFirestore.instance
                              .collection('products')
                              .doc(widget.productDocId)
                              .update(product.toJson)
                              .then((value) {
                            setState(() {
                              _edit = false;
                            });
                            context.pop();
                            context.pop();
                          });
                        },
                        child: Text('Yes'),
                      )
                    ],
                  ),
                );
              },
              child: Icon(Icons.check),
            )
          : null,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .doc(widget.productDocId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            Product product = Product.fromJson(
                snapshot.data?.data() ?? {}, snapshot.data?.id ?? "");

            _code = product.code;
            _name = product.name;
            _description = product.description;
            _cp = product.cp.toString();
            _sp = product.sp.toString();

            return VStack([
              "Code *".text.size(16).make(),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: _code,
                enabled: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              "Name".text.size(16).make(),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: _name,
                enabled: _edit,
                onChanged: (value) => _name = value.trim(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              "Description".text.size(16).make(),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: _description,
                enabled: _edit,
                onChanged: (value) => _description = value.trim(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              "Cost Price".text.size(16).make(),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: _cp,
                enabled: _edit,
                onChanged: (value) => _cp = value.trim(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              "Selling Price".text.size(16).make(),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: _sp,
                enabled: _edit,
                onChanged: (value) => _sp = value.trim(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            ]).scrollVertical().pOnly(left: 15, right: 15, top: 15);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
