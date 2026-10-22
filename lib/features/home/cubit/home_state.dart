
import '../../../core/dummy_data.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<Product> products;
  final List<String> categories;

  HomeSuccess({
    required this.products,
    required this.categories,
  });
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
