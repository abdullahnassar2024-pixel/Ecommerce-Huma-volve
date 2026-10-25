
import '../../../../core/dummy_data.dart';
import '../../domain/repositories/home_repository.dart';
import '../home_service.dart';
import '../models/product_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeService homeService;

  HomeRepositoryImpl(this.homeService);

  @override
  Future<List<Product>> getProducts({
    int limit = 20,
    int offset = 0,
  }) async {
    final data = await homeService.getProducts(
      limit: limit,
      offset: offset,
    );

    return data.map((json) {
      return ProductModel.fromJson(
        Map<String, dynamic>.from(json as Map),
      );
    }).toList();
  }

  @override
  Future<List<String>> getCategories() async {
    final data = await homeService.getCategories();

    return [
      'All',
      ...data.map((json) {
        return (json as Map)['name'].toString();
      }),
    ];
  }
}
