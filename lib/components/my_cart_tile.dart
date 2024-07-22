import 'package:appmyjuice/models/cart_item.dart';
import 'package:appmyjuice/models/juice_house.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'my_quantity_selector.dart';


class MyCartTile extends StatelessWidget {
  final CartItem cartItem;

  const MyCartTile({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Consumer<JuiceHouse>(
      builder: (context, juiceHouse, child) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
         children: [
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Row(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 // juice image
                 ClipRRect(
                   borderRadius: BorderRadius.circular(8),
                   child: Image.asset(
                     cartItem.juice.imagePath,
                      height: 100,
                      width: 100,
                   ),
                 ),

                 const SizedBox(width: 10),

                 // name and price
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     //juice name
                     Text(cartItem.juice.name, style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontWeight: FontWeight.bold),),

                     //juice price
                     Text(
                       'R\$ ${cartItem.juice.price}',
                       style: TextStyle(
                         color: Theme.of(context).colorScheme.tertiary),
                     ),

                     const SizedBox(height: 10),

                     // increment or decrement quantity
                     QuantitySelector(
                       quantity: cartItem.quantity,
                       juice: cartItem.juice,
                       onDecrement: () {
                         juiceHouse.removeFromCart(cartItem);
                       },
                       onIncrement: () {
                         juiceHouse.addToCart(
                             cartItem.juice, cartItem.selectedVersions);
                       },
                     ),

                    ],
                 ),

               ],
             ),
           ),

           // versions
           SizedBox(
             height: cartItem.selectedVersions.isEmpty ? 0 : 60,
             child: ListView(
               scrollDirection: Axis.horizontal,
               padding: const EdgeInsets.only(left: 10,bottom: 10,right: 10),
               children: cartItem.selectedVersions
                   .map(
                     (version) => Padding(
                       padding: const EdgeInsets.only(right: 8.0),
                       child: FilterChip(
                         label: Row(
                           children: [
                             //version name
                             Text(version.name),

                             //version price
                             Text(' (R\$${version.price})'),
                           ],
                         ),
                         shape: StadiumBorder(
                           side: BorderSide(
                             color: Theme.of(context).colorScheme.primary),),
                         onSelected: (value) {},
                         backgroundColor: Theme.of(context).colorScheme.primary,
                         labelStyle: TextStyle(
                           color: Theme.of(context).colorScheme.tertiary,
                           fontSize: 12,
                         ),
                       ),
                     ),
                   )
                   .toList(),
             ),
           ),

         ],
        ),
      ),
    );
  }
}

