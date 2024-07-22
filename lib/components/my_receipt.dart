import 'package:appmyjuice/models/juice_house.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyReceipt extends StatelessWidget {
  const MyReceipt({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25, top: 0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Agradeçemos por sua preferência!"),
            const SizedBox(height: 25),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                border: Border.all(color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(30),
              child: Consumer<JuiceHouse>(
                builder: (context, juiceHouse, child) =>
                    Text(juiceHouse.displayCartReceipt()),
              ),
            ),
            const SizedBox(height: 25),
            const Text("Tempo estimado para a entrega: 30 min"),
          ],
        ),
      ),
    );
  }
}
