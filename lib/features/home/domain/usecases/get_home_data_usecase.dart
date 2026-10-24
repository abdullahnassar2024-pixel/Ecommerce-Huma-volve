
import '../../../../core/dummy_data.dart';
import '../repositories/home_repository.dart';

class GetHomeDataUseCase {
  final HomeRepository repository;

  GetHomeDataUseCase(this.repository);

  Future<(List<Product>, List<String>)> call() async {
    final products = await repository.getProducts();
    final categories = await repository.getCategories();

    return (products, categories);
  }
}
