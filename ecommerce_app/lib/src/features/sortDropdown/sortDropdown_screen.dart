import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* some example data */
class Product {
  Product({required this.name, required this.price});

  final String name;
  final double price;
}

final _products = [
  Product(name: 'iPhone', price: 999),
  Product(name: 'cookie', price: 2),
  Product(name: 'ps5', price: 500),
];

/* the options we want to sort for */
enum ProductSortType {
  name,
  price,
}

//exp: es wird irgendwie ein Initialzustand übergeben, der aber später über .state nicht mehr gilt
final productSortTypeProvider = StateProvider<ProductSortType>(
  // We return the default sort type, here name.
  (ref) => ProductSortType.name,
);

//exp: dieser Provider listened den anderen und gibt die Daten dementsprechend weiter
final productsProvider = Provider<List<Product>>((ref) {
  final sortType = ref.watch(productSortTypeProvider);
  switch (sortType) {
    case ProductSortType.name:
      return _products.sorted((a, b) => a.name.compareTo(b.name));
    case ProductSortType.price:
      return _products.sorted((a, b) => a.price.compareTo(b.price));
  }
});

class MySortPage extends ConsumerWidget {
  const MySortPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products =
        ref.watch(productsProvider); //exp: hier werden nur Produkte angeschaut
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          DropdownButton<ProductSortType>(
            // When the sort type changes, this will rebuild the dropdown
            // to update the icon shown.
            value: ref.watch(productSortTypeProvider),
            // When the user interacts with the dropdown, we update the provider state.
            onChanged: (value) =>
                //exp: hier wird nun der provider geupdated, der initial sagt, es muss nach name gefiltert werden
                //exp: dabei wird das über .state geändert
                ref.read(productSortTypeProvider.notifier).state = value!,
            items: const [
              DropdownMenuItem(
                value: ProductSortType.name,
                child: Icon(Icons.sort_by_alpha),
              ),
              DropdownMenuItem(
                value: ProductSortType.price,
                child: Icon(Icons.sort),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('${product.price} \$'),
          );
        },
      ),
    );
  }
}
