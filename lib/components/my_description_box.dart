import 'package:flutter/material.dart';

class MyDescriptionBox extends StatelessWidget {
  const MyDescriptionBox({super.key});

  @override
  Widget build(BuildContext context) {
    var myPrimaryText = TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontSize: 15);
    var mySecondaryText = TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 10);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        border: Border.all(color: Theme.of(context).colorScheme.inversePrimary),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text('R\$ 1.99', style: myPrimaryText,),
              Text('Taxa de Entrega', style: mySecondaryText,),
            ],
          ),
          const SizedBox(width: 10, height: 10),
          Column(
            children: [
              Text('15 - 30 min', style: myPrimaryText),
              Text('Tempo de Entrega', style: mySecondaryText,),
            ],
          ),
        ],
      ),
    );
  }
}