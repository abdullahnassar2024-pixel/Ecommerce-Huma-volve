
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/home_service.dart';
import '../data/models/product_model.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeService homeService;

  HomeCubit(this.homeService) : super(HomeInitial());

  Future<void> getHomeData() async {
    emit(HomeLoading());

    try {
      final results = await Future.wait([
        homeService.getProducts(),
        homeService.getCategories(),
      ]);

      final products = results[0].map((json) {
        return ProductModel.fromJson(
          Map<String, dynamic>.from(json as Map),
        );
      }).toList();

      final categories = [
        'All',
        ...results[1].map((json) {
          return (json as Map)['name'].toString();
        }),
      ];

      emit(
        HomeSuccess(
          products: products,
          categories: categories,
        ),
      );
    } catch (e) {
      emit(
        HomeError(
          e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
