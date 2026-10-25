
import '../../../../core/dummy_data.dart';

abstract class HomeRepository {
  Future<List<Product>> getProducts({
    int limit = 20,
    int offset = 0,
  });

  Future<List<String>> getCategories();
}
