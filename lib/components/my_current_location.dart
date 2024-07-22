import 'package:appmyjuice/models/juice_house.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCurrentLocation extends StatelessWidget {
  MyCurrentLocation({super.key});

  final textController = TextEditingController();

  void openLocationSearchBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        textController.text = context.read<JuiceHouse>().deliveryAddress;
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          title: const Text("Endereço para Entrega"),
          content: TextField(
            controller: textController,
            maxLines: null,
            decoration: InputDecoration(
              hintText: "Digite o endereço...",
              errorText: textController.text.trim().isEmpty ? 'Por favor, insira um endereço válido.' : null,
              errorStyle: const TextStyle(color: Colors.red),
            ),
          ),
          actions: [
            // cancel button
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),

            MaterialButton(
              onPressed: () {
                String newAddress = textController.text;
                if (newAddress.trim().isEmpty) {
                  textController.clear();
                  textController.text = '';
                  return;
                }
                context.read<JuiceHouse>().updateDeliveryAddress(newAddress);
                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Entregar Agora",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          GestureDetector(
            onTap: () => openLocationSearchBox(context),
            child: Row(
              children: [
                Consumer<JuiceHouse>(
                  builder: (context, juiceHouse, child) => Flexible(
                    child: Text(
                      juiceHouse.deliveryAddress != '' ? juiceHouse.deliveryAddress : 'Informe seu endereço',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Icon(
                  Icons.edit,
                  size: 15,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
