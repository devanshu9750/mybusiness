import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mybusiness/models/client_model.dart';
import 'package:mybusiness/models/personal_expense_modal.dart';
import 'package:mybusiness/models/vendor_model.dart';
import 'package:velocity_x/velocity_x.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VStack([
      "Overall : "
          .text
          .size(16)
          .semiBold
          .make()
          .pOnly(left: 10, top: 10, bottom: 5),
      Card(
        child: ListTile(
          title: "Outstanding :".text.bold.make(),
          subtitle: "Total".text.semiBold.make(),
          trailing: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('clients').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                int outstanding = 0;
                snapshot.data?.docs.forEach((doc) {
                  Client client = Client.fromJson(doc.data(), doc.id);
                  int subtotal = 0;
                  client.transactions.forEach((transaction) {
                    if (transaction['credit'])
                      subtotal += transaction['amount'] as int;
                    else
                      subtotal -= transaction['amount'] as int;
                  });
                  outstanding += subtotal;
                });
                return '₹ $outstanding'
                    .text
                    .color(Colors.red)
                    .size(18)
                    .bold
                    .make();
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ).p(5),
      "This month :"
          .text
          .semiBold
          .size(16)
          .make()
          .pOnly(top: 5, bottom: 5, left: 10),
      Card(
        child: ListTile(
          title: "Total Revenue :".text.bold.make(),
          subtitle: "This month".text.semiBold.make(),
          trailing: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('clients').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                int revenue = 0;
                snapshot.data?.docs.forEach((doc) {
                  Client client = Client.fromJson(doc.data(), doc.id);
                  client.transactions.forEach((transaction) {
                    if ((transaction['time'] as Timestamp).compareTo(
                            Timestamp.fromDate(DateTime(DateTime.now().year,
                                DateTime.now().month, 1))) >
                        0) if (transaction['credit'])
                      revenue += transaction['amount'] as int;
                  });
                });
                return '₹ +$revenue'
                    .text
                    .bold
                    .color(Colors.green)
                    .size(18)
                    .make();
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ).p(5),
      Card(
        child: ListTile(
          title: "Total Expense :".text.bold.make(),
          subtitle: "This month".text.semiBold.make(),
          trailing: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('vendors').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                int expense = 0;
                snapshot.data?.docs.forEach((doc) {
                  Vendor client = Vendor.fromJson(doc.data(), doc.id);
                  client.transactions.forEach((transaction) {
                    if ((transaction['time'] as Timestamp).compareTo(
                            Timestamp.fromDate(DateTime(DateTime.now().year,
                                DateTime.now().month, 1))) >
                        0) if (!transaction['credit'])
                      expense += transaction['amount'] as int;
                  });
                });
                return '₹ -$expense'
                    .text
                    .bold
                    .color(Colors.red)
                    .size(18)
                    .make();
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ).p(5),
      Card(
        child: ListTile(
          title: "Total Personal Expense :".text.bold.make(),
          subtitle: "This month".text.semiBold.make(),
          trailing: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('personalexpense')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                int expense = 0;
                snapshot.data?.docs.forEach((doc) {
                  PersonalExpense personalExpense =
                      PersonalExpense.fromJson(doc.data(), doc.id);
                  if (personalExpense.time.compareTo(Timestamp.fromDate(
                          DateTime(
                              DateTime.now().year, DateTime.now().month, 1))) >
                      0) expense += personalExpense.amount;
                });
                return '₹ -$expense'
                    .text
                    .bold
                    .color(Colors.red)
                    .size(18)
                    .make();
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ).p(5),
      "Last 30 days :"
          .text
          .semiBold
          .size(16)
          .make()
          .pOnly(top: 5, bottom: 5, left: 10),
      Card(
        child: ListTile(
          title: "Total Revenue :".text.bold.make(),
          subtitle: "For last 30 days".text.semiBold.make(),
          trailing: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('clients').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                int revenue = 0;
                snapshot.data?.docs.forEach((doc) {
                  Client client = Client.fromJson(doc.data(), doc.id);
                  client.transactions.forEach((transaction) {
                    if ((transaction['time'] as Timestamp).compareTo(
                            Timestamp.fromDate(DateTime(DateTime.now().year,
                                    DateTime.now().month, DateTime.now().day)
                                .subtract(Duration(days: 30)))) >
                        0) if (transaction['credit'])
                      revenue += transaction['amount'] as int;
                  });
                });
                return '₹ +$revenue'
                    .text
                    .bold
                    .color(Colors.green)
                    .size(18)
                    .make();
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ).p(5),
      Card(
        child: ListTile(
          title: "Total Expense :".text.bold.make(),
          subtitle: "For last 30 days".text.semiBold.make(),
          trailing: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('vendors').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                int expense = 0;
                snapshot.data?.docs.forEach((doc) {
                  Vendor client = Vendor.fromJson(doc.data(), doc.id);
                  client.transactions.forEach((transaction) {
                    if ((transaction['time'] as Timestamp).compareTo(
                            Timestamp.fromDate(DateTime(DateTime.now().year,
                                    DateTime.now().month, DateTime.now().day)
                                .subtract(Duration(days: 30)))) >
                        0) if (!transaction['credit'])
                      expense += transaction['amount'] as int;
                  });
                });
                return '₹ -$expense'
                    .text
                    .bold
                    .color(Colors.red)
                    .size(18)
                    .make();
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ).p(5),
      Card(
        child: ListTile(
          title: "Total Personal Expense :".text.bold.make(),
          subtitle: "For last 30 days".text.semiBold.make(),
          trailing: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('personalexpense')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                int expense = 0;
                snapshot.data?.docs.forEach((doc) {
                  PersonalExpense personalExpense =
                      PersonalExpense.fromJson(doc.data(), doc.id);
                  if (personalExpense.time.compareTo(Timestamp.fromDate(
                          DateTime(DateTime.now().year, DateTime.now().month,
                                  DateTime.now().day)
                              .subtract(Duration(days: 30)))) >
                      0) expense += personalExpense.amount;
                });
                return '₹ -$expense'
                    .text
                    .bold
                    .color(Colors.red)
                    .size(18)
                    .make();
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ).p(5),
      SizedBox(
        height: 20,
      )
    ]).scrollVertical();
  }
}
