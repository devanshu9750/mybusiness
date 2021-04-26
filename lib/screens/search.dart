import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mybusiness/models/client_model.dart';
import 'package:mybusiness/models/product_model.dart';
import 'package:mybusiness/models/vendor_model.dart';
import 'package:mybusiness/screens/clients_side/client_transactions.dart';
import 'package:mybusiness/screens/products_side/product_detail.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

class ClientSearch extends SearchDelegate<String> {
  static List<QueryDocumentSnapshot>? data;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          context.pop();
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Client> clients = [];

    if (query.isEmpty) {
      data?.forEach((doc) {
        clients.add(Client.fromJson(doc.data(), doc.id));
      });
    } else {
      data?.forEach((doc) {
        if (doc.id.toLowerCase().contains(query.toLowerCase()) ||
            doc
                .data()['phoneNumber']
                .toLowerCase()
                .contains(query.toLowerCase()))
          clients.add(Client.fromJson(doc.data(), doc.id));
      });
    }

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
        return ListTile(
          trailing: "₹ $balance"
              .text
              .semiBold
              .size(18)
              .color((balance < 0 ? Colors.red : Colors.green))
              .make(),
          leading: CircleAvatar(
            child: clients[index].name[0].text.make(),
          ),
          title: clients[index].name.text.semiBold.size(16).make(),
          subtitle: "${DateFormat().format(clients[index].editedAt.toDate())}"
              .text
              .make(),
        ).onInkTap(() {
          context.nextReplacementPage(
              ClientTransactions(clientDocId: clients[index].name));
        });
      },
    ).pOnly(top: 5);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Client> clients = [];

    if (query.isEmpty) {
      data?.forEach((doc) {
        clients.add(Client.fromJson(doc.data(), doc.id));
      });
    } else {
      data?.forEach((doc) {
        if (doc.id.toLowerCase().contains(query.toLowerCase()) ||
            doc
                .data()['phoneNumber']
                .toLowerCase()
                .contains(query.toLowerCase()))
          clients.add(Client.fromJson(doc.data(), doc.id));
      });
    }

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
        return ListTile(
          trailing: "₹ $balance"
              .text
              .semiBold
              .size(18)
              .color((balance < 0 ? Colors.red : Colors.green))
              .make(),
          leading: CircleAvatar(
            child: clients[index].name[0].text.make(),
          ),
          title: clients[index].name.text.semiBold.size(16).make(),
          subtitle: "${DateFormat().format(clients[index].editedAt.toDate())}"
              .text
              .make(),
        ).onInkTap(() {
          context.nextReplacementPage(
              ClientTransactions(clientDocId: clients[index].name));
        });
      },
    ).pOnly(top: 5);
  }
}

//* --------------------------------------------------------------------------------------------------------------------- //
//* --------------------------------------------------------------------------------------------------------------------- //
//* ----------------------------------------------- Vendor Search ------------------------------------------------------- //
//* --------------------------------------------------------------------------------------------------------------------- //
//* --------------------------------------------------------------------------------------------------------------------- //

class VendorSearch extends SearchDelegate<String> {
  static List<QueryDocumentSnapshot>? data;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          context.pop();
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Vendor> vendors = [];

    if (query.isEmpty) {
      data?.forEach((doc) {
        vendors.add(Vendor.fromJson(doc.data(), doc.id));
      });
    } else {
      data?.forEach((doc) {
        if (doc.id.toLowerCase().contains(query.toLowerCase()) ||
            doc
                .data()['phoneNumber']
                .toLowerCase()
                .contains(query.toLowerCase()))
          vendors.add(Vendor.fromJson(doc.data(), doc.id));
      });
    }

    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        thickness: 2,
      ),
      itemCount: vendors.length,
      itemBuilder: (context, index) {
        int balance = 0;
        vendors[index].transactions.forEach((element) {
          if (element['credit'])
            balance += element['amount'] as int;
          else
            balance -= element['amount'] as int;
        });
        return ListTile(
          trailing: "₹ $balance"
              .text
              .bold
              .size(16)
              .color((balance < 0 ? Colors.red : Colors.green))
              .make(),
          leading: CircleAvatar(
            child: vendors[index].name[0].text.make(),
          ),
          title: vendors[index].name.text.make(),
          subtitle: "${DateFormat().format(vendors[index].createdAt.toDate())}"
              .text
              .make(),
        ).onInkTap(() {
          context.nextReplacementPage(
              ClientTransactions(clientDocId: vendors[index].name));
        });
      },
    ).pOnly(top: 5);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Vendor> vendors = [];

    if (query.isEmpty) {
      data?.forEach((doc) {
        vendors.add(Vendor.fromJson(doc.data(), doc.id));
      });
    } else {
      data?.forEach((doc) {
        if (doc.id.toLowerCase().contains(query.toLowerCase()) ||
            doc
                .data()['phoneNumber']
                .toLowerCase()
                .contains(query.toLowerCase()))
          vendors.add(Vendor.fromJson(doc.data(), doc.id));
      });
    }

    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        thickness: 2,
      ),
      itemCount: vendors.length,
      itemBuilder: (context, index) {
        int balance = 0;
        vendors[index].transactions.forEach((element) {
          if (element['credit'])
            balance += element['amount'] as int;
          else
            balance -= element['amount'] as int;
        });
        return ListTile(
          trailing: "₹ $balance"
              .text
              .bold
              .size(16)
              .color((balance < 0 ? Colors.red : Colors.green))
              .make(),
          leading: CircleAvatar(
            child: vendors[index].name[0].text.make(),
          ),
          title: vendors[index].name.text.make(),
          subtitle: "${DateFormat().format(vendors[index].createdAt.toDate())}"
              .text
              .make(),
        ).onInkTap(() {
          context.nextReplacementPage(
              ClientTransactions(clientDocId: vendors[index].name));
        });
      },
    ).pOnly(top: 5);
  }
}

//* --------------------------------------------------------------------------------------------------------------------- //
//* --------------------------------------------------------------------------------------------------------------------- //
//* ----------------------------------------------- Product Search ------------------------------------------------------ //
//* --------------------------------------------------------------------------------------------------------------------- //
//* --------------------------------------------------------------------------------------------------------------------- //

class ProductSearch extends SearchDelegate<String> {
  static List<QueryDocumentSnapshot>? data;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          context.pop();
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Product> products = [];

    if (query.isEmpty) {
      data?.forEach((doc) {
        products.add(Product.fromJson(doc.data(), doc.id));
      });
    } else {
      data?.forEach((doc) {
        if (doc.id.toLowerCase().contains(query.toLowerCase()) ||
            doc.data()['name'].toLowerCase().contains(query.toLowerCase()))
          products.add(Product.fromJson(doc.data(), doc.id));
      });
    }

    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        thickness: 2,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            child: Text("${products[index].quantity}"),
          ),
          title: "${products[index].code}".text.bold.size(16).make(),
          subtitle: (products[index].name.isNotBlank)
              ? "${products[index].name}".text.semiBold.make()
              : null,
          trailing: RichText(
              text: TextSpan(children: <TextSpan>[
            TextSpan(
              text: "₹ ${products[index].cp}",
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            TextSpan(
              text: " / ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            TextSpan(
              text: "₹ ${products[index].sp}",
              style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            )
          ])),
        ).onInkTap(() {
          context.nextReplacementPage(
              ProductDetail(productDocId: products[index].code));
        });
      },
    ).pOnly(top: 5);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Product> products = [];

    if (query.isEmpty) {
      data?.forEach((doc) {
        products.add(Product.fromJson(doc.data(), doc.id));
      });
    } else {
      data?.forEach((doc) {
        if (doc.id.toLowerCase().contains(query.toLowerCase()) ||
            doc.data()['name'].toLowerCase().contains(query.toLowerCase()))
          products.add(Product.fromJson(doc.data(), doc.id));
      });
    }

    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        thickness: 2,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            child: Text("${products[index].quantity}"),
          ),
          title: "${products[index].code}".text.bold.size(16).make(),
          subtitle: (products[index].name.isNotBlank)
              ? "${products[index].name}".text.semiBold.make()
              : null,
          trailing: RichText(
              text: TextSpan(children: <TextSpan>[
            TextSpan(
              text: "₹ ${products[index].cp}",
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            TextSpan(
              text: " / ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            TextSpan(
              text: "₹ ${products[index].sp}",
              style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            )
          ])),
        ).onInkTap(() {
          context.nextReplacementPage(
              ProductDetail(productDocId: products[index].code));
        });
      },
    ).pOnly(top: 5);
  }
}
