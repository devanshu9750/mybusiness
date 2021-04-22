import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';

class EditClient extends StatefulWidget {
  final String clientDocId;

  const EditClient({Key? key, required this.clientDocId}) : super(key: key);

  @override
  _EditClientState createState() => _EditClientState();
}

class _EditClientState extends State<EditClient> {
  String name = '', email = '', phoneNumber = '', address = '';

  _editClient() {
    if (name.isNotBlank) {
      if (phoneNumber.length < 10) {
        Fluttertoast.showToast(msg: "Invalid phone number");
        return;
      }
      showModal(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Are you sure ?"),
          actions: [
            TextButton(
                onPressed: () {
                  context.pop();
                  context.pop();
                },
                child: Text("Cancel")),
            TextButton(onPressed: () => context.pop(), child: Text("No")),
            TextButton(
                onPressed: () async {
                  if (name == widget.clientDocId) {
                    await FirebaseFirestore.instance
                        .collection('clients')
                        .doc(name)
                        .update({
                      'name': name,
                      'address': address,
                      'phoneNumber': phoneNumber,
                      'email': email
                    });
                    context.pop();
                    context.pop();
                  } else {
                    CollectionReference reference =
                        FirebaseFirestore.instance.collection('clients');

                    DocumentSnapshot snapshot =
                        await reference.doc(widget.clientDocId).get();

                    await reference.doc(name).set(snapshot.data() ?? {});

                    await reference.doc(name).update({
                      'name': name,
                      'address': address,
                      'phoneNumber': phoneNumber,
                      'email': email
                    });
                    context.pop();
                    context.pop();
                    context.pop();
                    reference.doc(widget.clientDocId).delete();
                  }
                },
                child: Text("Yes"))
          ],
        ),
      );
    } else {
      Fluttertoast.showToast(msg: 'Name cannot be empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Edit Client".text.make(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editClient(),
        child: Icon(Icons.check),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('clients')
            .doc(widget.clientDocId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            name = snapshot.data?.data()?['name'] ?? '';
            email = snapshot.data?.data()?['email'] ?? '';
            address = snapshot.data?.data()?['address'] ?? '';
            phoneNumber = snapshot.data?.data()?['phoneNumber'] ?? '';

            return VStack([
              "Name".text.size(16).make(),
              SizedBox(
                height: 10,
              ),
              VxTextField(
                value: name,
                borderRadius: 10,
                borderType: VxTextFieldBorderType.roundLine,
                onChanged: (value) => name = value.trim(),
              ),
              SizedBox(
                height: 10,
              ),
              "Phone Number".text.size(16).make(),
              SizedBox(
                height: 10,
              ),
              VxTextField(
                value: phoneNumber,
                borderRadius: 10,
                borderType: VxTextFieldBorderType.roundLine,
                onChanged: (value) => phoneNumber = value.trim(),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(
                height: 10,
              ),
              "Email".text.size(16).make(),
              SizedBox(
                height: 10,
              ),
              VxTextField(
                value: email,
                borderRadius: 10,
                borderType: VxTextFieldBorderType.roundLine,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => email = value.trim(),
              ),
              SizedBox(
                height: 10,
              ),
              "Address".text.size(16).make(),
              SizedBox(
                height: 10,
              ),
              VxTextField(
                value: address,
                borderRadius: 10,
                borderType: VxTextFieldBorderType.roundLine,
                maxLine: null,
                onChanged: (value) => address = value.trim(),
              )
            ]).scrollVertical().pOnly(left: 15, top: 15, right: 15);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
