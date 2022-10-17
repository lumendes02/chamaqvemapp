import 'package:chamaqvem/models/produto.dart';
import 'package:get/get.dart';

class cartController extends GetxController {
  var _products = {}.obs;

  void addProduct(Produto product) {
    if (_products.containsKey(product)) {
      _products[product] += 1;
    } else {
      _products[product] = 1;
    }
  }
}
