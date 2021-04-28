import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mybusiness/models/personal_expense_modal.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

class PersonalExpensesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection('personalexpense').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          List<PersonalExpense> personalexpenses = [];
          snapshot.data?.docs.forEach((element) {
            personalexpenses
                .add(PersonalExpense.fromJson(element.data(), element.id));
          });

          return ListView.separated(
            itemCount: personalexpenses.length,
            separatorBuilder: (context, index) => Divider(
              thickness: 2,
              height: 5,
            ),
            itemBuilder: (context, index) => ListTile(
              title:
                  '${(personalexpenses[index].message.isNotBlank) ? personalexpenses[index].message : 'None'}'
                      .text
                      .semiBold
                      .size(16)
                      .make(),
              subtitle: DateFormat()
                  .format(personalexpenses[index].time.toDate())
                  .text
                  .semiBold
                  .make(),
              trailing: "- ₹ ${personalexpenses[index].amount}"
                  .text
                  .semiBold
                  .color(Colors.red)
                  .size(18)
                  .make(),
            ).onInkLongPress(() {
              showModal(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("What would you like to do ?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: Text("Cancel"),
                    ),
                    TextButton(
                        onPressed: () {
                          String _amount =
                                  personalexpenses[index].amount.toString(),
                              _message = personalexpenses[index].message;
                          showModal(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Edit"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    if (!_amount.isNotBlank) return;
                                    await FirebaseFirestore.instance
                                        .collection('personalexpense')
                                        .doc(personalexpenses[index].id)
                                        .update({
                                      'amount': int.parse(_amount),
                                      'message': _message
                                    });
                                    context.pop();
                                    context.pop();
                                  },
                                  child: Text('Save'),
                                )
                              ],
                              content: VStack([
                                Text("Amount *"),
                                SizedBox(
                                  height: 10,
                                ),
                                VxTextField(
                                  value: _amount,
                                  hint: "Amount",
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) => _amount = value.trim(),
                                  borderType: VxTextFieldBorderType.roundLine,
                                  borderRadius: 10,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("Message (optional)"),
                                SizedBox(
                                  height: 10,
                                ),
                                VxTextField(
                                  value: _message,
                                  hint: 'Message',
                                  onChanged: (value) => _message = value.trim(),
                                  borderType: VxTextFieldBorderType.roundLine,
                                  borderRadius: 10,
                                )
                              ]),
                            ),
                          );
                        },
                        child: Text("Edit")),
                    TextButton(
                        onPressed: () {
                          showModal(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Are you sure ?"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      context.pop();
                                    },
                                    child: Text("No")),
                                TextButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('personalexpense')
                                          .doc(personalexpenses[index].id)
                                          .delete();
                                      context.pop();
                                      context.pop();
                                    },
                                    child: Text("Yes")),
                              ],
                            ),
                          );
                        },
                        child: Text("Delete")),
                  ],
                ),
              );
            }),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
