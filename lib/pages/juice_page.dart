import 'package:appmyjuice/components/my_button.dart';
import 'package:appmyjuice/models/juice.dart';
import 'package:appmyjuice/models/juice_house.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JuicePage extends StatefulWidget {
  final Juice juice;
  final Map<Version,bool> selectedVersions = {};

  JuicePage({
    super.key,
    required this.juice,
  }){
    // initialize selected versions to be false
    for (Version version in juice.availableVersions) {
      selectedVersions[version] = false;
    }
  }

  @override
  State<JuicePage> createState() => _JuicePageState();
}

class _JuicePageState extends State<JuicePage> {
  // method to add to cart
  void addToCart(Juice juice, Map<Version, bool> selectedVersions) {

    // close the current juice page to go back to menu
    Navigator.pop(context);

    // format the selected versions
    List<Version> currentlySelectedVersions = [];
    for (Version version in widget.juice.availableVersions) {
      if (widget.selectedVersions[version] == true) {
        currentlySelectedVersions.add(version);
      }
    }

    // add to cart
    context.read<JuiceHouse>().addToCart(juice, currentlySelectedVersions);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
        Scaffold(
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(widget.juice.imagePath),

                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    // juice name
                    Text(
                      widget.juice.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),

                      // juice price
                    Text(
                      'R\$ ${widget.juice.price}',
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),

                    const SizedBox(height: 10),

                    Text(widget.juice.description),

                    const SizedBox(height: 10),

                    Divider(color: Theme.of(context).colorScheme.primary),

                    const SizedBox(height: 10),

                      Text(
                        "Adicionais",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: widget.juice.availableVersions.length,
                          itemBuilder: (context, index) {
                            Version version = widget.juice.availableVersions[index];

                            return CheckboxListTile(
                              title: Text(version.name),
                              subtitle: Text(
                                'R\$ ${version.price}',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                ),
                              ),
                              value: widget.selectedVersions[version],
                              onChanged: (bool? value) {
                                setState(() {
                                  widget.selectedVersions[version] = value!;
                                });
                              },
                            );
                          },
                        ),
                    ),
                    ],
                  ),
                ),

                //button -> add to cart
                MyButton(
                    text: "Adicionar ao Carrinho",
                    onTap: () => addToCart(widget.juice, widget.selectedVersions),
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        ),

        //back button
        SafeArea(
          child: Opacity(
            opacity: 0.6,
            child: Container(
              margin: const EdgeInsets.only(left: 25),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
      ],
    );
  }
}