import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mybusiness/models/vendor_modal.dart';
import 'package:mybusiness/screens/vendors_side/add_vendor.dart';
import 'package:mybusiness/screens/vendors_side/vendor_transactions.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

class VendorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('vendors').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          List<Vendor> clients = [];
          snapshot.data?.docs.forEach((element) {
            clients.add(Vendor.fromJson(element.data(), element.id));
          });
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              thickness: 2,
            ),
            itemCount: clients.length,
            itemBuilder: (context, index) {
              int balance = 0;
              clients[index].transactions.forEach((element) {
                if (element['credit'])
                  balance += element['amount'] as int;
                else
                  balance -= element['amount'] as int;
              });
              return OpenContainer(
                openElevation: 0,
                closedElevation: 0,
                openColor: context.canvasColor,
                closedColor: context.canvasColor,
                closedBuilder: (context, action) => ListTile(
                  leading: CircleAvatar(
                    child: clients[index].name[0].text.make(),
                  ),
                  trailing: "₹ $balance"
                      .text
                      .bold
                      .size(16)
                      .color(balance < 0 ? Colors.red : Colors.green)
                      .make(),
                  title: clients[index].name.text.make(),
                  subtitle:
                      "${DateFormat().format(clients[index].createdAt.toDate())}"
                          .text
                          .make(),
                ),
                openBuilder: (context, action) => VendorTransactions(
                  vendorDocId: clients[index].name,
                ),
              );
            },
          ).pOnly(top: 5);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
