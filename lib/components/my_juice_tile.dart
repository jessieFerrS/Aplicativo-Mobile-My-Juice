import 'package:appmyjuice/models/juice.dart';
import 'package:flutter/material.dart';

class JuiceTile extends StatelessWidget {
  final Juice juice;
  final void Function()? onTap;

  const JuiceTile({
    super.key,
    required this.juice,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                // text juice details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        juice.name,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        'R\$ ${juice.price}',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        juice.description,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 15),

                // juice images
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(juice.imagePath, height: 120),
                ),
              ],
            ),
          ),
        ),

        Divider(
          color: Theme.of(context).colorScheme.inversePrimary,
          endIndent: 25,
          indent: 25,
        ),
      ],
    );
  }
}
