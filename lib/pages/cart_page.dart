import 'package:appmyjuice/components/my_button.dart';
import 'package:appmyjuice/components/my_cart_tile.dart';
import 'package:appmyjuice/models/juice_house.dart';
import 'package:appmyjuice/pages/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Consumer<JuiceHouse>(
      builder: (context, juiceHouse, child) {
        final userCart = juiceHouse.cart;

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          appBar: AppBar(
            title: const Text(
              "C A R R I N H O",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              Visibility(
                visible: userCart.isNotEmpty,
                child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                        title: const Text(
                          "Você tem certeza que deseja limpar o carrinho?",
                          style: TextStyle(color: Colors.white),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Cancelar",
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              juiceHouse.clearCart();
                            },
                            child: const Text(
                              "Confirmar",
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    if (userCart.isEmpty)
                      const Expanded(
                        child: Center(
                          child: Text("CARRINHO VAZIO..."),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: userCart.length,
                          itemBuilder: (context, index) {
                            final cartItem = userCart[index];
                            return MyCartTile(cartItem: cartItem);
                          },
                        ),
                      ),
                  ],
                ),
              ),
              Visibility(
                visible: userCart.isNotEmpty,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                      color: Theme.of(context).colorScheme.surface,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text("Total:", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontSize: 18, fontWeight: FontWeight.bold),),
                          Text("R\$${juiceHouse.getTotalPrice().toStringAsFixed(2)}", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    MyButton(
                      onTap: () {
                        final address = context.read<JuiceHouse>().deliveryAddress;
                        if (address.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                              title: const Text("Endereço não informado", style: TextStyle(color: Colors.white),),
                              content: const Text("Por favor, informe um endereço antes de finalizar a compra.", style: TextStyle(color: Colors.white)),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("OK", style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PaymentPage(),
                            ),
                          );
                        }
                      },
                      text: "Finalizar",
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}