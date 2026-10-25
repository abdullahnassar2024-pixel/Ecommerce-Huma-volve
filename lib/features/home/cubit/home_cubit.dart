import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/usecases/get_home_data_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHomeDataUseCase getHomeDataUseCase;

  static const int pageSize = 20;
  int _offset = 0;
  int _generation = 0;

  HomeCubit(this.getHomeDataUseCase) : super(HomeInitial());

  Future<void> getHomeData() async {
    final requestGeneration = ++_generation;

    _offset = 0;
    emit(HomeLoading());

    try {
      final (products, categories) = await getHomeDataUseCase(
        limit: pageSize,
        offset: 0,
      );

      if (isClosed || requestGeneration != _generation) return;

      _offset = products.length;

      emit(
        HomeSuccess(
          products: products,
          categories: categories,
          hasMore: products.length == pageSize,
        ),
      );
    } catch (e) {
      if (isClosed || requestGeneration != _generation) return;

      emit(HomeError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> loadMoreProducts() async {
    final currentState = state;
    final requestGeneration = _generation;

    if (currentState is! HomeSuccess ||
        currentState.isLoadingMore ||
        !currentState.hasMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true, clearLoadMoreError: true));

    try {
      final newProducts = await getHomeDataUseCase.repository.getProducts(
        limit: pageSize,
        offset: _offset,
      );

      if (isClosed || requestGeneration != _generation) return;
      _offset += newProducts.length;
      final existingIds = currentState.products
          .map((product) => product.id)
          .toSet();

      final uniqueProducts = newProducts
          .where((product) => !existingIds.contains(product.id))
          .toList();

      emit(
        currentState.copyWith(
          products: [...currentState.products, ...uniqueProducts],
          isLoadingMore: false,
          hasMore: newProducts.length == pageSize,
          clearLoadMoreError: true,
        ),
      );
    } catch (e) {
      if (isClosed || requestGeneration != _generation) return;

      emit(
        currentState.copyWith(
          isLoadingMore: false,
          loadMoreError: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
