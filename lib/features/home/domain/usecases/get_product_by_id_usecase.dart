import '../../../../core/dummy_data.dart';
import '../repositories/home_repository.dart';

class GetProductByIdUseCase {
  final HomeRepository repository;

  GetProductByIdUseCase(this.repository);

  Future<Product> call(int id) async {
    return await repository.getProductById(id);
  }
}