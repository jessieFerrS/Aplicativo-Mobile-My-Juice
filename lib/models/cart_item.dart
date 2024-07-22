import 'package:appmyjuice/models/juice.dart';

class CartItem {
  Juice juice;
  List<Version> selectedVersions;
  int quantity;

  CartItem({
    required this.juice,
    required this.selectedVersions,
    this.quantity = 1,
  });

  double get totalPrice {
    double versionsPrice =
        selectedVersions.fold(0, (sum, version) => sum + version.price);
    return (juice.price + versionsPrice) * quantity;
  }
}