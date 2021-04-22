import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mybusiness/models/client_model.dart';
import 'package:mybusiness/screens/clients_side/edit_client.dart';
import 'package:mybusiness/screens/components.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

class ClientTransactions extends StatelessWidget {
  final String clientDocId;

  const ClientTransactions({Key? key, required this.clientDocId})
      : super(key: key);

  _transact(bool credit, BuildContext context) {
    String _amount = '';
    String _message = '';

    showModal(
      context: context,
      builder: (context) => AlertDialog(
        title: Text((credit) ? "Credit" : "Debit"),
        actions: [
          TextButton(onPressed: () => context.pop(), child: Text("Cancel")),
          TextButton(
              onPressed: () {
                Components.showLoading(context);
                if (_amount.isNotBlank)
                  FirebaseFirestore.instance
                      .collection('clients')
                      .doc(clientDocId)
                      .get()
                      .then((value) {
                    List transactions = value.data()?['transactions'];
                    transactions.add({
                      'amount': int.parse(_amount),
                      'message': _message,
                      'time': Timestamp.now(),
                      'credit': credit
                    });
                    FirebaseFirestore.instance
                        .collection('clients')
                        .doc(clientDocId)
                        .update({'transactions': transactions});
                  });
                context.pop();
                context.pop();
              },
              child: Text("Submit"))
        ],
        content: VStack([
          Text('Amount'),
          SizedBox(
            height: 10,
          ),
          VxTextField(
            hint: "Amount",
            borderType: VxTextFieldBorderType.roundLine,
            borderRadius: 10,
            keyboardType: TextInputType.number,
            onChanged: (value) => _amount = value.trim(),
          ),
          SizedBox(
            height: 10,
          ),
          Text('Message (Optional)'),
          SizedBox(
            height: 10,
          ),
          VxTextField(
            hint: "Message",
            borderType: VxTextFieldBorderType.roundLine,
            borderRadius: 10,
            onChanged: (value) => _message = value,
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: clientDocId.text.make(),
        actions: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                context.push((context) => EditClient(clientDocId: clientDocId));
              })
        ],
      ),
      body: ZStack([
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('clients')
              .doc(clientDocId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              Client client = Client.fromJson(
                  snapshot.data?.data() ?? {}, snapshot.data?.id ?? '');
              return ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => Divider(
                  height: 5,
                  thickness: 2,
                ),
                itemCount: client.transactions.length,
                reverse: true,
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    '${(client.transactions[index]['message'].toString().isNotBlank ? client.transactions[index]['message'] : client.transactions[index]['credit'] ? 'Credit' : 'Debit')}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                      '${DateFormat().format((client.transactions[index]['time'] as Timestamp).toDate())}'),
                  trailing: Text(
                    '${client.transactions[index]['credit'] ? "+" : "-"} ₹ ${client.transactions[index]['amount']}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: client.transactions[index]['credit']
                            ? Colors.green
                            : Colors.red),
                  ),
                ).onInkTap(() {
                  Fluttertoast.showToast(msg: "Long Press to see options");
                }).onInkLongPress(() {
                  showModal(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('What would you like to do ?'),
                      actions: [
                        TextButton(
                            onPressed: () => context.pop(),
                            child: Text("Cancel")),
                        TextButton(
                            onPressed: () {
                              showModal(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Are you sure ?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => context.pop(),
                                      child: Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        client.transactions.removeAt(index);
                                        FirebaseFirestore.instance
                                            .collection('clients')
                                            .doc(clientDocId)
                                            .update({
                                          'transactions': client.transactions
                                        });
                                        context.pop();
                                        context.pop();
                                      },
                                      child: Text('Yes'),
                                    )
                                  ],
                                ),
                              );
                            },
                            child: Text("Delete")),
                        TextButton(
                            onPressed: () {
                              String _amount = client.transactions[index]
                                          ['amount']
                                      .toString(),
                                  _message =
                                      client.transactions[index]['message'];
                              context.pop();
                              showModal(
                                context: context,
                                builder: (context) => AlertDialog(
                                  actions: [
                                    TextButton(
                                      onPressed: () => context.pop(),
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if (_amount.isNotBlank)
                                          showModal(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text('Are you sure ?'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () =>
                                                        context.pop(),
                                                    child: Text('No')),
                                                TextButton(
                                                    onPressed: () {
                                                      client.transactions[index]
                                                              ['amount'] =
                                                          int.parse(_amount);
                                                      client.transactions[index]
                                                              ['message'] =
                                                          _message;
                                                      FirebaseFirestore.instance
                                                          .collection('clients')
                                                          .doc(clientDocId)
                                                          .update({
                                                        'transactions':
                                                            client.transactions
                                                      });
                                                      context.pop();
                                                      context.pop();
                                                    },
                                                    child: Text('Yes'))
                                              ],
                                            ),
                                          );
                                        else
                                          Fluttertoast.showToast(
                                              msg: 'Amount cannot be empty');
                                      },
                                      child: Text("Save"),
                                    )
                                  ],
                                  title: Text('Edit'),
                                  content: VStack([
                                    Text('Amount *'),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    VxTextField(
                                      value: _amount,
                                      keyboardType: TextInputType.number,
                                      borderRadius: 10,
                                      borderType:
                                          VxTextFieldBorderType.roundLine,
                                      onChanged: (value) =>
                                          _amount = value.trim(),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('Message'),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    VxTextField(
                                      value: _message,
                                      borderRadius: 10,
                                      borderType:
                                          VxTextFieldBorderType.roundLine,
                                      onChanged: (value) =>
                                          _message = value.trim(),
                                    )
                                  ]),
                                ),
                              );
                            },
                            child: Text("Edit"))
                      ],
                    ),
                  );
                }),
              ).pOnly(top: 5);
            }
            return SizedBox(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
        Positioned(
          bottom: 0,
          child: VStack([
            ButtonBar(
              children: [
                ElevatedButton(
                  onPressed: () => _transact(true, context),
                  child: "😁 Credit".text.size(16).make(),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (states) => Colors.green),
                  ),
                ).w(150),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () => _transact(false, context),
                  child: "😢 Debit".text.size(16).make(),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (states) => Colors.red),
                  ),
                ).w(160)
              ],
              alignment: MainAxisAlignment.center,
            ),
            Card(
              child: Center(
                child: ListTile(
                  title: "Total :".text.bold.size(18).make(),
                  trailing: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('clients')
                        .doc(clientDocId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        List transactions = snapshot.data?['transactions'];
                        int total = 0;
                        transactions.forEach((element) {
                          if (element['credit'])
                            total += element['amount'] as int;
                          else
                            total -= element['amount'] as int;
                        });
                        return Text(
                          '₹ $total',
                          style: TextStyle(
                              color: total < 0 ? Colors.red : Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        );
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                ),
              ),
            ).h(70)
          ]).w(context.screenWidth),
        ),
      ]).w(context.screenWidth).h(context.screenHeight),
    );
  }
}
