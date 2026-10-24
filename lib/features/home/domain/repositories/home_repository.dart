
import '../../../../core/dummy_data.dart';

abstract class HomeRepository {
  Future<List<Product>> getProducts();

  Future<List<String>> getCategories();
}
