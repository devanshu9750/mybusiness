import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mybusiness/models/product_model.dart';
import 'package:mybusiness/screens/products_side/product_detail.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          List<Product> products = [];
          snapshot.data?.docs.forEach((element) {
            products.add(Product.fromJson(element.data(), element.id));
          });
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              thickness: 2,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return OpenContainer(
                closedColor: context.canvasColor,
                openColor: context.canvasColor,
                closedElevation: 0,
                openElevation: 0,
                closedBuilder: (context, action) => ListTile(
                  leading: CircleAvatar(),
                  title: "${products[index].code}".text.bold.size(16).make(),
                  subtitle: (products[index].name.isNotBlank)
                      ? "${products[index].name}".text.make()
                      : null,
                  trailing: "₹ ${products[index].cp} / ₹ ${products[index].sp}"
                      .text
                      .bold
                      .make(),
                ),
                openBuilder: (context, action) =>
                    ProductDetail(productDocId: products[index].code),
              );
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
