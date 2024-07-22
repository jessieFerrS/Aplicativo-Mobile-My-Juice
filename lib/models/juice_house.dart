import 'package:appmyjuice/models/cart_item.dart';
import 'package:appmyjuice/models/juice.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../services/database/firestore.dart';

class JuiceHouse extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Juice>? _juices;

  JuiceHouse(){
    _loadLastOrderAddress();
    _getJuicesFromDatabase();
  }

  final List<CartItem> _cart = [];

  String _deliveryAddress = '';

  List<Juice>? get menu => _juices;
  List<CartItem> get cart => _cart;
  String get deliveryAddress => _deliveryAddress;

  void addToCart(Juice juice, List<Version> selectedVersions) {
    CartItem? cartItem = _cart.firstWhereOrNull((item) {
      bool isSameJuice = item.juice == juice;
      bool isSameVersions =
          const ListEquality().equals(item.selectedVersions, selectedVersions);

      return isSameJuice && isSameVersions;
    });

    if (cartItem != null) {
      cartItem.quantity++;
    }
    else {
      _cart.add(
        CartItem(
          juice: juice,
          selectedVersions: selectedVersions,
        ),
      );
    }
    notifyListeners();
  }

  void removeFromCart(CartItem cartItem) {
    int cartIndex = _cart.indexOf(cartItem);

    if (cartIndex != -1) {
      if (_cart[cartIndex].quantity > 1) {
        _cart[cartIndex].quantity--;
      } else {
        _cart.removeAt(cartIndex);
      }
    }

    notifyListeners();
  }

  double getTotalPrice() {
    double total = 0.0;

    for (CartItem cartItem in _cart) {
      double itemTotal = cartItem.juice.price;

      for (Version version in cartItem.selectedVersions) {
        itemTotal += version.price;
      }

      total += itemTotal * cartItem.quantity;
    }

    return total;
  }

  int getTotalItemCount() {
    int totalItemCount = 0;

    for (CartItem cartItem in _cart) {
      totalItemCount += cartItem.quantity;
    }

    return totalItemCount;
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void updateDeliveryAddress(String newAddress) {
    _deliveryAddress = newAddress;
    notifyListeners();
  }

  String displayCartReceipt() {
    final receipt = StringBuffer();
    receipt.writeln("Aqui está seu recibo.");
    receipt.writeln();

    String formattedDate = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());

    receipt.writeln(formattedDate);
    receipt.writeln();
    receipt.writeln(" ------------------------------- ");

    for (final cartItem in _cart) {
      receipt.writeln(
          "${cartItem.quantity} x ${cartItem.juice.name} - ${_formatPrice(cartItem.juice.price)}");
      if (cartItem.selectedVersions.isNotEmpty) {
        receipt
            .writeln("  Adicionais: ${_formatVersions(cartItem.selectedVersions)}");
      }
      receipt.writeln();
    }

    receipt.writeln(" -------------------------------- ");
    receipt.writeln();
    receipt.writeln("Quantidade de itens: ${getTotalItemCount()}");
    receipt.writeln("Total: ${_formatPrice(getTotalPrice())}");
    receipt.writeln();
    receipt.writeln("Entregue em: $deliveryAddress");

    return receipt.toString();
  }

  String _formatPrice(double price) {
    return "R\$${price.toStringAsFixed(2)}";
  }

  String _formatVersions(List<Version> versions) {
    return versions
        .map((version) => "${version.name} (${_formatPrice(version.price)})")
        .join(", ");
  }

  Future<void> _loadLastOrderAddress() async {
    String lastOrderAddress = await _firestoreService.getLastOrderAddress();
    _deliveryAddress = lastOrderAddress;
    notifyListeners();
  }

  void loadLastOrderAddress() async {
    await _loadLastOrderAddress();
  }

  Future<void> _getJuicesFromDatabase() async {
    _juices = await _firestoreService.getJuicesFromDatabase();
    notifyListeners();
  }
}