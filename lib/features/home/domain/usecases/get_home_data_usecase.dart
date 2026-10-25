
import '../../../../core/dummy_data.dart';
import '../repositories/home_repository.dart';

class GetHomeDataUseCase {
  final HomeRepository repository;

  GetHomeDataUseCase(this.repository);


  Future<(List<Product>, List<String>)> call({
    int limit = 20,
    int offset = 0,
  }) async {
    final products = await repository.getProducts(
      limit: limit,
      offset: offset,
    );

    final categories = await repository.getCategories();

    return (products, categories);
  }

}
