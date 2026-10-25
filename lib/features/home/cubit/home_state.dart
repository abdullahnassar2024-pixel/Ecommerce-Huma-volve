
import '../../../core/dummy_data.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}


class HomeSuccess extends HomeState {
  final List<Product> products;
  final List<String> categories;

  final bool isLoadingMore;
  final bool hasMore;
  final String? loadMoreError;

  HomeSuccess({
    required this.products,
    required this.categories,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.loadMoreError,
  });

  HomeSuccess copyWith({
    List<Product>? products,
    List<String>? categories,
    bool? isLoadingMore,
    bool? hasMore,
    String? loadMoreError,
    bool clearLoadMoreError = false,
  }) {
    return HomeSuccess(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      loadMoreError: clearLoadMoreError
          ? null
          : loadMoreError ?? this.loadMoreError,
    );
  }
}


class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
