import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/screens/product_details.screen.dart';

import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';
import '../widgets/product_grid_item.dart';
import 'cart_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
          () => context.read<ProductProvider>().loadDummyProducts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Store'),
        actions: [
          IconButton(
            icon: Icon(
              context.watch<ProductProvider>().isGridView
                  ? Icons.list
                  : Icons.grid_view,
            ),
            onPressed: () {
              context.read<ProductProvider>().toggleView();
            },
          ),
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CartScreen(),
                    ),
                  );
                },
              ),
              Consumer<CartProvider>(
                builder: (context, cart, child) {
                  return cart.itemCount > 0
                      ? Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${cart.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                      : Container();
                },
              ),
            ],
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          final products = productProvider.products;
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: productProvider.isGridView
                ? GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: products.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7, // Adjusted for the new design
                crossAxisSpacing: 12,
                mainAxisSpacing:
                16, // Increased for the protruding cart button
              ),
              itemBuilder: (ctx, i) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailsScreen(product: products[i]),
                    ),
                  );
                },
                child: ProductGridItem(
                  product: products[i],
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: products.length,
              itemBuilder: (ctx, i) => Card(
                margin: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 0,
                ),
                child: ListTile(
                  leading: Hero(
                    tag: 'product-${products[i].id}',
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(products[i].imageUrl),
                    ),
                  ),
                  title: Text(products[i].title),
                  subtitle:
                  Text('\$${products[i].price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      context.read<CartProvider>().addItem(products[i]);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Added to cart!'),
                          duration: const Duration(seconds: 1),
                          action: SnackBarAction(
                            label: 'UNDO',
                            onPressed: () {
                              context
                                  .read<CartProvider>()
                                  .removeItem(products[i].id);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
