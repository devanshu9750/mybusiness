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
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
