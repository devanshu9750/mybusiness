import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mybusiness/models/client_model.dart';
import 'package:mybusiness/models/vendor_model.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

const List months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

class ReportsScreen extends StatelessWidget {
  Widget get _buildTransactionsThisMonth => Scaffold(
        appBar: AppBar(
          title: Text(
              "${months[DateTime.now().month - 1]} - ${DateTime.now().year}"),
        ),
        body: VStack([
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('clients').snapshots(),
            builder: (context, clientsCollection) {
              if (clientsCollection.connectionState == ConnectionState.active)
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('vendors')
                      .snapshots(),
                  builder: (context, vendorsCollection) {
                    if (vendorsCollection.connectionState ==
                        ConnectionState.active) {
                      List<Client> clients = List.generate(
                          clientsCollection.data?.docs.length ?? 0,
                          (index) => Client.fromJson(
                              clientsCollection.data?.docs[index].data() ?? {},
                              clientsCollection.data?.docs[index].id ?? ''));

                      List<Vendor> vendors = List.generate(
                          vendorsCollection.data?.docs.length ?? 0,
                          (index) => Vendor.fromJson(
                              vendorsCollection.data?.docs[index].data() ?? {},
                              vendorsCollection.data?.docs[index].id ?? ''));

                      List<Map> transactions = [];

                      for (Client client in clients) {
                        client.transactions.forEach((element) {
                          if ((element['time'] as Timestamp).compareTo(
                                  Timestamp.fromDate(DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      1))) >
                              0) {
                            transactions.add({client.name: element});
                          }
                        });
                      }

                      for (Vendor vendor in vendors) {
                        vendor.transactions.forEach((element) {
                          if ((element['time'] as Timestamp).compareTo(
                                  Timestamp.fromDate(DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      1))) >
                              0) {
                            transactions.add({vendor.name: element});
                          }
                        });
                      }
                      transactions = transactions.sortedBy((a, b) =>
                          (a[a.keys.toList()[0]]['time'] as Timestamp)
                              .compareTo(
                                  b[b.keys.toList()[0]]['time'] as Timestamp));

                      transactions = transactions.reversed.toList();

                      return ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => Divider(
                          thickness: 2,
                          height: 5,
                        ),
                        itemCount: transactions.length,
                        itemBuilder: (context, index) => ListTile(
                          title: Text(
                            transactions[index].keys.toList()[0],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: transactions[index][transactions[index]
                                        .keys
                                        .toList()[0]]['credit']
                                    ? Colors.green
                                    : Colors.red),
                          ),
                          trailing: Text(
                            "₹ ${transactions[index][transactions[index].keys.toList()[0]]['credit'] ? '+' : '-'} ${transactions[index][transactions[index].keys.toList()[0]]['amount'].toString()}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: transactions[index][transactions[index]
                                        .keys
                                        .toList()[0]]['credit']
                                    ? Colors.green
                                    : Colors.red),
                          ),
                          subtitle: Text(
                            DateFormat().format((transactions[index]
                                        [transactions[index].keys.toList()[0]]
                                    ['time'] as Timestamp)
                                .toDate()),
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          )
        ]).scrollVertical(),
      );

  @override
  Widget build(BuildContext context) {
    return VStack([
      Card(
        child: ListTile(
          title: "Transactions for this month".text.size(16).semiBold.make(),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ).onInkTap(() {
        context.push((context) => _buildTransactionsThisMonth);
      }).p(10)
    ]).scrollVertical();
  }
}
