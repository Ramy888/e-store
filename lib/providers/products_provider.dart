import 'package:flutter/cupertino.dart';

import '../models/product_model.dart';

class ProductProvider with ChangeNotifier {
  bool _isGridView = true;
  List<Product> _products = [];

  bool get isGridView => _isGridView;

  List<Product> get products => [..._products];

  void toggleView() {
    _isGridView = !_isGridView;
    notifyListeners();
  }

  void loadDummyProducts() {
    _products = List.generate(
      10,
          (index) => Product(
        id: index + 1,
        title: 'Product ${index + 1}',
        description:
        'This is a detailed description of Product ${index + 1} Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet',
        price: (15.99 + index).roundToDouble(),
        imageUrl: 'https://picsum.photos/id/${index + 1}/300/300',
      ),
    );
    notifyListeners();
  }
}