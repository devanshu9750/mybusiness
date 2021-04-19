import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mybusiness/models/client_modal.dart';
import 'package:mybusiness/screens/add_client.dart';
import 'package:mybusiness/screens/client_transactions.dart';
import 'package:velocity_x/velocity_x.dart';

class ClientsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VStack([
      SizedBox(
        height: 5,
      ),
      OpenContainer(
        closedElevation: 0,
        openElevation: 0,
        closedColor: context.canvasColor,
        openColor: context.canvasColor,
        closedBuilder: (context, action) => ListTile(
          leading: Icon(Icons.add),
          title: "Add Client".text.make(),
        ),
        openBuilder: (context, action) => AddClient(),
      ),
      Divider(
        thickness: 2,
        height: 5,
      ),
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('clients').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            List<Client> clients = [];
            snapshot.data?.docs.forEach((element) {
              clients.add(Client.fromJson(element.data(), element.id));
            });
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(
                thickness: 2,
              ),
              shrinkWrap: true,
              itemCount: clients.length,
              itemBuilder: (context, index) => OpenContainer(
                  openElevation: 0,
                  closedElevation: 0,
                  openColor: context.canvasColor,
                  closedColor: context.canvasColor,
                  closedBuilder: (context, action) => ListTile(
                        leading: CircleAvatar(
                          child: clients[index].name[0].text.make(),
                        ),
                        title: clients[index].name.text.make(),
                      ),
                  openBuilder: (context, action) => ClientTransactions(
                        clientDocId: clients[index].name,
                      )),
            ).pOnly(top: 5);
          }
          return SizedBox(
            height: 100,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      )
    ]);
  }
}
