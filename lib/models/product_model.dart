class Product {
  String code;
  String name;
  String description;
  int cp;
  int sp;
  int quantity;

  Product(
      {required this.code,
      required this.cp,
      required this.description,
      required this.name,
      required this.sp,
      required this.quantity});

  Product.fromJson(Map<String, dynamic> json, String id)
      : code = id,
        description = json['description'],
        name = json['name'],
        cp = json['cp'],
        sp = json['sp'],
        quantity = json['quantity'];

  Map<String, dynamic> get toJson => {
        'name': name,
        'description': description,
        'cp': cp,
        'sp': sp,
        'quantity': quantity
      };
}
